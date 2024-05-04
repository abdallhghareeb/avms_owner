import 'package:equatable/equatable.dart';

class Info extends Equatable {
  final int totalTodayVisits;
  final int totalUpcomingVisits;
  final int totalExpiredVisits;

  Info({
    required this.totalTodayVisits,
    required this.totalUpcomingVisits,
    required this.totalExpiredVisits,
  });

  @override
  String toString() {
    return 'Info{totalTodayVisits: $totalTodayVisits, totalUpcomingVisits: $totalUpcomingVisits, totalExpiredVisits: $totalExpiredVisits}';
  }

  @override
  List<Object?> get props => [
        totalTodayVisits,
        totalUpcomingVisits,
        totalExpiredVisits,
      ];
}
