class ItemsModel {
  String? message;
  List<Data>? data;

  ItemsModel({this.message, this.data});

  ItemsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? imageUrl;
  num? quantity;
  UomId? uomId;
  String? notes;
  MateId? mateId;
  MateId? createdBy;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
        this.name,
        this.imageUrl,
        this.quantity,
        this.uomId,
        this.notes,
        this.mateId,
        this.createdBy,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    quantity = json['quantity'];
    uomId = json['uomId'] != null ? new UomId.fromJson(json['uomId']) : null;
    notes = json['notes'];
    mateId =
    json['mateId'] != null ? new MateId.fromJson(json['mateId']) : null;
    createdBy = json['createdBy'] != null
        ? new MateId.fromJson(json['createdBy'])
        : null;
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['quantity'] = this.quantity;
    if (this.uomId != null) {
      data['uomId'] = this.uomId!.toJson();
    }
    data['notes'] = this.notes;
    if (this.mateId != null) {
      data['mateId'] = this.mateId!.toJson();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class UomId {
  String? sId;
  String? code;
  String? unit;
  String? category;

  UomId({this.sId, this.code, this.unit, this.category});

  UomId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    unit = json['unit'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['code'] = this.code;
    data['unit'] = this.unit;
    data['category'] = this.category;
    return data;
  }
}

class MateId {
  String? sId;
  String? name;

  MateId({this.sId, this.name});

  MateId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
