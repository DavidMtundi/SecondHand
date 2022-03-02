import 'package:flutter/material.dart';

final List<String> imgList = [
  "assets/images/Electronics.jpg",
  "assets/images/Home.jpg",
  "assets/images/Dressing.jpg",
  "assets/images/Services.jpg"
];

int userid = 2;

//lets define the custom fontsize and the container sizes for different screens
late double customfontsize;
late double customcontainerheight;
late double custombuttonwidth;
late double custombuttonheight;
late double customscreenwidth;
late double customscreenheight;

double CustomHeight(context, height) {
  double defaultvalue = MediaQuery.of(context).size.height;
  return (height * defaultvalue) / 785;
}

double customdividewidth(context, width) {
  double defaultvalue = MediaQuery.of(context).size.width;
  return (defaultvalue / 360) * (defaultvalue / width);
}

double customdivideheight(context, height) {
  double defaultvalue = MediaQuery.of(context).size.height;
  return (defaultvalue / 785) * (defaultvalue / height);
}

double CustomWidth(context, width) {
  double defaultvalue = MediaQuery.of(context).size.width;
  return (width * defaultvalue) / 360;
}

double customfont(context, font) {
  double defaultvalue = MediaQuery.of(context).size.width;
  return (font * defaultvalue) / 360;
}



const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

OutlineInputBorder outlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(CustomWidth(context, 15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
