import 'package:flutter/material.dart';

typedef void VoidCallBack();

class Constants {

  static const double listViewImageWidth = 120.0;
  static const double listViewImageHeight = 120.0;
  static const double titleFontSize = 20.0;
  static const double labelFontSize = 20.0;
  static const double hintFontSize = 20.0;
  static const double textFontSize = 22.0;
  static const double subTitleFontSize = 16.0;
  static const double speciesImageBorderRadius = 15.0;
  static const int speciesHeroTransitionDuration = 800;
  static const double iconSize = 40.0;

  static const String fontFamily = 'Montserrat';
  static const TextStyle buttonTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0);
  static const TextStyle subButtonTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 15.0);
  static const TextStyle appTitle = TextStyle(fontFamily: fontFamily, fontSize: 15.0,color: Colors.green);
  static const TextStyle appBarTitleStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0,color: Colors.white);
  static const TextStyle titleTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.bold);


  static const Color mainColor = Colors.blueGrey;
  static const Color backGroundColor = Colors.grey;
  static const Color iconColor = Colors.lime;
  static const TextStyle speciesTitleStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.titleFontSize);
  static const TextStyle defaultTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.textFontSize);

  // Form Input text
  static const TextStyle formLabelTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.labelFontSize);
  static const TextStyle formHintTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.hintFontSize,color: mainColor);
  static const TextStyle formDefaultTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.textFontSize,color: mainColor);

  // Camera
  static const double cameraPhotoPlaceHolder = 225.0;
  static const String imageType = "jpg";

  // Info message
  static const double infoTextFontSize = 25.0;
  static const Color infoTextColor = Colors.blue;

  // Login & Register Page
  static const Color registerBtnBorderColor = Colors.blueGrey;
  static const int minUsernameLength = 4;
  static const int minPasswordLength = 6;

  // Documents and folders inside the app document folder
  static const String appImagesFolder = "images";

  // List Item Color
  static const Color selectedListItemBackgroundColor = Colors.lime;
  static const Color defaultListItemBackgroundColor = Colors.white;
  static const double listViewDividerHeight = 10.0;
  static const Color listViewDividerColor = Colors.grey;

}




