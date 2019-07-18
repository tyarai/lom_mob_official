
import 'dart:io';

import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/database/comment_database_helper.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';

abstract class SyncCommentContract {
  void onSyncSuccess(Comment comment,int nid,bool editing);
  void onDeleteSuccess(Comment comment);
  void onSyncFailure(int statusCode);
  void onSocketFailure();
}

abstract class GetCommentContract {
  void onGetCommentSuccess(List<Comment> commentList);
  void onGetCommentFailure(int statusCode);
  void onSocketFailure();
  void onException(Exception e);
}


class SyncCommentPresenter {

  SyncCommentContract _syncingView;
  RestData api = RestData();
  SyncCommentPresenter(this._syncingView);

  sync(Comment comment,{bool editing=false}) {

    if(comment != null) {

      api.syncComment(comment,editing: editing)
          .then((cid) {
        print("presenter cid: $cid");
        _syncingView.onSyncSuccess(comment,cid,editing);
      })
          .catchError((error) {
        if(error is SocketException) _syncingView.onSocketFailure();
        if(error is LOMException) _syncingView.onSyncFailure(error.statusCode);
      });
    }
  }

  /*delete(Comment comment) {
    if(comment != null) {
      api.deleteComment(comment)
          .then((isDeleted) {
        if(isDeleted){
          _syncingView.onDeleteSuccess(comment);
        }
      }).catchError((error) {
        if(error is SocketException) _syncingView.onSocketFailure();
        if(error is LOMException) _syncingView.onSyncFailure(error.statusCode);
      });
    }
  }*/

}

class GetCommentPresenter {

  GetCommentContract _getView;
  RestData api = RestData();

  GetCommentPresenter(this._getView);

  get(DateTime fromDate) {


    api.getComments(fromDate).then((commentList) {

      try {
        print("[GetCommentPresenter] ${commentList?.length} comments(s) from server ${commentList
            .toString()}");
        _getView.onGetCommentSuccess(commentList);
      }catch(e){
        print(e.toString());
      }

    }).catchError((error) {
      if (error is SocketException) _getView.onSocketFailure();
      if (error is LOMException) _getView.onGetCommentFailure(error.statusCode);
      if (error is Exception) _getView.onException(error);
    });



  }

}

class Comment{

  static String idKey  = "_id";
  static String nidKey = "_nid";
  static String pidKey = "_pid";
  static String cidKey = "_cid";
  static String uidKey = "_uid";
  static String createdKey = "_created";
  static String modifiedKey = "_modified";
  static String statusKey = "_status";
  static String uuidKey = "_uuid";
  static String nameKey = "_name";
  static String mailKey = "_mail";
  static String commentBodyKey = "_commentBody";
  static String sightingUUIDKey = "_sighting_uuid";
  static String deletedKey = "_deleted";

  int id=0;
  int nid=0;
  int pid=0;
  int cid = 0;
  int uid=0;
  int deleted=0;
  double created=0;
  double modified=0;
  int status;
  String uuid="";
  String name="";
  String mail="";
  String commentBody="";
  String sightingUUID="";


  Comment({this.id,this.nid,this.cid,this.pid,this.deleted,this.uid,this.created,this.modified,this.status,this.uuid,this.name,this.mail,this.commentBody,this.sightingUUID});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map[Comment.idKey] = this.id;
    }

    map[Comment.nidKey] = this.nid;
    map[Comment.pidKey] = this.pid;
    map[Comment.cidKey] = this.cid;
    map[Comment.uidKey] = this.uid;
    map[Comment.createdKey] = this.created;
    map[Comment.modifiedKey] = this.modified;
    map[Comment.statusKey] = this.status;
    map[Comment.uuidKey] = this.uuid;
    map[Comment.nameKey] = this.name;
    map[Comment.mailKey] = this.mail;
    map[Comment.commentBodyKey] = this.commentBody;
    map[Comment.sightingUUIDKey] = this.sightingUUID;
    map[Comment.deletedKey] = this.deleted;

    return map;
  }

  Comment.fromMap(Map<String, dynamic> map) {

    try {

      this.id = map[Comment.idKey];
      this.nid = map[Comment.nidKey];
      this.pid = map[Comment.pidKey];
      this.cid = map[Comment.cidKey];
      this.uuid = map[Comment.uuidKey];
      this.uid = map[Comment.uidKey];
      this.created = map[Comment.createdKey];
      this.modified = map[Comment.modifiedKey];
      this.status = map[Comment.statusKey];
      this.name = map[Comment.nameKey];
      this.mail = map[Comment.mailKey];
      this.commentBody = map[Comment.commentBodyKey];
      this.sightingUUID = map[Comment.sightingUUIDKey];
      this.deleted = map[Comment.deletedKey];

    }catch(e){
      print("[COMMENT::Comment.fromMap()] exception :"+e.toString());
      throw(e);
    }


  }

  Future<Comment> saveToDatabase(bool editing) async {

    try{

        CommentDatabaseHelper db = CommentDatabaseHelper();
        Future<int> cid;

        if (editing) {
          cid = db.updateComment(this);
        }
        else {
          cid = db.insertComment(this);
        }

        return cid.then((result) {
          if(result > 0){
            if(!editing){
              this.id = result; // newly created sighting
            }
            return this;
          }else{
            return null;
          }

        });


    }catch(e) {
      print("[Sighting::saveToDatabase()] Exception ${e.toString()}");
      throw e;
    }


  }

  @override
  String toString() {
    return "[CID] $cid [NID] $nid [BODY] $commentBody [UID] $uid";
  }


}