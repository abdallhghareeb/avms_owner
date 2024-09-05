class DocumentType {
  final int id;
  final String name;
  final String? note;
  final String? description;
  final bool isDeleted;
  final String? createdUserId;
  final String? createdUserName;
  final String? lastUpdatedUserId;
  final String? updatedUserName;
  final String? deletedUserId;
  final String? deletedUserName;

  DocumentType({
    required this.id,
    required this.name,
    this.note,
    this.description,
    required this.isDeleted,
    this.createdUserId,
    this.createdUserName,
    this.lastUpdatedUserId,
    this.updatedUserName,
    this.deletedUserId,
    this.deletedUserName,
  });

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['id'],
      name: json['name'],
      note: json['note'],
      description: json['description'],
      isDeleted: json['isDeleted'],
      createdUserId: json['createdUserId'],
      createdUserName: json['createdUserName'],
      lastUpdatedUserId: json['lastUpdatedUserId'],
      updatedUserName: json['updatedUserName'],
      deletedUserId: json['deletedUserId'],
      deletedUserName: json['deletedUserName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'note': note,
      'description': description,
      'isDeleted': isDeleted,
      'createdUserId': createdUserId,
      'createdUserName': createdUserName,
      'lastUpdatedUserId': lastUpdatedUserId,
      'updatedUserName': updatedUserName,
      'deletedUserId': deletedUserId,
      'deletedUserName': deletedUserName,
    };
  }
}
