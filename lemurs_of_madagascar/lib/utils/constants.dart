import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef void VoidCallBack();

class Constants {


  static const String appName  = "Lemurs Of Madagascar";
  static const String appCreed = "Lemur-watching with Russ. Mittermeier";



  static const double authorListViewImageWidth = 400.0;
  static const double listViewImageWidth = 120.0;
  static const double listViewImageHeight = 120.0;
  static const double titleFontSize = 20.0;
  static const double labelFontSize = 20.0;
  static const double hintFontSize = 20.0;
  static const double textFontSize = 22.0;
  static const double commentFontSize = 18.0;
  static const double subTextFontSize = 16.0;
  static const double subTitleFontSize = 16.0;
  static const double speciesImageBorderRadius = 15.0;
  static const int speciesHeroTransitionDuration = 800;
  static const double iconSize = 40.0;
  static const int recordLimit = 5;// Raha atao 10 ity dia lasa tsy mi-charge tsara ilay Species Sary ao @ SpeciesList
  static const double siteImageBorderRadius = 10.0;
  static const int siteHeroTransitionDuration = 600;

  static const String fontFamily = 'Montserrat';
  static const TextStyle flatButtonTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0,color: mainColor);
  static const TextStyle flatRedButtonTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0,color: Colors.red);
  static const TextStyle buttonTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0);
  static const TextStyle subButtonTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 15.0);
  static const TextStyle appTitle = TextStyle(fontFamily: fontFamily, fontSize: 15.0,color: Colors.green);
  static const TextStyle appBarTitleStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0,color: Colors.white);
  static const TextStyle titleTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.bold);
  static const TextStyle deleteButtonTextStyle = TextStyle(fontFamily: fontFamily, fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.w600);

  static const Color backGroundColor = Colors.grey;
  static const Color iconColor = Colors.lime;
  static const TextStyle speciesTitleStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.titleFontSize);
  static const TextStyle defaultTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.textFontSize);
  static const TextStyle defaultCommentTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.commentFontSize);
  static const TextStyle defaultSubTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.subTextFontSize,fontWeight: FontWeight.w500);

  // Form Input text
  static const TextStyle formLabelTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.labelFontSize);
  static const TextStyle formHintTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.hintFontSize,color: mainColor);
  static const TextStyle formDefaultTextStyle = TextStyle(fontFamily: fontFamily,fontSize: Constants.textFontSize,color: mainColor);

  // Camera
  static const double cameraPhotoPlaceHolder = 100.0;
  static const Color cameraPlaceHolderColor = Colors.grey;
  static const String imageType = "jpg";

  // Info message
  static const double infoTextFontSize = 25.0;
  static const Color infoTextColor = Colors.blue;

  // Login & Register Page
  static const Color registerBtnBorderColor = Colors.blueGrey;
  static const int minUsernameLength = 4;
  static const int minPasswordLength = 6;

  // Documents and folders inside the app document folder
  static const String publicFolder = "public://";
  static const String appImagesFolder = "/images/";
  static const String appImagesAssetsFolder = "assets/images/";
  static const String appInstructionsAssetsFolder = "assets/instructions/";
  static const String http = "http";

  // List Item Color
  static const Color selectedListItemBackgroundColor = Colors.lime;
  static const Color defaultListItemBackgroundColor = Colors.white;
  static const double listViewDividerHeight = 10.0;
  static const Color listViewDividerColor = Colors.grey;

  //Date
  static String dateFormat = "yyyy-MMMM-dd";
  static String apiDateFormat = "yyyy-MM-dd";
  static String searchDateFormat = "yyyy-MM-dd HH:mm:ss";
  static String apiNodeUpdateDateFormat = "M/d/y";

  //Sighting List
  static const TextStyle sightingTitleTextStyle = TextStyle(fontFamily: fontFamily,fontSize: 18);
  static const TextStyle sightingSpeciesNameTextStyle = TextStyle(fontFamily: fontFamily,fontSize: 15,fontWeight: FontWeight.bold);
  static const TextStyle sightingSpeciesCountTextStyle = TextStyle(fontFamily: fontFamily,fontSize: 15,color: Colors.grey,fontWeight: FontWeight.bold);
  static const double sightingListImageHeight  = 320.0;
  static const String defaultImageText = "@default_image";


  //Splash screen
  static const int splashDurationInSecond = 5;
  static const int splashTransitionDuration = 1000;
  static const TextStyle splashAppTitleStyle = TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold, fontSize: 25,color: Colors.white);
  static const TextStyle splashAppCreedStyle = TextStyle(fontFamily: fontFamily, fontSize: 18,color: Colors.limeAccent,fontWeight: FontWeight.bold);

  static const Color mainColor = Colors.blueGrey;
  static const Color mainSplashColor = Colors.blueGrey;


  // GPS Location
  static const int gpsPrecision = 12;
  static const int gpsDecimalPrecision = 5;

}

class ConstantImage {

    static Widget getTextLogo({double width = 150,double height=70}){
      return SizedBox(width: 150,child:Image.asset("assets/logos/text-logo.png",width:width,height:height) ,);
    }


    static Widget getRussImage({bool avatar = false,double width = 100.0, double height = 100.0}){



    String imagePath = "assets/images/ram-everglades(resized).jpg";

    return !avatar ?
    /*Hero(
      tag : "russimage",
        child : Image.asset(imagePath,width: width,height: height,),

                )*/
    Hero(
        tag: "russimage",
        child:
        Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.fill,
                ))))
        :
    CircleAvatar(
      backgroundColor:Colors.white,
      radius: 50,
      //child: Icon(Icons.pets,color: Constants.mainColor,size:50),
      backgroundImage : AssetImage(imagePath),
    );

  }
}


