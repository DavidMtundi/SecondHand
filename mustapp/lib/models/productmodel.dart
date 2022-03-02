class Productmodel {
  late String category;
  late String colors;
  late String description;
  late String discountprice;
  late String highlights;
  late String id;
  late String imageurl;
  late String price;
  late String searchtag;
  late String seller;
  late String sellerid;
  late int stock;
  late String title;
  late String variant;
  late String sellerphone;

  Productmodel({
    required this.category,
    required this.id,
    required this.title,
    required this.imageurl,
    required this.description,
    required this.discountprice,
    required this.price,
    required this.variant,
    required this.seller,
    required this.sellerid,
    required this.sellerphone,
    required this.searchtag,
    required this.colors,
    required this.stock

    // required this.productcolors,
    //  required this.productsearchtags,
  });

  Productmodel.fromJson(Map<String, dynamic> json) {
    category = json['productcategory'] ?? "Electronics";
    id = json['productid'] ?? "0";
    colors = json['productcolors'] ?? "unloaded";
    title = json['producttitle'] ?? "unloaded";
    imageurl = json['productimageurl'] ??
        "https://firebasestorage.googleapis.com/v0/b/eshop1-5c342.appspot.com/o/items%2Fimagenotfound.jpg?alt=media&token=https://firebasestorage.googleapis.com/v0/b/eshop1-5c342.appspot.com/o/items%2Fimagenotfound.jpg?alt=media&token=bc8b3afe-633a-4648-a6b5-bc6618014f1d";

    // category = json['productcategory'];
    description = json['productdescription'] ?? "unloaded";
    discountprice = json['productdiscountprice'] ?? "000";
    stock = json['productstock'] ?? 0;
    price = json['productoriginalprice'] ?? "000";
    variant = json['productvariant'] ?? "yes";
    sellerid = json['productsellerid'] ?? "1";
    seller = json['productseller'] ?? "unloaded";
    highlights = json['producthighlights'] ?? "unloaded";
    sellerphone = json['sellerphone'] ?? "00000";
    searchtag = json['productsearchtag'] ?? "test";
    // productsearchtags = json['productsearchtags'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productid'] = id;
    data['producttitle'] = title;
    data['productimageurl'] = imageurl;
    data['productdescription'] = description;
    data['productdiscountprice'] = discountprice;
    data['productoriginalprice'] = price;
    data['productvariant'] = variant;
    data['productseller'] = seller;
    data['producthighlights'] = highlights;
    data['productcolors'] = colors;
    data['productsellerid'] = sellerid;
    data['productseller'] = seller;
    data['searchtag'] = searchtag;

    //  data['productcolors'] = this.productcolors;
    data['productcategory'] = category;
    data['sellerphone'] = sellerphone;

    //  data['productsearchtags'] = this.productsearchtags;

    return data;
  }

  factory Productmodel.fromMap(Map<String, dynamic> json) {
    return Productmodel(
      category: json['productcategory'] ?? "Electronics",
      id: json['productid'] ?? "6",
      colors: json['productcolors'] ?? "unloaded",
      title: json['producttitle'] ?? "unloaded",
      imageurl: json['productimageurl'] ??
          "https://firebasestorage.googleapis.com/v0/b/eshop1-5c342.appspot.com/o/items%2Fproduct_1638861153570.jpg?alt=media&token=077defb8-f116-4c4a-a28e-fd4e77a78393",

      // category = json['productcategory'];
      description: json['productdescription'] ?? "unloaded",
      discountprice: json['productdiscountprice'] ?? "1000",
      stock : json['productstock'] ?? 0,
      price: json['productoriginalprice'] ?? "600",
      variant: json['productvariant'] ?? "yes",
      sellerid: json['productsellerid'] ?? "0AoDc7OZlFM9ZkjdbaHkKIq5nJw2",
      seller: json['productseller'] ?? "david",
      //highlights : json['producthighlights'] ?? "unloaded",
      sellerphone: json['sellerphone'] ?? "0701010101",
      searchtag: json['productsearchtag'] ?? "test",
    );
    // productsearchtags = json['productsearchtags'];
  }
}
