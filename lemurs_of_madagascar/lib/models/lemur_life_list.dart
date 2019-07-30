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

}