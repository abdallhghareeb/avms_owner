class AreaAllModel {
  final int id;
  final String name;
  final int areaTypeId;
  final String areaTypeName;
  final int zIndex;
  final int? areaParentId;
  final String? areaParentName;
  final int status;
  final bool isUnit;
  final bool isActive;
  final String? note;
  final String? description;
  final bool isDeleted;
  final int? createdUserId;
  final String? createdUserName;
  final List<dynamic> owners;

  AreaAllModel({
    required this.id,
    required this.name,
    required this.areaTypeId,
    required this.areaTypeName,
    required this.zIndex,
    this.areaParentId,
    this.areaParentName,
    required this.status,
    required this.isUnit,
    required this.isActive,
    this.note,
    this.description,
    required this.isDeleted,
    this.createdUserId,
    this.createdUserName,
    required this.owners,
  });

  factory AreaAllModel.fromJson(Map<String, dynamic> json) {
    return AreaAllModel(
      id: json['id'],
      name: json['name'],
      areaTypeId: json['areaTypeId'],
      areaTypeName: json['areaTypeName'],
      zIndex: json['zIndex'],
      areaParentId: json['areaParentId'],
      areaParentName: json['areaParentName'],
      status: json['status'],
      isUnit: json['isUnit'],
      isActive: json['isActive'],
      note: json['note'],
      description: json['description'],
      isDeleted: json['isDeleted'],
      createdUserId: json['createdUserId'],
      createdUserName: json['createdUserName'],
      owners: json['owners'],
    );
  }
}
