import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/screens/sightings/sighting_edit_page.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/utils/user_session.dart';


class SightingListPage extends StatefulWidget {

  final String title;

  SightingListPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return _SightingListPageState(this.title);
  }

}

class _SightingListPageState extends State<SightingListPage> {

  String title;
  int currentUid = 0;
  int _bottomNavIndex = 0;
  List<Sighting> sightingList = List<Sighting>();
  SightingBloc sightingBloc = SightingBloc();

  List<String> _menuName = [
    "New sighting",
    "Favorite species",
  ];

  //String _title = "";


  @override
  void dispose() {
    sightingBloc.dispose();
    super.dispose();
  }

  @override
  initState()  {


    //Sighting.deleteAllSightings();

    super.initState();

    //Future<int> _currentID = UserSession.loadCurrentUserUID();
    Future<User> user = User.getCurrentUser();

    user.then((_user){

      if(_user != null) {

        this.currentUid = _user.uid;

        try {
          if (currentUid > 0) {
            //print("current UID " + this.currentUid.toString());

            if (sightingList.length == 0) {
              Future<List<Sighting>> futureList = _loadData(currentUid);
              futureList.then((list) {
                setState(() {
                  sightingList = list;
                });
              });
            }
          } else {
            //TODO : The user is not connected. Redirect to login page
          }
        } catch (e) {
          print(e.toString());
        }

      }

    });


  }

  _SightingListPageState(this.title);

  @override
  Widget build(BuildContext buildContext) {

      return
        Scaffold(
            backgroundColor: Constants.backGroundColor,
            appBar: AppBar(
              actions: <Widget>[
                _buildSearch(),
              ],
              title: Text(widget.title),
            ),
            body: _buildSightingListView(),
            bottomNavigationBar: _buildBottomNavBar(),
        );
  }


  Theme _buildBottomNavBar() {
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Constants.mainColor,
          primaryColor: Colors.red,
        ),
        child: BottomNavigationBar(
          fixedColor: Colors.greenAccent,
          type: BottomNavigationBarType.shifting,
          currentIndex: _bottomNavIndex,
          onTap: (int index) {
            setState(() {
              _bottomNavIndex = index;
              //_title = _menuName[_bottomNavIndex];
            });
            _handleBottomNavTap(_bottomNavIndex);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box,color: Constants.iconColor,),
              title: Text(_menuName[0]),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite,color: Constants.iconColor,),
              title: Text(_menuName[1]),
            ),

          ],
        ));
  }


  void _handleBottomNavTap(int index){


    Sighting emptySighting = Sighting();
    sightingBloc.sightingEventController.add(SightingChangeEvent(emptySighting));

    switch(index) {
      case 0:
        Navigator.of(context).push(
            MaterialPageRoute(
            fullscreenDialog: true, builder: (buildContext) =>
               BlocProvider(
                 child: SightingEditPage("New sighting",emptySighting,false),
                 bloc: sightingBloc,
               ))
            );

    }

  }

  /*Widget _newSightingTab() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 10),

        ]);
  }*/

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

  Widget _buildSightingListView() {


    return FutureBuilder<List<Sighting>>(
      future: _loadData(this.currentUid),
      initialData: this.sightingList,
      builder: (BuildContext context, AsyncSnapshot<List<Sighting>> snapshot) {

        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            print("item count ${snapshot.data.length}");
            return  _SightingListPageState.buildCellItem(context,snapshot.data,index,this.sightingBloc);
          });
      },
    );
  }

  Future<List<Sighting>> _loadData(int uid) async {
    if(uid != null) {
      SightingDatabaseHelper sightingDBHelper = SightingDatabaseHelper();
      List<Sighting> futureList = await sightingDBHelper.getSightingList(uid);
      return futureList;
    }
    return null;
  }

  static Widget buildCellItem(BuildContext context,List<Sighting> list,int index,SightingBloc bloc)
  {

    if(list != null && list.length > 0 && (index >= 0 && index < list.length)) {

      Sighting sighting = list[index];

      return GestureDetector(
          onTap: () {

            bloc.sightingEventController.add(SightingChangeEvent(sighting));
            //print("TAPPED ON "+ sighting.toString());

            Navigator.of(context).push(
                MaterialPageRoute(
                    fullscreenDialog: true, builder: (buildContext) =>
                BlocProvider(
                  child: SightingEditPage("Edit sighting",sighting,true),
                  bloc: bloc,
                ))
            );

          },
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                              Sighting.buildCellInfo(sighting),
                            ])),
                  ))));
    }

    return Container();

  }
}