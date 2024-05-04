import 'dart:developer';

import 'package:avms/features/home/domain/entities/info.dart';

class InfoModel extends Info {
  InfoModel({
    required int totalTodayVisits,
    required int totalUpcomingVisits,
    required int totalExpiredVisits,
  }) : super(
          totalTodayVisits: totalTodayVisits,
          totalUpcomingVisits: totalUpcomingVisits,
          totalExpiredVisits: totalExpiredVisits,
        );

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      totalTodayVisits: json['totalTodayVisits'] ?? 0,
      totalUpcomingVisits: json['totalUpcomingVisits'] ?? 0,
      totalExpiredVisits: json['totalExpiredVisits'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalTodayVisits': totalTodayVisits,
        'totalUpcomingVisits': totalUpcomingVisits,
        'totalExpiredVisits': totalExpiredVisits
      };
}
