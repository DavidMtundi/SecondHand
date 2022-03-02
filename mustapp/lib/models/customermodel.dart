class Customermodel {
  late int customerid;
  late String customername;

  late String customerphone;
  late String customerprofilepicpath;
  late String customersurname;
  late String customeremail;
  late String customerpassword;

  Customermodel({
    required this.customerid,
    required this.customername,
    required this.customerphone,
    required this.customerprofilepicpath,
    required this.customersurname,
    required this.customeremail,
    required this.customerpassword,
  });

  Customermodel.fromJson(Map<String, dynamic> json) {
    customerid = json['customerid'];
    customername = json['customername'];

    customerphone = json['customerphone'];
    customerprofilepicpath = json['customerprofilepicpath'];
    customersurname = json['customersurname'];
    customeremail = json['customeremail'];
    customerpassword = json['customerpassword'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerid'] = this.customerid;
    data['customername'] = this.customername;
    data['customerphone'] = this.customerphone;
    data['customerprofilepicpath'] = this.customerprofilepicpath;
    data['customersurname'] = this.customersurname;
    data['customeremail'] = this.customeremail;
    data['customerpassword'] = this.customerpassword;

    return data;
  }
}
