
class Comment{

  static String idKey = "_id";
  static String nidKey = "_cid";
  static String pidKey = "_pid";
  static String uidKey = "_uid";
  static String createdKey = "_created";
  static String modifiedKey = "_modified";
  static String statusKey = "_status";
  static String uuidKey = "_uuid";
  static String nameKey = "_name";
  static String mailKey = "_mail";
  static String commentBodyKey = "_commentBody";
  static String sightingUUIDKey = "_sighting_uuid";

  int id=0;
  int nid=0;
  int pid=0;
  int uid=0;
  int created=0;
  int modified=0;
  int status;
  String uuid="";
  String name="";
  String mail="";
  String commentBody="";
  String sightingUUID="";


  Comment({this.id,this.nid,this.pid,this.uid,this.created,this.modified,this.status,this.uuid,this.name,this.mail,this.commentBody,this.sightingUUID});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map[Comment.idKey] = this.id;
    }

    map[Comment.nidKey] = this.nid;
    map[Comment.pidKey] = this.pid;
    map[Comment.uidKey] = this.uid;
    map[Comment.createdKey] = this.created;
    map[Comment.modifiedKey] = this.modified;
    map[Comment.statusKey] = this.status;
    map[Comment.uuidKey] = this.uuid;
    map[Comment.nameKey] = this.name;
    map[Comment.mailKey] = this.mail;
    map[Comment.commentBodyKey] = this.commentBody;
    map[Comment.sightingUUIDKey] = this.sightingUUID;

    return map;
  }

  Comment.fromMap(Map<String, dynamic> map) {

    try {
      this.id = map[Comment.idKey];
      this.nid = map[Comment.nidKey];
      this.pid = map[Comment.pidKey];
      this.uuid = map[Comment.uuidKey];
      this.uid = map[Comment.uidKey];
      this.created = map[Comment.createdKey];
      this.modified = map[Comment.modifiedKey];
      this.status = map[Comment.statusKey];
      this.name = map[Comment.nameKey];
      this.mail = map[Comment.mailKey];
      this.commentBody = map[Comment.commentBodyKey];
      this.sightingUUID = map[Comment.sightingUUIDKey];
    }catch(e){
      print("[COMMENT::Comment.fromMap()] exception :"+e.toString());
      throw(e);
    }


  }


}