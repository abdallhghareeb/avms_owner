class DocumentType {
  final int id;
  final String name;
  final String note;
  final String description;
  final bool isDeleted;

  DocumentType({
    required this.id,
    required this.name,
    required this.note,
    required this.description,
    required this.isDeleted,
  });

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['id'],
      name: json['name'],
      note: json['note'],
      description: json['description'],
      isDeleted: json['isDeleted'],
    );
  }
}
