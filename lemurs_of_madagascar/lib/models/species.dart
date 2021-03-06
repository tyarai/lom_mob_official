import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/models/species_map.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:lemurs_of_madagascar/database/speciesmap_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/providers/object_select_provider.dart';



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

    if(id != null){
      map[idKey] = this.id;
    }

    map[titleKey]         = this.title;
    map[profilePhotoKey]  = this.profilePhotoID;
    map[familyIDKey]      = this.familyID;
    map[mgKey]            = this.malagasy;
    map[enKey]            = this.english;
    map[otherEnKey]       = this.otherEnglish;
    map[frKey]            = this.french;
    map[deKey]            = this.german;
    map[identificationKey]= this.identification;
    map[statusKey]        = this.status;
    map[rangeKey]         = this.range;
    map[historyKey]       = this.history;
    map[sitesKey]         = this.sites;
    map[mapIDKey]         = this.mapID;
    map[photoIDsKey]      = this.profilePhotoID;

    return map;
  }

  Species.fromMap(Map<String,dynamic> map) {

    this.id               = map[idKey];
    this.title            = map[titleKey]         ;
    this.profilePhotoID   = map[profilePhotoKey];
    this.familyID         = map[familyIDKey];
    this.malagasy         = map[mgKey]             ;
    this.english          = map[enKey]             ;
    this.otherEnglish     = map[otherEnKey]        ;
    this.french           = map[frKey]             ;
    this.german           = map[deKey]             ;
    this.identification   = map[identificationKey] ;
    this.status           = map[statusKey]         ;
    this.range            = map[rangeKey]          ;
    this.history          = map[historyKey]        ;
    this.sites            = map[sitesKey]          ;
    this.mapID            = map[mapIDKey];
    this.photoIDs         = map[photoIDsKey]       ;

    _loadImageFiles();


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
    this._imageFile = "assets/images/" +  value + ".jpg";
  }

  set mapFileName(String value){
    this._mapFileName = value;
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
      this.imageFile = futurePhoto.photograph ;

      // Load map image
      SpeciesMapDatabaseHelper speciesMapDatabaseHelper = SpeciesMapDatabaseHelper();
      SpeciesMap futureMap =  await speciesMapDatabaseHelper.getSpeciesMapWithID(id:this.mapID);
      this._mapFileName = futureMap.fileName;




    }


  }

  Widget getMap(){

    Widget map;

    if(this._mapFileName != null){
      //print("map file :" + this._mapFileName);
      map = Image.asset("assets/images/" + this._mapFileName);
      if(map == null) print ("MAP NULL");
    }

      return map;
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
                  child: Species.loadHeroImage(species,width: width,height: height)));

          break;
        }
        case SpeciesImageClipperType.oval :{
          widget = Container(
              child: ClipOval(
                  child: Species.loadHeroImage(species)));
          break;
        }
      }

      return widget;
  }

  static Widget loadHeroImage(Species species,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth}) {

    if(species != null) {
      return Hero(
          tag: species.imageFile + species.id.toString(),
          child: Image.asset(
            species.imageFile,
            width: width,
            height: height,
          ));
    }
    return Container();
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
            Text(info,style : style),
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

}


