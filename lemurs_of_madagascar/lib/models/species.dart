import 'dart:io';

import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/models/species_map.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:lemurs_of_madagascar/database/speciesmap_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/image.dart';
import 'package:lemurs_of_madagascar/utils/providers/object_select_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';


enum SpeciesImageClipperType {
  rectangular,
  oval
}

enum CellType {
  ListTiles,
  Column,
  FittedBox,
}

class Species extends SelectableListItem {

  static String idKey          = "_species_id";
  static String profilePhotoKey = "_profile_photograph_id";
  static String titleKey       = "_title";
  static String familyIDKey    = "_family_id";
  static String mgKey          = "_malagasy";
  static String frKey          = "_french";
  static String enKey          = "_english";
  static String otherEnKey     = "_other_english";
  static String deKey          = "_german";
  static String identificationKey = "_identification";
  static String historyKey     = "_natural_history";
  static String rangeKey       = "_geographic_range";
  static String statusKey      = "_conservation_status";
  static String sitesKey       = "_where_to_see_it";
  static String mapIDKey       = "_map";
  static String photoIDsKey    = "_specie_photograph";


  String tempImage = "assets/images/Lepilemur-petteri.jpg";
  String _imageFile;
  String _mapFileName;

  int id;
  String title;
  int profilePhotoID;
  int familyID;
  String malagasy;
  String german;
  String english;
  String otherEnglish;
  String french;
  String identification;
  String history;
  String range;
  String status;
  String sites;
  int mapID;
  String photoIDs;


  //Photograph profilePhotograph;



  Species({
    this.title,
    this.profilePhotoID,
    this.familyID,
    this.malagasy,
    this.german,
    this.english,
    this.otherEnglish,
    this.french,
    this.identification,
    this.history,
    this.range,
    this.status,
    this.sites,
    this.mapID,
    this.photoIDs
  }){
    _loadImageFiles();
  }

  Species.withID({
    this.id,
    this.title,
    this.profilePhotoID,
    this.familyID,
    this.malagasy,
    this.german,
    this.english,
    this.otherEnglish,
    this.french,
    this.identification,
    this.history,
    this.range,
    this.status,
    this.sites,
    this.mapID,
    this.photoIDs
  }){
    _loadImageFiles();
  }


  Future<Photograph> getPhotographObjectAtIndex(int index) async {

    List<String> photoListsID = this.photoIDs.split(",");

    try {

      if (index >= 0 && index < photoListsID.length) {
        int photoID = int.parse(photoListsID[index]);
        PhotographDatabaseHelper photographDatabaseHelper = PhotographDatabaseHelper();
        Photograph futurePhoto = await photographDatabaseHelper
            .getPhotographWithID(id: photoID);
        return futurePhoto;
      }
    }
    catch(e){
      print("Species::getPhotoImageAtIndex(int index):" + e.toString());
    }
    return null;
  }

  Map<String, dynamic> toMap(){


    var map = Map<String, dynamic>();

    try {
      if (id != null) {
        map[idKey] = this.id;
      }

      map[titleKey] = this.title;
      map[profilePhotoKey] = this.profilePhotoID;
      map[familyIDKey] = this.familyID;
      map[mgKey] = this.malagasy;
      map[enKey] = this.english;
      map[otherEnKey] = this.otherEnglish;
      map[frKey] = this.french;
      map[deKey] = this.german;
      map[identificationKey] = this.identification;
      map[statusKey] = this.status;
      map[rangeKey] = this.range;
      map[historyKey] = this.history;
      map[sitesKey] = this.sites;
      map[mapIDKey] = this.mapID;
      map[photoIDsKey] = this.photoIDs; //this.profilePhotoID;


      print("MAP "+map.toString());


    }catch(e){
      print("[Species::toMap()] Exception "+ e.toString());
    }

    return map;
  }

  Species.fromMap(Map<String,dynamic> map) {

    try {
      this.id = map[idKey];
      this.title = map[titleKey];
      this.profilePhotoID = map[profilePhotoKey];
      this.familyID = map[familyIDKey];
      this.malagasy = map[mgKey];
      this.english = map[enKey];
      this.otherEnglish = map[otherEnKey];
      this.french = map[frKey];
      this.german = map[deKey];
      this.identification = map[identificationKey];
      this.status = map[statusKey];
      this.range = map[rangeKey];
      this.history = map[historyKey];
      this.sites = map[sitesKey];
      this.mapID = map[mapIDKey];
      this.photoIDs = map[photoIDsKey];

      _loadImageFiles();

    }catch(e){
      print("[Species.fromMap]"+e.toString());
    }


  }

  @override
  String toString() {
      return " ${this.id} ${this.title} ${this.malagasy}";
  }

