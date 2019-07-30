import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class LemurLifeList {

  static String idKey             = "_id";
  static String speciesNidKey     = "_speciesNid";
  static String totalSightingsKey = "totalSightings";
  static String totalObservedKey  = "totalObserved";
  static String speciesNameKey    = "_speciesName";


  int _id;
  int _speciesNid;
  String _speciesName;
  int _totalObserved;
  int _totalSightings;

  LemurLifeList(this._id,this._speciesNid,this._speciesName,this._totalObserved,this._totalSightings);

  LemurLifeList.fromMap(Map<String, dynamic> map) {
    try {
      this._id             = map[LemurLifeList.idKey];
      this._speciesNid     = map[LemurLifeList.speciesNidKey];
      this._speciesName    = map[LemurLifeList.speciesNameKey];
      this._totalObserved  = map[LemurLifeList.totalObservedKey];
      this._totalSightings = map[LemurLifeList.totalSightingsKey];
    } catch (e) {
      print("[LemurLifeList::LemurLifeList.fromMap()] error :" + e.toString());
      throw (e);
    }
  }

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();

    if (_id != null) {
      map[LemurLifeList.idKey] = this._id;
    }

    map[LemurLifeList.speciesNidKey]     = this._speciesNid;
    map[LemurLifeList.speciesNameKey]    = this._speciesName;
    map[LemurLifeList.totalSightingsKey] = this._totalSightings;
    map[LemurLifeList.totalObservedKey]  = this._totalObserved;

    return map;

  }

  static Widget buildCellInfo( LemurLifeList lifeList, BuildContext buildContext,int index,
      {CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {

    try {

      if (lifeList != null) {

        int speciesNID = lifeList._speciesNid;

        Species species = Species.withID(id:speciesNID);

        return ListTile(
          leading: Text(""+(index + 1).toString(),style:Constants.sightingTitleTextStyle.copyWith(fontSize: 35,color: Colors.blue,fontWeight: FontWeight.w300),textAlign: TextAlign.start,),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(lifeList._speciesName,style:Constants.sightingTitleTextStyle.copyWith(fontSize: 22),textAlign: TextAlign.start,),
              Padding(padding: EdgeInsets.only(top:10),),
              Row(
                children:[
                  Expanded(flex: 1, child:Text(lifeList._totalObserved.toString() + " observed",style:Constants.defaultSubTextStyle.copyWith(color: Colors.blueGrey,fontWeight: FontWeight.w700,fontSize: 18),textAlign: TextAlign.start,)),
                  Spacer(flex: 1,),
                  Expanded(flex: 1, child:Text(lifeList._totalSightings.toString() + " sightings",style:Constants.defaultSubTextStyle.copyWith(color: Colors.blueGrey,fontWeight: FontWeight.w700,fontSize: 18),textAlign: TextAlign.start,)),
                ],
              ),

            ],
          ),
        );
      }

    }catch(error){
      print("[LemurLifeList::buildCellInfo()] Error :${error.toString()}");
    }

    return Container();

  }

}