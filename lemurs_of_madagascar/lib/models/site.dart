import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/speciesmap_database_helper.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/species_map.dart';
import 'package:lemurs_of_madagascar/utils/providers/object_select_provider.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class Site extends SelectableListItem {

  static String _idKey         = "_site_id";
  static String _bodyKey       = "_body";
  static String _titleKey      = "_title";
  static String _mapIDKey      = "_map_id";


  SpeciesMap _map;



  String _title;
  String _body;
  int _id;
  int _mapID;


  Site(this._title, this._body,this._mapID){
    _loadMap();
  }

  @override
  String toString() {
    return "${this.id} ${this.title}";
  }

  /*factory Site.withSite(Site photo){
    return Site.withID(photo.id, photo.title,photo.photograph);
  }*/


  Site.withID(this._id, this._title,this._body,this._mapID){
    _loadMap();
  }


  int get id => _id;
  String get title => _title;
  String get body => _body;
  int get mapID => _mapID;
  SpeciesMap get map => _map;


  set map(SpeciesMap value) => this._map = value;
  set title(String value){
    if(value.length <= 255){
      this._title = value;
    }
  }
  set body(String value) => this._body = value;
  set id(int value) => this._id = value;

  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();

    if(_id != null){
      map[_idKey] = this._id;
    }

    map[_titleKey]  = this._title;
    map[_bodyKey]   = this._body;
    map[_mapIDKey]  = this._mapID;


    return map;
  }

  Site.fromMap(Map<String,dynamic> map) {
    this._id         = map[_idKey];
    this._title      = map[_titleKey];
    this._body       = map[_bodyKey];
    this._mapID      = map[_mapID];
    _loadMap();
  }

  void _loadMap() async {

    if(this._mapID != 0){
      SpeciesMapDatabaseHelper db = SpeciesMapDatabaseHelper();
      this._map = await db.getSpeciesMapWithID(id:this._mapID);
    }
  }

  static Widget loadHeroTitle(Site site,{TextStyle style = Constants.speciesTitleStyle}) {



    return
      Hero(
        tag: site.title + site.id.toString(),
        child: Material(
            color: Colors.transparent,
            child:Text(site.title,style:style))
      );

  }


  static Widget buildTextInfo(Site site,{bool showMalagasy = true,CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {
    return Expanded(
      child: Column(
          crossAxisAlignment: crossAlignment,
          children: <Widget>[
            Site.loadHeroTitle(site),
            Container(height: 10),

          ]),
    );
  }


  Widget getItemCell(ListProvider provider,int index,BuildContext context, OnSelectCallback onSelectCallback,
      {
        double borderRadius = 0.5,
        double elevation    = 0.5,
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
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Container(
                child: Material(
                  color: _buildBackGroundColor(provider,index),
                  elevation: elevation,
                  borderRadius: BorderRadius.circular(borderRadius),
                  shadowColor: Colors.blueGrey,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Site.buildTextInfo(this),
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


