
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

class _SightingCommentPage extends State<SightingCommentPage>{

  final Sighting sighting;
  List<Comment> _comments = List();
  var commentController = TextEditingController();

  _SightingCommentPage(this.sighting);


  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  Future<List<Comment>> _loadSightingComment(int sightingNid) async {
    if(sightingNid != null) {
      CommentDatabaseHelper commentDBHelper = CommentDatabaseHelper();
      List<Comment> futureList = await commentDBHelper.getCommentList(sightingNid);
      return futureList;
    }
    return null;
  }

  _loadComments(Sighting sighting){

    Future<List<Comment>> futureList = _loadSightingComment(sighting.nid);
    futureList.then((list) {
      setState(() {
        _comments = list;
      });
    });

  }

_addComment({int uid,int sightingNid,String textComment,String name,String mail,String sightingUUID }){

    if(uid != null && sightingNid != 0 && textComment != null && textComment.trim().length != 0){

      int created = DateTime.now().millisecondsSinceEpoch;
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



      setState(() {
        _comments.add(comment);
      });

    }
  }

  Widget _buildCommentList(BuildContext buildContext){
    return ListView.builder(
      itemCount: _comments.length,
      itemBuilder: (context,index){
        if(index < _comments.length){
          return Column(children: [
            Padding(padding: EdgeInsets.only(bottom: 10),),
            ListTile(title:Text(_comments[index].commentBody,style: Constants.defaultCommentTextStyle,)),
            Padding(padding: EdgeInsets.only(bottom: 10),),
            Divider(height: Constants.listViewDividerHeight,color: Colors.black87),
            ]
          );
        }
      }
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

    SightingBloc bloc = BlocProvider.of<SightingBloc>(buildContext);
    Sighting currentSighting = bloc.sighting;

    int sightingNid = currentSighting.nid;
    String sightingUuid = currentSighting.uuid;
    int sightingUid = currentSighting.uid;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children:[
          Expanded(child: _buildCommentList(buildContext)),
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

}