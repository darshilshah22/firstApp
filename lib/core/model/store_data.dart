class StoreData{
  String? id;
  String? logo;
  String? data1;
  String? data2;

  StoreData({this.id, this.logo, this.data1, this.data2});

  StoreData.fromJson(Map<String, dynamic> json):
        id = json["id"],
        logo = json["logo"],
        data1 = json["data1"],
        data2 = json["data2"];

  Map<String, dynamic> toJson() => {
    'id': id,
    'logo': logo,
    'data1': data1,
    'data2': data2
  };
}