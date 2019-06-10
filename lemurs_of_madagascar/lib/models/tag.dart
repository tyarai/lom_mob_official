
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/providers/object_select_provider.dart';


class Tag extends SelectableListItem{

  static String idKey  = "_id";
  static String tidKey = "_tid";
  static String nameENKey = "_name_en";
  static String uuidKey = "_uuid";
  static String vocabularyNameKey = "_vocabulary_name";

  int id=0;
  int tid=0;
  String uuid="";
  String nameEN="";
  String vocabularyName="";

  Tag({this.id,this.tid,this.uuid,this.nameEN,this.vocabularyName});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map[Tag.idKey] = this.id;
    }

    map[Tag.tidKey]  = this.tid;
    map[Tag.uuidKey] = this.uuid;
    map[Tag.nameENKey] = this.nameEN;
    map[Tag.vocabularyNameKey] = this.vocabularyName;

    return map;
  }

  Tag.fromMap(Map<String, dynamic> map) {

    try {

      this.id = map[Tag.idKey];
      this.tid = map[Tag.tidKey];
      this.uuid = map[Tag.uuidKey];
      this.nameEN = map[Tag.nameENKey];
      this.vocabularyName = map[Tag.vocabularyNameKey];

    }catch(e){
      print("[TAG::Tag.fromMap()] exception: "+e.toString());
      throw(e);
    }


  }

  static Widget buildTextInfo(Tag tag,{CrossAxisAlignment crossAlignment = CrossAxisAlignment.start,TextStyle style = Constants.defaultTextStyle}) {
    if(tag != null) {
      return Expanded(
        child: Column(
            crossAxisAlignment: crossAlignment,
            children: <Widget>[
              Material(
                  color: Colors.transparent,
                  child:
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(tag.nameEN,style: style)),
                  )
                  ,
            ]),
      );
    }
    return Container();
  }

  @override
  String toString() {
    return "[ID] $id [TID] $tid [UUID] $uuid [NAME] $nameEN [VOCABULARY] $vocabularyName";
  }

  @override
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
                            Tag.buildTextInfo(this),
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