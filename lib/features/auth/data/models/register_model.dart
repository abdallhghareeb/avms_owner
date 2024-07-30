class RegisterModel {
  int? statusCode;
  dynamic meta;
  bool? succeeded;
  String? message;
  dynamic errors;
  dynamic data;

  RegisterModel({
    this.statusCode,
    this.meta,
    this.succeeded,
    this.message,
    this.errors,
    this.data,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    meta = json['Meta'];
    succeeded = json['Succeeded'];
    message = json['Message'];
    errors = json['Errors'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['Meta'] = this.meta;
    data['Succeeded'] = this.succeeded;
    data['Message'] = this.message;
    data['Errors'] = this.errors;
    data['Data'] = this.data;
    return data;
  }
}
