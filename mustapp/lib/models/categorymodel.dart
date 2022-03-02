class Categorymodel {
  late int categoryid;
  late String categoryname;

  Categorymodel({required this.categoryid, required this.categoryname});
  Categorymodel.fromJson(Map<String, dynamic> json) {
    categoryid = json['categoryid'];
    categoryname = json['categoryname'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryid'] = this.categoryid;
    data['categoryname'] = this.categoryname;
    return data;
  }
}