  Species.fromSpecies(Species species) {

    this.id               = species.id;
    this.title            = species.title;
    this.profilePhotoID   = species.profilePhotoID;
    this.familyID         = species.familyID;
    this.malagasy         = species.malagasy             ;
    this.english          = species.english             ;
    this.otherEnglish     = species.otherEnglish        ;
    this.french           = species.french             ;
    this.german           = species.german             ;
    this.identification   = species.identification ;
    this.status           = species.status         ;
    this.range            = species.range         ;
    this.history          = species.history        ;
    this.sites            = species.sites         ;
    this.mapID            = species.mapID;
    this.photoIDs         = species.photoIDs;

    _loadImageFiles();


  }

  String get imageFile    =>  _imageFile ;
  String get mapFileName  =>  _mapFileName ;

  set imageFile(String value){

    if (value != null) {
      //this._imageFile = Constants.appImagesAssetsFolder +  value ;
      this._imageFile = value ;
      if(! value.endsWith(Constants.imageType)) {
        this._imageFile += "." + Constants.imageType;
      }
    }
  }

  set mapFileName(String value){
    if(value != null) this._mapFileName = value;
  }


  static bool isInList(Species species, List<Species> list){

    if(species != null && list != null ){
      for(int i= 0 ; i< list.length ; i++){
        if(list[i].id == species.id){
          return true;
        }
      }
    }
    return false;
  }

  _loadImageFiles() async {

    this.imageFile  = "placeholder";
    this._mapFileName = "placeholder";

    if(this.profilePhotoID != null && this.mapID != null) {

      // Load profile image
      PhotographDatabaseHelper photographDatabaseHelper = PhotographDatabaseHelper();
      Photograph futurePhoto =  await photographDatabaseHelper.getPhotographWithID(id:this.profilePhotoID);
      this.imageFile = futurePhoto?.photograph ;

      // Load map image
      SpeciesMapDatabaseHelper speciesMapDatabaseHelper = SpeciesMapDatabaseHelper();
      SpeciesMap futureMap =  await speciesMapDatabaseHelper.getSpeciesMapWithID(id:this.mapID);
      this._mapFileName = futureMap?.fileName;


    }


  }

  /*Widget getMap(){

    Widget map;

    if(this._mapFileName != null){
      //print("map file :" + this._mapFileName);
      map = Image.asset("assets/images/" + this._mapFileName);
      if(map == null) print ("MAP NULL");
    }

      return map;
  }*/


  Widget getMap()  {

    return FutureBuilder<bool>(

          future : LOMImage.checkAssetFile(this._mapFileName),
          builder : (context,snapshot)  {

            if(snapshot.hasData) {

              if(snapshot.data){

                String assetFile = Constants.appImagesAssetsFolder + this._mapFileName;
                return Image.asset(
                  assetFile,
                );

              }else{

                return FutureBuilder<Directory>(

                    future : getApplicationDocumentsDirectory(),
                    builder : (context,snapshot)  {

                      if(snapshot.hasData && snapshot.data != null) {

                        String fullPath = join(snapshot.data.path, this._mapFileName);
                        File file = File(fullPath);
                        return Image.file(file, fit: BoxFit.fitHeight);

                      }

                      return Container();

                    });

              }
            }

            return Container();

          }

      );
  }



  static Widget buildLemurPhoto(Species species,{double width = Constants.listViewImageWidth,double height = Constants.listViewImageHeight, SpeciesImageClipperType imageClipper = SpeciesImageClipperType.rectangular}) {

      Widget widget;
      BorderRadius _borderRadius;

      switch (imageClipper) {

        case SpeciesImageClipperType.rectangular :{

          _borderRadius = BorderRadius.circular(Constants.speciesImageBorderRadius);
          widget = Container(
              child: ClipRRect(
                  borderRadius: _borderRadius,
                  child: Hero(
                    tag: species.imageFile + species.id.toString(),
                    child:Species.loadHeroImage(species,width: width,height: height)
                  ))
              );


          break;
        }
        case SpeciesImageClipperType.oval :{
          widget = Container(
              child: ClipOval(
                    child: Species.loadHeroImage(species)
                    /*child: FutureBuilder(
                      future:Species.loadHeroImage(species,width: width,height: height),
                      builder:(context,snapshot){
                        if(snapshot.hasData && snapshot.data != null){
                        return snapshot.data;
                        }
                        return Container();
                      }
                    )*/
              ));
          break;
        }
      }

      return widget;
  }

  /*static Widget loadHeroImage(Species species,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth}) {

    if(species != null) {

      //print("IMAGEFILE "+species.imageFile);

      return FutureBuilder<Widget>(
          future : LOMImage.getWidget(species.imageFile),
          builder : (context,snapshot)  {
            if(snapshot.hasData && snapshot.data != null){

              return Hero(
                  tag:  species.id.toString() + species.imageFile,
                  child:snapshot.data
              );
            }
            return Center(child:CircularProgressIndicator());
          }
      );

    }
    return Container(child:Center(child:CircularProgressIndicator()));
  }*/

