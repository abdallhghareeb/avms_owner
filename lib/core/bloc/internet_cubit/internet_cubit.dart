import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity? connectivity;
  StreamSubscription? connectivityStreamSubscription;

  InternetCubit({this.connectivity}) : super(InternetLoading()) {
    connectivityStreamSubscription =
        connectivity?.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (connectivityResult == ConnectivityResult.mobile) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (connectivityResult == ConnectivityResult.none) {
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
    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
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
