import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/database/site_database_helper.dart';
import 'package:lemurs_of_madagascar/database/speciesmap_database_helper.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/species_map.dart';
import 'package:lemurs_of_madagascar/utils/providers/object_select_provider.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:sqflite/sqlite_api.dart';

class Site extends SelectableListItem {

  static String idKey         = "_site_id";
  static String bodyKey       = "_body";
  static String titleKey      = "_title";
  static String mapIDKey      = "_map_id";


  SpeciesMap _map;


  String _title;
  String _body;
  int _nid;
  int _mapID;


  String get body => this._body;

  Site(this._title, this._body,this._mapID){
    _loadMap();
  }

  @override
  String toString() {
    return "${this.id} ${this.title} ${this.mapID}";
  }

  Site.withID(this._nid, this._title,this._body,this._mapID){
    _loadMap();
  }


  int get id => _nid;
  String get title => _title;
  int get mapID => _mapID;
  SpeciesMap get map => _map;




  set map(SpeciesMap value) => this._map = value;
  set title(String value){
    if(value.length <= 255){
      this._title = value;
    }
  }
  set body(String value) => this._body = value;
  set id(int value) => this._nid = value;

  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();

    if(_nid != null){
      map[idKey] = this._nid;
    }

    map[titleKey]  = this._title;
    map[bodyKey]   = this._body;
    map[mapIDKey]  = this._mapID;


    return map;
  }

  Site.fromMap(Map<String,dynamic> map) {
    try {
      this._nid = map[idKey];
      this._title = map[titleKey];
      this._body = map[bodyKey];
      this._mapID = map[mapIDKey];
      //print(this.toString());
      _loadMap();
    }catch(e){
      print("[Site.fromMap] "+e.toString());
    }
  }

  void _loadMap() async {

    if(this._mapID != 0 && this._mapID != null){
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
            child:Padding(
              padding: const EdgeInsets.all(10),
              child: Text(site.title,style:style),

            ))
      );

  }


  static Widget buildTextInfo(Site site,{bool showMalagasy = true,CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
          crossAxisAlignment: crossAlignment,
          children: <Widget>[
            Text(site.body,style:Constants.defaultTextStyle,textAlign: TextAlign.justify,),
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
                            Expanded(child: Site.loadHeroTitle(this)),
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

      SiteDatabaseHelper db = SiteDatabaseHelper();
      Future<int> id;
      Database database = await DatabaseHelper.instance.database;

      if (editing) {
        id = db.updateSite(database:database,site:this);
      }
      else {
        id = db.insertSite(database: database,site:this);
      }

      return id;

    }catch(e) {
      print("[Site::saveToDatabase()] Exception ${e.toString()}");
      throw e;
    }




  }

}


