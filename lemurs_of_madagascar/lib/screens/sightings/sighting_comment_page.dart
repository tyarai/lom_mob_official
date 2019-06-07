
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/database/comment_database_helper.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/models/comment.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:uuid/uuid.dart';

class SightingCommentPage extends StatefulWidget{
  final Sighting sighting;

  SightingCommentPage(this.sighting);

  @override
  State<StatefulWidget> createState() {
    return _SightingCommentPage(this.sighting);
  }

}

class _SightingCommentPage extends State<SightingCommentPage> implements SyncCommentContract {

  final Sighting sighting;
  List<Comment> _comments = List();
  var commentController = TextEditingController();
  SyncCommentPresenter presenter;
  bool _isLoading = false;

  _SightingCommentPage(this.sighting){
    presenter = SyncCommentPresenter(this);
  }


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  Future<List<Comment>> _loadCommentList(int sightingNid) async {
    if(sightingNid != null) {
      CommentDatabaseHelper commentDBHelper = CommentDatabaseHelper();
      List<Comment> futureList = await commentDBHelper.getCommentList(sightingNid);
      return futureList;
    }
    return null;
  }

  Future<List<Comment>> _loadSightingComments(Sighting sighting){

     return _loadCommentList(sighting.nid).then((list) {

      setState(() {
        _comments = list;
      });

      return _comments;

    });

  }

  _addComment({int uid,int sightingNid,String textComment,String name,String mail,String sightingUUID }){

    if(uid != null && sightingNid != 0 && textComment != null && textComment.trim().length != 0){

      double created = DateTime.now().millisecondsSinceEpoch.toDouble();
      String uuid = Uuid().v1(); // uuid based on time

      Comment comment = Comment(
          commentBody: textComment,
          uid: uid,
          status: 1,
          nid:sightingNid,
          created:created,
          modified: created,
          name:name,
          mail:mail,
          uuid:uuid,
          sightingUUID:sightingUUID,
      );

      //print(comment.toString());
      presenter.sync(comment);

    }
  }

  Widget _buildCommentList(Sighting sighting,BuildContext buildContext){

    return FutureBuilder<List<Comment>>(

      future : _loadSightingComments(sighting),
      builder: (context,snapshot){

        if(snapshot.hasData && snapshot != null){

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,index){
              if(index < _comments.length){
                return Column(children: [
                  Padding(padding: EdgeInsets.only(bottom: 10),),
                  ListTile(title:Text(snapshot.data[index].commentBody,style: Constants.defaultCommentTextStyle,)),
                  Padding(padding: EdgeInsets.only(bottom: 10),),
                  Divider(height: Constants.listViewDividerHeight,color: Colors.black87),
                ]
                );
              }
            }
          );

        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );


  }

  _buildAppBar(){
    return AppBar(
      actions: <Widget>[],
      elevation: 0,
      title: Text("Comment", style: Constants.appBarTitleStyle),
    );
  }

  @override
  Widget build(BuildContext buildContext) {

    int sightingNid = this.sighting.nid;
    String sightingUuid = this.sighting.uuid;
    int sightingUid = this.sighting.uid;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children:[
          Expanded(child: _buildCommentList(this.sighting,buildContext)),
          TextField(
            controller: commentController,
            onSubmitted: (String value){
              _addComment(uid:sightingUid,sightingNid: sightingNid,textComment: value,sightingUUID: sightingUuid);
              commentController.text = "";

            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20.0),
              hintText: "Add comment",
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onDeleteSuccess(Comment comment) {
    // TODO: implement onDeleteSuccess
  }

  @override
  void onSocketFailure() {
    // TODO: implement onSocketFailure
  }

  @override
  void onSyncFailure(int statusCode) {
    // TODO: implement onSyncFailure
  }

  @override
  void onSyncSuccess(Comment comment, int cid, bool editing) {

    setState(() {
      _isLoading = false;
    });

    if(cid > 0 && comment != null) {

      comment.cid = cid;

      // Editing = false : We are directly syncing the comment up to the server and get back
      // a new 'cid' which will be assigned to the comment and then be saved locally
      comment.saveToDatabase(false).then((savedCommentWithNewCID) {

        if(savedCommentWithNewCID != null) {
          /*if(editing) {
              print(
                  "[COMMENT_EDIT_PAGE::onSyncSuccess()] updated comment : ${comment
                      .toString()}");
            }else{
              print(
                  "[COMMENT_EDIT_PAGE::onSyncSuccess()] created new commet : ${comment
                      .toString()}");
            }*/

        }else{
          print("[COMMENT_EDIT_PAGE::onSyncSuccess()] updated/creation not completed");
        }

      });

    }
  }

}