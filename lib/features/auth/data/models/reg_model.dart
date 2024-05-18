class RegModel {
  int? statusCode;
  dynamic meta;
  bool? succeeded;
  dynamic message;
  dynamic errors;
  Data? data;

  RegModel(
      {this.statusCode,
        this.meta,
        this.succeeded,
        this.message,
        this.errors,
        this.data});

  RegModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    meta = json['meta'];
    succeeded = json['succeeded'];
    message = json['message'];
    errors = json['errors'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['meta'] = this.meta;
    data['succeeded'] = this.succeeded;
    data['message'] = this.message;
    data['errors'] = this.errors;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? confirmMessage;
  Null? token;
  String? expiresOn;

  Data({this.confirmMessage, this.token, this.expiresOn});

  Data.fromJson(Map<String, dynamic> json) {
    confirmMessage = json['confirmMessage'];
    token = json['token'];
    expiresOn = json['expiresOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confirmMessage'] = this.confirmMessage;
    data['token'] = this.token;
    data['expiresOn'] = this.expiresOn;
    return data;
  }
}