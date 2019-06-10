
import 'package:lemurs_of_madagascar/database/tag_database_helper.dart';


class Tag{

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


  @override
  String toString() {
    return "[ID] $id [TID] $tid [UUID] $uuid [NAME] $nameEN [VOCABULARY] $vocabularyName";
  }


}