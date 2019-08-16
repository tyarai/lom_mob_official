import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/author_database_helper.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:sqflite/sqlite_api.dart';

enum AuthorImageClipperType {
  rectangular,
  oval
}


class Author {

  static String idKey             = "_id";
  static String nidKey            = "_nid";
  static String nameKey           = "_name";
  static String detailsKey        = "_details";
  static String photoKey          = "_photo";

  int _id;
  int _nid;
  String _name;
  String _details;
  String _photo;

  String get name => this._name;

  int get id => this._id;

  int get nid => this._nid;

  String get details => this._details;

  Author(this._id,this._nid,this._name,this._details,this._photo);

  Author.fromMap(Map<String, dynamic> map) {
    try {
      this._id             = map[Author.idKey]  ;
      this._nid            = map[Author.nidKey];
      this._name           = map[Author.nameKey];
      this._details        = map[Author.detailsKey];
      this._photo          = map[Author.photoKey];
    } catch (e) {
      print("[Author::Author.fromMap()] error :" + e.toString());
      throw (e);
    }
  }

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();

    if (_id != null) {
      map[Author.idKey] = this._id;
    }

    map[Author.nidKey]                   = this._nid;
    map[Author.nameKey]                  = this._name;
    map[Author.detailsKey]               = this._details;
    // Do not update image file as it is downloaded from internet.
    // Just keep the asset photo name otherwise we will need to download image fom server
    //map[Author.photoKey]                 = this._photo;

    return map;

  }

  static Widget buildCellInfo( Author author, BuildContext buildContext,int index,
      {CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {

    try {

      if (author != null) {

        String image = Constants.appImagesAssetsFolder + author._photo;

        return ListTile(
          leading:
              Image.asset(
                image,
                width: Constants.authorListViewImageWidth,
                height: Constants.authorListViewImageWidth,
              ),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(author._name,style:Constants.sightingTitleTextStyle.copyWith(fontSize: 22),textAlign: TextAlign.start,),
            ],
          ),
          onTap: (){

          },
        );
      }

    }catch(error){
      print("[Author::buildCellInfo()] Error :${error.toString()}");
    }

    return Container();

  }

  static Widget buildAuthorPhoto(Author author,{double width = Constants.listViewImageWidth,double height = Constants.listViewImageHeight, AuthorImageClipperType imageClipper = AuthorImageClipperType.rectangular}) {

    Widget widget;
    BorderRadius _borderRadius;

    switch (imageClipper) {

      case AuthorImageClipperType.rectangular :{

        _borderRadius = BorderRadius.circular(Constants.speciesImageBorderRadius);
        widget = Container(
            child: ClipRRect(
                borderRadius: _borderRadius,
                child: Author.loadHeroImage(author,width: width,height: height)));

        break;
      }
      case AuthorImageClipperType.oval :{
        widget = Container(
            child: ClipOval(
                child: Author.loadImage(author)));//Author.loadHeroImage(author)));
        break;
      }
    }

    return widget;
  }

  static Widget buildAuthorName(Author author) {

    if(author != null){
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Author.loadHeroName(author),
            Author.loadName(author),
            Padding(padding: EdgeInsets.only(top:10),),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: loadAuthorDetails(author,style: Constants.defaultTextStyle.copyWith(fontSize: Constants.subTextFontSize)),
            ),
          ],
        ),
      );
    }
    return Container();

  }

  static Widget loadHeroImage(Author author,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth}) {

    String image = "assets/images/" + author._photo;

    if(author != null) {
      return Hero(
          tag:  author._id.toString() + author._photo,
          child: Image.asset(

            image,
            fit:BoxFit.fitHeight,
            width: width,
            height: height,
          ));
    }
    return Container(child:Center(child:CircularProgressIndicator()));
  }

  static Widget loadImage(Author author,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth}) {

    String image = "assets/images/" + author._photo;

    if(author != null) {
      return Image.asset(
        image,
        fit:BoxFit.fitHeight,
        width: width,
        height: height,
      );
    }
    return Container(child:Center(child:CircularProgressIndicator()));
  }

  static Widget loadHeroName(Author author,{TextStyle style = Constants.speciesTitleStyle}) {
    if(author != null) {
      return Hero(
          tag: author._id.toString() + author._photo,
          child: Material(
              color: Colors.transparent,
              child: Text(author._name, style: style))
      );
    }
    return Container();
  }

  static Widget loadName(Author author,{TextStyle style = Constants.speciesTitleStyle}) {
    if(author != null) {
      return Material(
          color: Colors.transparent,
          child: Text(author._name, style: style));
    }
    return Container();
  }

  static Widget loadAuthorDetails(Author author,{int truncateLen = 200 , TextStyle style = Constants.defaultTextStyle}) {
    if(author != null) {
      String text = author._details.substring(0,truncateLen);
      text += (truncateLen != null) ? "" : "...";
      TextStyle _style = (style != null) ? style : Constants.defaultTextStyle.copyWith(fontSize:Constants.subTitleFontSize);
      return Text( text, style: _style,textAlign: TextAlign.justify,);
    }
    return Container();
  }


  Future<int> saveToDatabase(bool editing) async {

    try{

      AuthorDatabaseHelper db = AuthorDatabaseHelper();
      Future<int> id;
      Database database = await DatabaseHelper.instance.database;

      if (editing) {
        id = db.updateAuthor(database:database,author:this);
      }
      else {
        id = db.insertAuthor(database: database,author:this);
      }

      return id;

    }catch(e) {
      print("[Author::saveToDatabase()] Exception ${e.toString()}");
      throw e;
    }


  }

}