class Cartmodel {
  late String personid;
  late List<int> productids;
  Cartmodel({
    required this.personid,
    required this.productids,
  });

  Cartmodel.fromJson(Map<String, dynamic> json) {
    personid = json['personid'];
    productids = json['productids'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['personid'] = personid;
    data['productids'] = productids;

    return data;
  }
}
