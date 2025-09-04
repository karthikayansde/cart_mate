class UomModel {
  String? sId;
  String? code;
  String? unit;
  String? category;

  UomModel({this.sId, this.code, this.unit, this.category});

  UomModel.fromJson(Map<String, dynamic> json) {
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
