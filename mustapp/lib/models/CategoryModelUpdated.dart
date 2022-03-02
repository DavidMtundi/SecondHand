class CategoryModelUpdated {
  String title;
  String Description;
  String imagename;
  CategoryModelUpdated({
    required this.title,
    required this.Description,
    required this.imagename,
  });
}

List<CategoryModelUpdated> AllCategories = [
  CategoryModelUpdated(
      imagename: "assets/images/Electronics.jpg",
      title: "Electronics",
      Description:
          "this includes anything to deal with Electronics search as laptops,phones, subwoofers etc"),
  CategoryModelUpdated(
      imagename: "assets/images/Home.jpg",
      title: "Home",
      Description:
          "this includes anything that's required in a home such as utensils etc"),
  CategoryModelUpdated(
      imagename: "assets/images/Dressing.jpg",
      title: "Dressing",
      Description: "this includes anything to deal with Dressing and etc"),
  CategoryModelUpdated(
      imagename: "assets/images/Furnitures.jpg",
      title: "Furniture",
      Description: "this includes anything to deal with Furniture and etc"),
  CategoryModelUpdated(
      imagename: "assets/images/Services.jpg",
      title: "Services",
      Description: "this includes anything to deal with Dressing and etc"),
];
