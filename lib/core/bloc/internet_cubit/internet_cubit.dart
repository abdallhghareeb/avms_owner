import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity? connectivity;
  StreamSubscription? connectivityStreamSubscription;

  InternetCubit({this.connectivity}) : super(InternetLoading()) {
    connectivityStreamSubscription =
        connectivity?.onConnectivityChanged.listen((connectivityResults) {
      if (connectivityResults.contains(ConnectivityResult.wifi)) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (connectivityResults.isEmpty ||
          connectivityResults.contains(ConnectivityResult.none)) {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected(ConnectionType connectionType) {
    emit(InternetConnected(connectionType: connectionType));

  }

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription?.cancel();
    return super.close();
  }

  Future<bool?> checkConnectivity() async {
    Connectivity().checkConnectivity().then((List<ConnectivityResult> results) {
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        emit(InternetDisconnected());
        return false;
      } else {
        emit(InternetConnected());
        return true;
      }
    });
    return null;
  }
}
