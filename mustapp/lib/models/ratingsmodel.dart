class Ratingsmodel {
  late int productid;
  late List<String> productratings;
  late List<String> comments;

  Ratingsmodel(
      {required this.productid,
      required this.comments,
      required this.productratings});
  Ratingsmodel.fromJson(Map<String, dynamic> json) {
    productid = json['productid'];
    comments = json['comments'];
    productratings = json['productratings'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productid'] = this.productid;
    data['comments'] = this.comments;
    data['productratings'] = this.productratings;
    return data;
  }
}
