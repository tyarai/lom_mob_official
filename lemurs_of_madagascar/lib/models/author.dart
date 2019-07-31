import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

enum AuthorImageClipperType {
  rectangular,
  oval
}


class Author {

  static String idKey             = "_id";
  static String nameKey           = "_name";
  static String detailsKey        = "_details";
  static String photoKey          = "_photo";

  int _id;
  String _name;
  String _details;
  String _photo;

  Author(this._id,this._name,this._details,this._photo);

  Author.fromMap(Map<String, dynamic> map) {
    try {
      this._id             = map[Author.idKey];
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

    map[Author.nameKey]                  = this._name;
    map[Author.detailsKey           ]    = this._details;
    map[Author.photoKey]                 = this._photo;

    return map;

  }

  static Widget buildCellInfo( Author author, BuildContext buildContext,int index,
      {CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {

    try {

      if (author != null) {

        String image = "assets/images/"+ author._photo;

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
                child: Author.loadHeroImage(author)));
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
            Author.loadHeroName(author),
            Padding(padding: EdgeInsets.only(top:10),),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: loadAuthorDetails(author),
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
          tag: author._name + author._id.toString(),
          child: Image.asset(

            image,
            fit:BoxFit.fitHeight,
            width: width,
            height: height,
          ));
    }
    return Container(child:Center(child:CircularProgressIndicator()));
  }

  static Widget loadHeroName(Author author,{TextStyle style = Constants.speciesTitleStyle}) {
    if(author != null) {
      return Hero(
          tag: author._name + author._id.toString(),
          child: Material(
              color: Colors.transparent,
              child: Text(author._name, style: style))
      );
    }
    return Container();
  }

  static Widget loadAuthorDetails(Author author) {
    if(author != null) {
      return Text(author._details.substring(0,200) + "...", style: TextStyle(fontSize: Constants.subTitleFontSize),textAlign: TextAlign.justify,);
    }
    return Container();
  }

}