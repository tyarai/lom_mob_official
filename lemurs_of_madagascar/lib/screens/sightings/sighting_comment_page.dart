
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/comment_database_helper.dart';
import 'package:lemurs_of_madagascar/models/comment.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  Comment _currentComment;

  _SightingCommentPage(this.sighting){
    presenter = SyncCommentPresenter(this);
  }


  @override
  void initState() {
    super.initState();
    _currentComment = null;
    commentController.addListener(_onCommentChanged);
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

  _addComment({int uid,int sightingNid,String textComment,String sightingUUID , User user}){


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
          name:user.name,
          mail:user.mail,
          uuid:uuid,
          sightingUUID:sightingUUID,
      );

      //print(comment.toString());
      presenter.sync(comment,editing: false);

    }
  }

  _updateComment(Comment comment){
    if(comment != null){
      presenter.sync(comment,editing:true);
    }
  }

  _selectComment(Comment comment){
    if(comment != null){
      _currentComment = comment;
      commentController.text = comment.commentBody;
    }
  }

  _onCommentChanged(){
    if(_currentComment != null){
      if(commentController.text.length > 0) {
        _currentComment.commentBody = commentController.text;
      }else{
        _currentComment = null;
      }

    }
  }

  _buildAvatar(Comment comment){
    if(comment != null) {
      return Column(
        children: [CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.yellowAccent,
            radius: 20,
            child: Icon(Icons.person, color: Constants.mainColor, size: 25),
            //backgroundImage : AssetImage("assets/images/ram-everglades(resized).jpg"),
          ),
          Padding(padding: EdgeInsets.only(top:5),),
          Text(comment.name != null ? comment.name : "",style: Constants.defaultSubTextStyle,),
        ]
      );
    }
    return Container();
  }

  Widget _buildCommentList(Sighting sighting,BuildContext buildContext){

    return FutureBuilder<List<Comment>>(

      future : _loadSightingComments(sighting),
      builder: (context,snapshot){

        if(snapshot.hasData && snapshot != null){

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,index){
              //if(index < _comments.length){
                return Column(
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 5),),
                    /*ListTile(
                      onTap: (){
                        _selectComment(snapshot.data[index]);
                      },
                      leading: _buildAvatar(snapshot.data[index]),
                      /*trailing: IconButton(
                        icon:Icon(Icons.remove_circle,color: Colors.red,),
                        onPressed: _markCommentAsDeleted(snapshot.data[index]),
                      ),*/
                      title:Text(snapshot.data[index].commentBody,textAlign: TextAlign.justify, style: Constants.defaultCommentTextStyle,)
                    ),*/
                    _buildCommentContent(snapshot.data[index]),
                    Padding(padding: EdgeInsets.only(bottom: 5),),
                    Divider(height: Constants.listViewDividerHeight,color: Colors.black87),
                ]);
              //}
            }
          );

        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  /*bool _checkCommentOwnership(Comment comment){
    if(comment != null){
      Future<User> currentUser = User.getCurrentUser();
      currentUser.then((_currentUser){
        if(_currentUser != null){
          if (comment.uid == _currentUser.uid) return true;
        }
        return false;
      });
    }
    return false;
  }*/

  Future<bool> _checkCommentOwnership(Comment comment) async{
    if(comment != null){
      User currentUser = await  User.getCurrentUser();
      if(currentUser != null){
        if (comment.uid == currentUser.uid) return true;
      }
    }
    return false;
  }

  _buildCommentContent(Comment comment)  {

    if(comment != null){

      return GestureDetector(
        onTap: () {
          _selectComment(comment);
        },

        child: Container(
          child: Material(
            //color: _buildBackGroundColor(provider,index),
            elevation: 0.0,
            //borderRadius: BorderRadius.circular(borderRadius),
            shadowColor: Colors.blueGrey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex:1,child:_buildAvatar(comment)),
                Padding(padding: EdgeInsets.only(left: 10.0)),
                Expanded(flex:4,child:Text(comment.commentBody,textAlign: TextAlign.justify, style: Constants.defaultCommentTextStyle,)),
                Expanded(flex:1,child: _delete(comment)  )
              ]),
          )),

      );
    }

    return Container();

  }

  Widget _delete(Comment comment){
      return FutureBuilder(
        future:_checkCommentOwnership(comment),
        builder:(context,snapshot){
          return IconButton(
            icon: Icon(Icons.remove_circle_outline,color: Colors.red,),
              onPressed: (){
              setState(() {
                _isLoading = true;
              });
              _markCommentAsDeleted(comment);
            },
          );
        }
      );
    }



  // We use 'status' to hide deleted comment locally and on the server (we do not actually remove comments then)
  _markCommentAsDeleted(Comment comment){

    if(comment != null){

      double modified = DateTime.now().millisecondsSinceEpoch.toDouble();
      comment.modified = modified;
      comment.deleted = 1;
      comment.status = 0;
      presenter.sync(comment,editing: true);

    }
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

    return WillPopScope(

      onWillPop: () async {
        if(_isLoading) return false;
        return true;
      },

      child: Scaffold(
        appBar: _buildAppBar(),
        body: ModalProgressHUD(
          opacity: 0.3,
          inAsyncCall:_isLoading,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children:[
                Expanded(child: _buildCommentList(this.sighting,buildContext)),
                Container(
                  child: TextField(
                  style: Constants.defaultTextStyle,
                  controller: commentController,
                  onSubmitted: (String value){

                    setState(() {
                      _isLoading = true;
                    });

                    if(_currentComment == null){

                      Future<User> user = User.getCurrentUser();

                      user.then((currentUser){
                        // Create new comment
                        _addComment(uid:sightingUid,sightingNid: sightingNid,textComment: value,sightingUUID: sightingUuid,user:currentUser);
                      });

                    }else{
                      _updateComment(_currentComment);
                      _currentComment = null;
                    }

                    commentController.text = "";

                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    hintText: "Add comment",
                  ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onDeleteSuccess(Comment comment) {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onSocketFailure() {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handleSocketError(context);
  }

  @override
  void onSyncFailure(int statusCode) {
    setState(() {
      _isLoading = false;
    });

  }

  @override
  void onSyncSuccess(Comment comment, int cid, bool editing) {

    setState(() {
      _isLoading = false;
    });

    if(cid > 0 && comment != null) {

      comment.cid = cid;

      comment.saveToDatabase(editing).then((savedCommentWithNewCID) {

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