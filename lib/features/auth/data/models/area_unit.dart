
class Area {
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
  final String note;
  final String description;
  final bool isDeleted;
  final String createdUserId;
  final String? createdUserName;
  final String? lastUpdatedUserId;
  final String? updatedUserName;
  final String? deletedUserId;
  final String? deletedUserName;
  final String? visitStartTime;
  final String? visitEndTime;
  final String number;
  final List<Owner> owners;

  Area({
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
    required this.note,
    required this.description,
    required this.isDeleted,
    required this.createdUserId,
    this.createdUserName,
    this.lastUpdatedUserId,
    this.updatedUserName,
    this.deletedUserId,
    this.deletedUserName,
    this.visitStartTime,
    this.visitEndTime,
    required this.number,
    required this.owners,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
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
      note: json['note'] ?? '',
      description: json['description'] ?? '',
      isDeleted: json['isDeleted'],
      createdUserId: json['createdUserId'],
      createdUserName: json['createdUserName'],
      lastUpdatedUserId: json['lastUpdatedUserId'],
      updatedUserName: json['updatedUserName'],
      deletedUserId: json['deletedUserId'],
      deletedUserName: json['deletedUserName'],
      visitStartTime: json['visitStartTime'],
      visitEndTime: json['visitEndTime'],
      number: json['number'],
      owners: (json['owners'] as List<dynamic>)
          .map((item) => Owner.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'areaTypeId': areaTypeId,
      'areaTypeName': areaTypeName,
      'zIndex': zIndex,
      'areaParentId': areaParentId,
      'areaParentName': areaParentName,
      'status': status,
      'isUnit': isUnit,
      'isActive': isActive,
      'note': note,
      'description': description,
      'isDeleted': isDeleted,
      'createdUserId': createdUserId,
      'createdUserName': createdUserName,
      'lastUpdatedUserId': lastUpdatedUserId,
      'updatedUserName': updatedUserName,
      'deletedUserId': deletedUserId,
      'deletedUserName': deletedUserName,
      'visitStartTime': visitStartTime,
      'visitEndTime': visitEndTime,
      'number': number,
      'owners': owners.map((owner) => owner.toJson()).toList(),
    };
  }
}
class Owner {
  final String id;
  final String userName;

  Owner({
    required this.id,
    required this.userName,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
    };
  }
}
