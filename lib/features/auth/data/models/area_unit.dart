
class AreaResponse {
  final int statusCode;
  final dynamic meta;
  final bool succeeded;
  final String message;
  final dynamic errors;
  final List<Area> data;

  AreaResponse({
    required this.statusCode,
    this.meta,
    required this.succeeded,
    required this.message,
    this.errors,
    required this.data,
  });

  factory AreaResponse.fromJson(Map<String, dynamic> json) {
    return AreaResponse(
      statusCode: json['statusCode'],
      meta: json['meta'],
      succeeded: json['succeeded'],
      message: json['message'],
      errors: json['errors'],
      data: List<Area>.from(json['data'].map((x) => Area.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'meta': meta,
      'succeeded': succeeded,
      'message': message,
      'errors': errors,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

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
  final String? note;
  final String? description;
  final bool isDeleted;
  final dynamic createdUserId;
  final dynamic createdUserName;
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
    this.note,
    this.description,
    required this.isDeleted,
    this.createdUserId,
    this.createdUserName,
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
      note: json['note'],
      description: json['description'],
      isDeleted: json['isDeleted'],
      createdUserId: json['createdUserId'],
      createdUserName: json['createdUserName'],
      owners: List<Owner>.from(json['owners'].map((x) => Owner.fromJson(x))),
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
      'owners': List<dynamic>.from(owners.map((x) => x.toJson())),
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
