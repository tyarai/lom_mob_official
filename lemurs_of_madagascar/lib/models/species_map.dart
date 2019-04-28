
class SpeciesMap {

  static String _fileNameKey    = "_file_name";
  static String _idKey          = "_nid";

  String _fileName;
  int _id;


  factory SpeciesMap.withMap(SpeciesMap map){
    return SpeciesMap.withID(map._id, map._fileName);
  }

  SpeciesMap(this._fileName);

  SpeciesMap.withID(this._id, this._fileName);


  int get id => _id;
  String get fileName => _fileName;

  set fileName(String value){
      this._fileName = value;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if(_id != null){
      map[_idKey] = this._id;
    }

    map[_fileNameKey]       = this._fileName;
    return map;
  }


  SpeciesMap.fromMap(Map<String,dynamic> map) {
    this._id         = map[_idKey];
    this._fileName   = map[_fileNameKey];
  }




}


