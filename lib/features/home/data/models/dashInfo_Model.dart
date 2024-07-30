class DashboardTabsInfo {
  final int totalInvitation;
  final int entered;
  final int exited;
  final int pending;

  DashboardTabsInfo({
    required this.totalInvitation,
    required this.entered,
    required this.exited,
    required this.pending,
  });

  factory DashboardTabsInfo.fromJson(Map<String, dynamic> json) {
    return DashboardTabsInfo(
      totalInvitation: json['data']['totalInvitation'],
      entered: json['data']['entered'],
      exited: json['data']['exited'],
      pending: json['data']['pending'],
    );
  }
}
