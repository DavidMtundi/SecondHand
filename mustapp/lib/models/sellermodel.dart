class Sellermodel {
  late int sellerid;
  late String sellername;

  late String sellerphone;
  late String sellerprofilepicpath;
  late String sellersurname;
  late String selleremail;
  late String sellerpassword;
  late List<int> productids;

  Sellermodel(
      {required this.sellerid,
      required this.sellername,
      required this.sellerphone,
      required this.sellerprofilepicpath,
      required this.sellersurname,
      required this.selleremail,
      required this.sellerpassword,
      required this.productids});

  Sellermodel.fromJson(Map<String, dynamic> json) {
    sellerid = json['sellerid'];
    sellername = json['sellername'];

    sellerphone = json['sellerphone'];
    sellerprofilepicpath = json['sellerprofilepicpath'];
    sellersurname = json['sellersurname'];
    selleremail = json['selleremail'];
    sellerpassword = json['sellerpassword'];
    productids = json['productids'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sellerid'] = this.sellerid;
    data['sellername'] = this.sellername;
    data['sellerphone'] = this.sellerphone;
    data['sellerprofilepicpath'] = this.sellerprofilepicpath;
    data['sellersurname'] = this.sellersurname;
    data['selleremail'] = this.selleremail;
    data['sellerpassword'] = this.sellerpassword;
    data['productids'] = this.productids;
    return data;
  }
}
