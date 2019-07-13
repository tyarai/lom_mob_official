import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/screens/sightings/sighting_edit_page.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SightingListPage extends StatefulWidget {

  final String title;


  // By default show sighting list
  SightingListPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return _SightingListPageState(this.title);
  }

}

class _SightingListPageState extends State<SightingListPage>  implements GetSightingsContract {

  String title;
  int currentUid = 0;
  int _bottomNavIndex = 0;
  bool _isLoading = false;
  List<Sighting> _myCurrentList;
  SightingBloc sightingBloc = SightingBloc();
  //bool _isEditing = false;
  GetSightingPresenter _getSightingPresenter;

  _SightingListPageState(this.title){
    _getSightingPresenter = GetSightingPresenter(this);
  }

  List<String> _menuName = [
    "My sightings",
    "Illegal activities",
  ];

  @override
  void dispose() {
    sightingBloc.dispose();
    super.dispose();
  }

  @override
  initState()  {

    //Sighting.deleteAllSightings();
    super.initState();
    //_loadData(illegalActivity: false);

  }


  Widget _buildTitle(){

    return FutureBuilder<String>(

        future: LOMSharedPreferences.loadString(LOMSharedPreferences.lastSightingMenuIndexKey),
        builder: (context,snapshot){

          this._bottomNavIndex = 0;

          if(snapshot.data != null &&  snapshot.data.length != 0 && snapshot.hasData) {
            this._bottomNavIndex = int.parse(snapshot.data);

          }
          return Text(this._menuName[this._bottomNavIndex]);
          //return Container();//Empty list no sighting
        }

    );
  }

  @override
  Widget build(BuildContext buildContext)  {

      return
        Scaffold(
            backgroundColor: Constants.backGroundColor,
            appBar: AppBar(
              centerTitle: true,
              actions: <Widget>[
                _buildAddSighting(),
                _buildSearch(),
              ],
              title: _buildTitle(),
            ),
            body: ModalProgressHUD(
                child: _showTab(buildContext),
                opacity: 0.8,
                //color: Constants.mainSplashColor,
                //progressIndicator: CircularProgressIndicator(),
                //offset: 5.0,
                //dismissible: false,
                inAsyncCall: _isLoading),
            bottomNavigationBar: _buildBottomNavBar(),
            floatingActionButton: _buildFloatingActionButton(),
        );
  }

   Widget _showTab(BuildContext buildContext)  {

    return FutureBuilder<String>(

      future: LOMSharedPreferences.loadString(LOMSharedPreferences.lastSightingMenuIndexKey),
      builder: (context,snapshot){

        //if(snapshot.data != null &&  snapshot.data.length != 0 && snapshot.hasData) {
        if(snapshot.connectionState == ConnectionState.done) {

          //print("LAST MENU "+ snapshot.data);

          this._bottomNavIndex = (snapshot.data != null && snapshot.data.length != 0) ? int.parse(snapshot.data) : 0;

          return _buildSightingListView(buildContext);

        }
        return Center(child: Container(child:CircularProgressIndicator()));
      }

    );

  }

