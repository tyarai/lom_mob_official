import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/screens/sightings/sighting_edit_page.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';

class SightingListPage extends StatefulWidget {

  final String title;


  // By default show sighting list
  SightingListPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return _SightingListPageState(this.title);
  }

}

class _SightingListPageState extends State<SightingListPage>  {

  String title;
  int currentUid = 0;
  int _bottomNavIndex = 0;
  List<Sighting> sightingList = List<Sighting>();
  SightingBloc sightingBloc = SightingBloc();
  bool _isEditing = false;


  _SightingListPageState(this.title);

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

    Future<User> user = User.getCurrentUser();

    user.then((_user){

      if(_user != null) {

        this.currentUid = _user.uid;

        try {

          if (currentUid > 0) {
            print("current UID " + this.currentUid.toString());

            //if (sightingList.length == 0) {
              _loadSighting(false);
            //}

          } else {
            //TODO : The user is not connected. Redirect to login page
          }

        } catch (e) {
          print(e.toString());
        }

      }

    });
  }

  _loadSighting(bool illegalActivity){

    Future<List<Sighting>> futureList = _loadData(currentUid,illegalActivity: illegalActivity);
    futureList.then((list) {
      setState(() {
        sightingList = list;
      });
    });

  }



  @override
  Widget build(BuildContext buildContext)  {

      return
        Scaffold(
            backgroundColor: Constants.backGroundColor,
            appBar: AppBar(
              actions: <Widget>[
                _buildSearch(),
              ],
              title: Text(title),
            ),
            body:  _showTab(buildContext),
            bottomNavigationBar: _buildBottomNavBar(),
            floatingActionButton: _buildFloatingActionButton(),
        );
  }

   Widget _showTab(BuildContext buildContext)  {

    return FutureBuilder<String>(

      future: LOMSharedPreferences.loadString(LOMSharedPreferences.lastSightingMenuIndexKey),
      builder: (context,snapshot){

        if(snapshot.data != null &&  snapshot.data.length != 0 && snapshot.hasData) {
          this._bottomNavIndex = int.parse(snapshot.data);
          switch (this._bottomNavIndex) {
            case 0:
              return _buildSightingListView(buildContext);
            case 1:
              return _buildIllegalActivityListView(buildContext);
          }
        }
        return Container();
      }

    );

  }

  _buildFloatingActionButton(){
    return FloatingActionButton(
      child: Icon(Icons.add,size: 35,),
      onPressed: (){

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
                _bottomNavIndex = index;
                title = _menuName[_bottomNavIndex];
              });
              _handleBottomNavTap(_bottomNavIndex);
            },
            items: [
              BottomNavigationBarItem(
                icon:  Icon(Icons.remove_red_eye,color: Constants.iconColor,),
                title: Text(_menuName[0],style:Constants.defaultTextStyle.copyWith(color:Colors.white,fontSize: 15)),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report_problem,color: Constants.iconColor,),
                title: Text(_menuName[1],style:Constants.defaultTextStyle.copyWith(color:Colors.white,fontSize: 15)),
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
          /*Navigator.of(context).push(
              MaterialPageRoute(
                  fullscreenDialog: true, builder: (buildContext) =>
                  BlocProvider(
                    child: SightingListPage(title: this._menuName[0]),
                    bloc: sightingBloc,
                  ))
          );*/
          break;
        }

      case 1:
        {
          /*Navigator.of(context).push(
              MaterialPageRoute(
                  fullscreenDialog: true, builder: (buildContext) =>
                  BlocProvider(
                    child: SightingListPage(title: this._menuName[1]),
                    bloc: sightingBloc,
                  ))
          );*/
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

    return FutureBuilder<List<Sighting>>(

      future: _loadData(this.currentUid,illegalActivity:false),//Get Sighting list

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
                      //print("item count ${snapshot.data.length}
                      Sighting sighting = snapshot.data[index];
                      //print("{SIGHYTING} $sighting");
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
  }

  Widget _buildIllegalActivityListView(BuildContext buildContext) {

    return FutureBuilder<List<Sighting>>(

      future: _loadData(this.currentUid,illegalActivity: true),

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
                      //print("item count ${snapshot.data.length}
                      Sighting sighting = snapshot.data[index];
                      //print("{SIGHYTING} $sighting");
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
  }

  Future<List<Sighting>> _loadData(int uid,{bool illegalActivity=false}) async {
    if(uid != null) {
      SightingDatabaseHelper sightingDBHelper = SightingDatabaseHelper();
      List<Sighting> futureList = await sightingDBHelper.getSightingList(uid,illegalActivity: illegalActivity);
      return futureList;
    }
    return List();
  }

  Widget buildCellItem(BuildContext context,Sighting sighting,SightingBloc bloc)
  {

    if(sighting != null) {

      //print("{SIGHTING} $sighting");

      return ListTile(
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
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                  child: Material(
                    elevation: 1.0,
                    borderRadius: BorderRadius.circular(0),
                    shadowColor: Colors.blueGrey,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(height: 10),
                              Sighting.buildCellInfo(sighting,bloc,context),
                            ])),
                  ))));
    }

    return Container();

  }


}

