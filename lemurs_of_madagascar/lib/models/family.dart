import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/database/family_database_helper.dart';
import 'package:lemurs_of_madagascar/database/illustration_database_helper.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:lemurs_of_madagascar/models/author.dart';
import 'package:lemurs_of_madagascar/models/illustration.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:sqflite/sqlite_api.dart';



class Family {

  static String nidKey            = "_nid";
  static String familyKey         = "_family";
  static String descriptionKey    = "_family_description";
  static String illustrationKey   = "_illustration";

  int    _nid;
  String _family;
  String _description;
  String _illustration;

  String get family => this._family;

  String get description => this._description;

  Family(this._nid,this._family,this._description,this._illustration);

  Family.fromMap(Map<String, dynamic> map) {
    try {
      this._nid             = map[Family.nidKey];
      this._family          = map[Family.familyKey];
      this._description     = map[Family.descriptionKey];
      this._illustration    = map[Family.illustrationKey];
    } catch (e) {
      print("[Family.fromMap()] error :" + e.toString());
      throw (e);
    }
  }

  int get nid => this._nid;

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();

    if (_nid != null) {
      map[Author.idKey] = this._nid;
    }

    map[Family.familyKey]         = this._family;
    map[Family.descriptionKey]    = this._description;
    map[Family.illustrationKey]   = this._illustration;

    return map;

  }

  static Widget buildCellInfo( Family family, BuildContext buildContext,int index,
      {CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {

    try {

      if (family != null) {

        //String image = "assets/images/"+ autfamilyhor._photo;

        return ListTile(
          /*leading:
          Image.asset(
            image,
            width: Constants.authorListViewImageWidth,
            height: Constants.authorListViewImageWidth,
          ),*/

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(family._family,style:Constants.sightingTitleTextStyle.copyWith(fontSize: 22),textAlign: TextAlign.start,),
            ],
          ),
          onTap: (){

          },
        );
      }

    }catch(error){
      print("[Family::buildCellInfo()] Error :${error.toString()}");
    }

    return Container();

  }

  static Widget buildFamilyPhoto(Family family,{double width = Constants.listViewImageWidth,double height = Constants.listViewImageHeight, AuthorImageClipperType imageClipper = AuthorImageClipperType.rectangular}) {

    Widget widget;
    BorderRadius _borderRadius;

    switch (imageClipper) {

      case AuthorImageClipperType.rectangular :{

        _borderRadius = BorderRadius.circular(Constants.speciesImageBorderRadius);
        widget = Container(
            child: ClipRRect(
                borderRadius: _borderRadius,
                child: Family.loadHeroImage(family,width: width,height: height)));

        break;
      }
      case AuthorImageClipperType.oval :{
        widget = Container(
            child: ClipOval(
                child: Family.loadImage(family)));
        break;
      }
    }

    return widget;
  }

  static Widget buildFamilyName(Family family,{int truncate = 200}) {

    if(family != null){



      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Author.loadHeroName(author),
            Family.loadName(family),
            Padding(padding: EdgeInsets.only(top:10),),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: truncate != null ?
               loadFamilyDetails(family,truncateLen: 200, style: Constants.defaultTextStyle.copyWith(fontSize: Constants.subTextFontSize))
               : loadFamilyDetails(family, style: Constants.defaultTextStyle.copyWith(fontSize: Constants.subTextFontSize))  ,
            ),
          ],
        ),
      );
    }
    return Container();

  }

  static Future<Illustration> getIllustrationObjectAtIndex(Family family,int index) async {

    List<String> illustrationListsID = family._illustration.split(",");

    try {

      if (index >= 0 && index < illustrationListsID.length) {
        int photoID = int.parse(illustrationListsID[index]);
        IllustrationDatabaseHelper illustrationDatabaseHelper = IllustrationDatabaseHelper();
        Illustration futureIllustration = await illustrationDatabaseHelper
            .getIllustrationWithID(id: photoID);
        return futureIllustration;

      }
    }
    catch(e){
      print("Illustration::getIllustrationObjectAtIndex(int index):" + e.toString());
    }
    return null;
  }

  static Widget loadHeroImage(Family family,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth})  {

    if(family != null) {

      return FutureBuilder<Illustration>(
        future:Family.getIllustrationObjectAtIndex(family, 0),
        builder: (context, snapshot){

          if(snapshot.hasData) {

            String image = Constants.appImagesAssetsFolder + snapshot.data.illustration + "." + Constants.imageType;

            return Hero(
                tag: family._nid.toString() + family._family,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: width,
                  //height: height,
                ));
          }
          return Center(child: CircularProgressIndicator(),);
        },
      );
    }

    return Container(child:Center(child:CircularProgressIndicator()));
  }

  static Widget loadImage(Family family,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth}) {


    if(family != null) {

      return FutureBuilder<Illustration>(
        future:Family.getIllustrationObjectAtIndex(family, 0),
        builder: (context, snapshot){

          if(snapshot.hasData) {

            String image = Constants.appImagesAssetsFolder + snapshot.data.illustration + "." + Constants.imageType;

            return Image.asset(
              image,
              fit: BoxFit.fitHeight,
              width: width,
              height: height,
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      );
    }
    return Container(child:Center(child:CircularProgressIndicator()));
  }

  static Widget loadHeroName(Family family,{TextStyle style = Constants.speciesTitleStyle}) {
    if(family != null) {
      return Hero(
          tag: family._nid.toString() + family._family,
          child: Material(
              color: Colors.transparent,
              child: Text(family._family, style: style))
      );
    }
    return Container();
  }

  static Widget loadName(Family family,{TextStyle style = Constants.speciesTitleStyle}) {
    if(family != null) {
      return Material(
          color: Colors.transparent,
          child: Text(family._family, style: style));
    }
    return Container();
  }

  static Widget loadFamilyDetails(Family family,{int truncateLen = 200 , TextStyle style = Constants.defaultTextStyle}) {
    if(family != null) {
      String text = family._description.substring(0,truncateLen);
      text += (truncateLen != null) ? "..." : "";
      TextStyle _style = (style != null) ? style : Constants.defaultTextStyle.copyWith(fontSize:Constants.subTitleFontSize);
      return Text( text, style: _style,textAlign: TextAlign.justify,);
    }
    return Container();
  }

  Future<int> saveToDatabase(bool editing) async {

    try{

      FamilyDatabaseHelper db = FamilyDatabaseHelper();
      Future<int> id;
      Database database = await DatabaseHelper.instance.database;

      if (editing) {
        id = db.updateFamily(database:database,family:this);
      }
      else {
        id = db.insertFamily(database: database,family:this);
      }

      return id;

    }catch(e) {
      print("[Family::saveToDatabase()] Exception ${e.toString()}");
      throw e;
    }




  }

}