  static Widget loadHeroImage(Species species,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth})  {

    if(species != null) {


      return FutureBuilder<bool>(

          future : LOMImage.checkAssetFile(species.imageFile),
          builder : (context,snapshot)  {

            if(snapshot.hasData) {

              if(snapshot.data){

                String assetFile = Constants.appImagesAssetsFolder + species.imageFile;
                return Image.asset(
                      assetFile,
                      width: width,
                      height: height,
                    );

              }else{

                return FutureBuilder<Directory>(

                  future : getApplicationDocumentsDirectory(),
                  builder : (context,snapshot)  {

                    if(snapshot.hasData && snapshot.data != null) {

                      String fullPath = join(snapshot.data.path, species.imageFile);
                      File file = File(fullPath);
                      return Image.file(file, fit: BoxFit.fitHeight,
                            width: width,
                            height: height,
                      );

                    }

                    return Container(child:Image.asset("assets/images/placeholder.jpg",width: width * 0.80,height: height * 0.80,));

                  });

              }
            }

            return Container(child:Image.asset("assets/images/placeholder.jpg",width: width * 0.80,height: height * 0.80,));

          }

      );

    }
    return Container(child:Center(child:CircularProgressIndicator()));
    //return Container(child:Image.asset("assets/images/placeholder.jpg"));
  }

  static Widget loadHeroTitle(Species species,{TextStyle style = Constants.speciesTitleStyle}) {
    if(species != null) {
      return Hero(
          tag: species.title + species.id.toString(),
          child: Material(
              color: Colors.transparent,
              child: Text(species.title, style: style))
      );
    }
    return Container();
  }

  static Widget buildTextInfo(Species species,{bool showMalagasy = true,CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {
    if(species != null) {
      return Expanded(
        child: Column(
            crossAxisAlignment: crossAlignment,
            children: <Widget>[
              Species.loadHeroTitle(species),
              Container(height: 10),
              showMalagasy
                  ?
              Material(
                  color: Colors.transparent,
                  child:
                  Text(species.malagasy,
                      style: TextStyle(fontSize: Constants.subTitleFontSize)))
                  : Container(),
            ]),
      );
    }
    return Container();
  }

  static Widget buildInfo(String info,{TextStyle style = Constants.defaultTextStyle, CrossAxisAlignment crossAlignment = CrossAxisAlignment.start, MainAxisAlignment mainAlignment = MainAxisAlignment.start}) {
    return Expanded(
      child: Column(
          crossAxisAlignment: crossAlignment,
          mainAxisAlignment: mainAlignment,
          children: <Widget>[
            Text(info,style : style, textAlign: TextAlign.justify,),
          ]),
    );
  }

  static Widget buildTitle(Species species) {
    return Expanded(
      child: Text(species.title, style: TextStyle(fontSize: 18.0)),
    );
  }

  static Widget buildSubTitle(Species species) {
    return Expanded(
      child: Text(species.malagasy),
    );
  }

  /*
  // Always override hasCode when overriding operator ==
  @override
  bool operator ==(Object other) => other is Species && this.id == other.id;

  @override
  int get hasCode => id.hashCode ^ title.hashCode;
  */


  Widget getItemCell(ListProvider provider,int index,BuildContext context, OnSelectCallback onSelectCallback,
      {
        double borderRadius = Constants.speciesImageBorderRadius,
        double elevation    = 2.5,
        double imageWidth   = Constants.listViewImageWidth,
        double imageHeight  = Constants.listViewImageHeight,
        SpeciesImageClipperType imageClipper = SpeciesImageClipperType.rectangular
      })
  {
    return GestureDetector(
        onTap: () {
          provider.selectedItem = this;
          provider.selectedItemIndex = index;
          onSelectCallback(this);
        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Container(
                child: Material(
                  color: _buildBackGroundColor(provider,index),
                  elevation: elevation,
                  borderRadius: BorderRadius.circular(borderRadius),
                  shadowColor: Colors.blueGrey,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Species.buildLemurPhoto(this,width: 100,height: 100,imageClipper: imageClipper),
                            Container(width: 10),
                            Species.buildTextInfo(this),
                            Container(width: 10),
                            _buildCheckBox(provider,index),

                          ])),
                ))));

  }

  _buildBackGroundColor(ListProvider provider, int index ){
    return (provider.selectedItemIndex == index) ?
    Constants.selectedListItemBackgroundColor : Constants.defaultListItemBackgroundColor;
  }

  _buildCheckBox(ListProvider provider, int index ){
    return (provider.selectedItemIndex == index) ?
    Container(
      child: Icon(Icons.check,size:35,color: Colors.green,),
    )
    : Container();
  }


  Future<int> saveToDatabase(bool editing) async {

    try{

      SpeciesDatabaseHelper db = SpeciesDatabaseHelper();
      Future<int> id;
      Database database = await DatabaseHelper.instance.database;

      if (editing) {
        id = db.updateSpecies(species:this);
      }
      else {
        id = db.insertSpecies(species:this);
      }



      return id;

    }catch(e) {
      print("[Species::saveToDatabase()] Exception ${e.toString()}");
      throw e;
    }




  }

}