  _buildAddSighting(){
    return IconButton(
      icon: Icon(Icons.add,size: 30,),
      onPressed:(){
        LOMSharedPreferences.setString(LOMSharedPreferences.lastSightingMenuIndexKey,"0");
        Sighting emptySighting = Sighting();
        sightingBloc.sightingEventController.add(SightingChangeEvent(emptySighting));
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true, builder: (buildContext) =>
            BlocProvider(
              child: SightingEditPage(this._menuName[0],emptySighting,false),
              bloc: sightingBloc,
            ))
        );
      },
    );
  }

  _buildFloatingActionButton()  {
    return FloatingActionButton(
      child: Icon(Icons.refresh,size: 35,),
      onPressed: (){

        setState((){
          _isLoading = true;
        });

        LOMSharedPreferences.loadString(LOMSharedPreferences.lastSyncDateTime).then((_lastDate){
          DateTime fromDate;
          if(_lastDate != null && _lastDate.length != 0){
            fromDate = DateTime.fromMillisecondsSinceEpoch(int.parse(_lastDate),isUtc: true);
          }else{
            //fromDate =   DateTime.now().millisecondsSinceEpoch;
            fromDate =   DateTime.now().toUtc();

          }
          print("REFERENCE DATE "+fromDate.toString());
          this._getSightingPresenter.get(fromDate);
        });

      },
    );
  }

  Theme _buildBottomNavBar() {

    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Constants.mainColor,
          primaryColor: Colors.red,
        ),
        child: SizedBox(
          height: 58,
          child: BottomNavigationBar(
            fixedColor: Colors.greenAccent,
            type: BottomNavigationBarType.fixed,
            currentIndex: _bottomNavIndex,
            onTap: (int index) {
              setState(() {
                //_isLoading = true;
                _bottomNavIndex = index;
                _handleBottomNavTap(_bottomNavIndex);
                title = _menuName[_bottomNavIndex];
              });

            },
            items: [
              BottomNavigationBarItem(
                icon:  Icon(Icons.remove_red_eye,color: Constants.iconColor,),
                title: Text(_menuName[0],style:Constants.defaultTextStyle.copyWith(color:Constants.iconColor,fontSize: 15)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report_problem,color: Constants.iconColor,),
                title: Text(_menuName[1],style:Constants.defaultTextStyle.copyWith(color:Constants.iconColor,fontSize: 15)),
              ),


            ],
          ),
        ));
  }

  void _handleBottomNavTap(int index){

    LOMSharedPreferences.setString(LOMSharedPreferences.lastSightingMenuIndexKey,index.toString());

    /*switch(index) {

      case 0:
        {
          _loadSighting(false);
          break;
        }

      case 1:
        {
          _loadSighting(true);
          break;
        }

    }*/

  }

  Widget _buildSearch(){
    return IconButton(
      icon: Icon(Icons.search),
      onPressed:(){
        /*showSearch(
            context: context,
            delegate: DataSearch(speciesList: this._speciesList));*/
      },
    );
  }

  Widget _buildSightingListView(BuildContext buildContext) {

    return PagewiseListView(
        pageSize: Constants.recordLimit,
        showRetry: false,
        itemBuilder: (context, entry, index) {
          Sighting sighting = entry;
          return this.buildCellItem(context, sighting, sightingBloc);
        },
        pageFuture: (pageIndex) {
          return _loadData(illegalActivity: _bottomNavIndex == 0 ? false : true);
        },
        errorBuilder: (context, error) {
          return Text('Error: $error');
        },
        loadingBuilder: (context) {
          return Center(child:CircularProgressIndicator());
        }
    );

    /*return FutureBuilder<List<Sighting>>(

        future: _loadData(illegalActivity: _bottomNavIndex == 0 ? false : true),

        builder: (BuildContext context, AsyncSnapshot<List<Sighting>> snapshot) {
          if (snapshot.hasData ) {
            print("GOT LIST");
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  Sighting sighting = snapshot.data[index];
                  return this.buildCellItem(context, sighting, sightingBloc);
                });
          }
          return Container(child: CircularProgressIndicator(),);
        }); */
  }

  /*
  Widget _buildSightingListView(BuildContext buildContext) {

    return FutureBuilder<List<Sighting>>(

      future: _loadData(illegalActivity: _bottomNavIndex == 0 ? false : true),

      builder: (BuildContext context, AsyncSnapshot<List<Sighting>> snapshot) {
        if (snapshot.hasData ) {
          print("GOT LIST");
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext buildContext, int index) {
                Sighting sighting = snapshot.data[index];
                return this.buildCellItem(context, sighting, sightingBloc);
              });
        }
        return Container(child: CircularProgressIndicator(),);
      });
  } */

  /*Widget _buildIllegalActivityListView(BuildContext buildContext) {

    return FutureBuilder<List<Sighting>>(

      future: _loadData(illegalActivity: true),

      builder: (BuildContext context, AsyncSnapshot<List<Sighting>> snapshot) {

        switch(snapshot.connectionState) {

          case  ConnectionState.active : return Center(child: CircularProgressIndicator());

          case ConnectionState.waiting :
            {
              return Center(child: CircularProgressIndicator());

            }
          case ConnectionState.done:
            {
              if(snapshot.hasData && !snapshot.hasError) {

                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext buildContext, int index) {
                      Sighting sighting = snapshot.data[index];
                      return this.buildCellItem(context,sighting,sightingBloc);
                    });
              }
              break;
            }

          case ConnectionState.none:{
            return Container();
          }

        }
      },
    );
  } */

  Future<List<Sighting>> _loadData({int pageIndex, int limit,bool illegalActivity=false}) async {

    Future<User> user = User.getCurrentUser();

    return user.then((_user){

      if(_user != null) {

        this.currentUid = _user.uid;

        try {

          if (currentUid > 0) {

            SightingDatabaseHelper sightingDBHelper = SightingDatabaseHelper();
            return sightingDBHelper.getSightingList(currentUid,pageIndex:pageIndex,limit:limit,illegalActivity: illegalActivity).then((_list){
              this.onLoadingListSuccess();
              this._myCurrentList = _list;
              return _list;
            });
          }

        } catch (e) {
          print("[SIghting_list::_loadData()] Error : "+ e.toString());
        }

      }

    });
  }

  Widget buildCellItem(BuildContext context,Sighting sighting,SightingBloc bloc)
  {

    if(sighting != null) {

      return Container(
        child: ListTile(
          contentPadding: EdgeInsets.only(left:5.0,right:5.0),
            onTap: () {

                 this.sightingBloc.sightingEventController.add(SightingChangeEvent(sighting));

                 Navigator.of(context).push(
                     MaterialPageRoute(
                         fullscreenDialog: true, builder: (buildContext) =>
                         BlocProvider(
                           child: SightingEditPage("Edit sighting",sighting,true),
                           bloc: this.sightingBloc,
                         ))
                 );

            },
            title: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Container(
                    child: Material(
                      elevation: 1.0,
                      borderRadius: BorderRadius.circular(0.5),
                      shadowColor: Colors.blueGrey,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child:
                              Sighting.buildCellInfo(sighting,bloc,context),
                            ),
                    )))),
      );
    }

    return Container();

  }

  @override
  void onGetSightingFailure(int statusCode) {
    setState(() {
      _isLoading = false;
    });
    //ErrorHandler.handleException(context, e);
  }


  void onLoadingListSuccess() {
    //print("TATO");
    /*setState((){
      _isLoading = false;
    });*/

    //ErrorHandler.handleException(context, e);
  }

  @override
  void onGetSightingSuccess(List<Sighting> sightingList) {

    print("onGetSightingSuccess()");

     if(sightingList != null ){

       SightingDatabaseHelper db = SightingDatabaseHelper();

       for(Sighting sighting in sightingList){

         if(sighting != null){

            db.getSightingMapWithNID(sighting.nid).then((result){

              if(result != null && result.length != 0){

                //print("EXISTING SIGHTING $sighting.nid");
                // The sighting already exists in local database the update local data
                sighting.saveToDatabase(true,nid:sighting.nid).then((savedSighting){
                  if(savedSighting == null){
                    print("[Sighting_list_page::onGetSightingSuccess()] Error: Online sighting not updated on local database");
                  }else{
                    print("[Sighting_list_page::onGetSightingSuccess()] Success: Online sighting updated on local database");
                  }

                });

            }else{
              // The sighting  does not exist in local database then insert it
              sighting.saveToDatabase(false,nid:sighting.nid).then((savedSighting){
                if(savedSighting == null){
                  print("[Sighting_list_page::onGetSightingSuccess()] Error: Online sighting not inserted to local database");
                }else{
                  print("[Sighting_list_page::onGetSightingSuccess()] Success: Online sighting inserted to local database");
                }

             });

            }

          });


         }
       }

       setState((){
         _isLoading = false;
       });

     }

     /*setState((){
       print("NOT Loading");
       _isLoading = false;
     });*/
  }

  @override
  void onSocketFailure() {
    // TODO: implement onSocketFailure
    setState(() {
      _isLoading = false;
    });
    //ErrorHandler.handleException(context, e);
  }

  @override
  void onException(Exception e) {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handleException(context, e);
  }


}

