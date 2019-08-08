import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/menu_database_helper.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/models/menu.dart';
import 'package:lemurs_of_madagascar/screens/user/login_page.dart';
import 'package:lemurs_of_madagascar/utils/user_session.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:lemurs_of_madagascar/models/user.dart';



//@TODO : 2019-04-24 : Adjust code to prevent navigating to the same page again.

abstract class IntroductionPageContract {
  void onLogOutSuccess({String destPageName = "/introduction"});
  void onLogOutFailure(int statusCode);
  void onSocketFailure();
}

class LogOutPresenter {


  IntroductionPageContract _logOutView;
  RestData logOutRestAPI = RestData();
  LogOutPresenter(this._logOutView);

  doLogOut(user,session) {
    logOutRestAPI
        .logOut(user,session)
        .then( (bool success) {
          _logOutView.onLogOutSuccess(destPageName: "/login");
          //else print("Bad thing happened");
        })
        .catchError((error) {

          if (error is LOMException) {

            _logOutView.onLogOutFailure(error.statusCode);
          }
          if (error is SocketException) _logOutView.onSocketFailure();

        });
  }
}


class IntroductionPage extends StatefulWidget {
  IntroductionPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> implements IntroductionPageContract {

  var _menuItemFontSize = 18.0;

  @override
  void initState() {
    super.initState();

    Future<UserSession> userSession = UserSession.getCurrentSession();

    userSession.then((session){

      if(session == null) {

        _navigateToNextPage(LoginPage());

          /*Timer(
              Duration(seconds: Constants.splashDurationInSecond), () {
            _navigateToNextPage(LoginPage());
          }
        );*/

      }

    });

  }

  var _iconSize = 30.0;
  LogOutPresenter logOutPresenter;
  bool _isLoading = false;


  _navigateToNextPage(StatefulWidget nextPage){

    if(nextPage != null) {

      Navigator.of(context).pushReplacement(
        PageRouteBuilder<Null>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: nextPage, //MainPage(title:Constants.myAppointmentTitle),
                    );
                  });
            },
            transitionDuration: Duration(
                milliseconds: Constants.splashTransitionDuration)),
      );

    }
  }

  _IntroductionPageState() {
    logOutPresenter = LogOutPresenter(this);
  }

    MenuDatabaseHelper _menuDatabaseHandler = MenuDatabaseHelper();

    String _introductionMenuName = "introduction";
    List<Menu> menuList;
    Menu introduction;

    @override
    Widget build(BuildContext context) {



      if (menuList == null) {
        menuList = List<Menu>();
        _updateUI();
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: ListView(
            children: _getDrawerMenu(),
          ),
        ),
        body: ModalProgressHUD(
            child: _buildBody(),
            opacity: 0.3,
            //color: Constants.mainSplashColor,
            //progressIndicator: CircularProgressIndicator(),
            //offset: 5.0,
            //dismissible: false,
            inAsyncCall: _isLoading),
      );
    }

    _buildBody(){
      return Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children:<Widget>[
                      //Expanded(flex:1,child:ConstantImage.getRussImage()),
                      SizedBox(width:100,height:100,child: ConstantImage.getRussImage()),
                      Container(width: 10,),
                      Expanded(
                        flex:2,
                        child: Hero(
                          tag: "creed",
                          child:Text("Lemur-watching with Russ Mittermeier",
                              style: Constants.titleTextStyle),
                        ),
                      )
                    ],
                  ),
                  Container(height: 20,),
                  Text(
                    introduction != null ? introduction.content : "",
                    style: Constants.defaultTextStyle,
                    textAlign: TextAlign.justify,
                  )
                ],
              )
            ],
          ));
    }

    _updateUI() async {

      Database database = await DatabaseHelper.instance.database;

      Future<List<Menu>> futureList = _menuDatabaseHandler.getMenuList(
          database: database, menuName: this._introductionMenuName);

      futureList.then((menuList) {
        setState(() {
          introduction = menuList[0];
        });
      });

    }


    List<Widget> _getDrawerMenu() {
      List<Widget> menuItems = List<Widget>();

      menuItems.add(ListTile(
        title:
        Text("Introduction", style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/ico_infos.png",
            width: _iconSize, height: _iconSize),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          _showIntroduction();

        },
      ));

      menuItems.add(ListTile(
        title: Text("Sightings & illegal activities", style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/binocular.png",
            width: _iconSize, height: _iconSize),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          _showSightings();
          }));

      menuItems.add(ListTile(
        title: Text("My lemur life list",
            style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/ico_eye.png",
            width: _iconSize, height: _iconSize),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          _showLemurLifeList();
      }));

      menuItems.add(ListTile(
        title: Text("Origin of lemurs",
            style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/origin.png",
            width: _iconSize, height: _iconSize),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          _showOriginOfLemurs();
        }
      ));

      menuItems.add(ListTile(
        title:
        Text("Extinct lemurs", style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/extinct.png",
            width: _iconSize, height: _iconSize),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          _showExtinctLemurs();
        }
      ));

      menuItems.add(ListTile(
        title: Text("About the authors",
            style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/author.png",
            width: _iconSize, height: _iconSize),
        onTap: () {
          Navigator.pop(context); // Close the drawer
          _showAuthorList();
        }
      ));

      menuItems.add(ListTile(
        title: Text("Species", style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/ico_specy.png",
            width: _iconSize, height: _iconSize),
        onTap: (){
          Navigator.pop(context); // Close the drawer
          _showSpeciesListPage();

        },
      ));

      menuItems.add(ListTile(
        title: Text("Families", style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/ico_families.png",
            width: _iconSize, height: _iconSize),
        onTap: (){
          Navigator.pop(context); // Close the drawer
          _showFamilyListPage();

        },
      ));

      menuItems.add(ListTile(
        title:
        Text("Watching sites", style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/ico_map.png",
            width: _iconSize, height: _iconSize),
        onTap: (){
          Navigator.pop(context); // Close the drawer
          _showSiteListPage();

        },
      ));

      menuItems.add(ListTile(
        title:
        Text("Our partners", style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/ico_partners.png",
            width: _iconSize, height: _iconSize),
        onTap: (){
          Navigator.pop(context); // Close the drawer
          _showPartnerPage();

        },
      ));

      /*menuItems.add(ListTile(
        title: Text("Settings", style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/settings_icon.png",
            width: _iconSize, height: _iconSize),
      ));*/

      /*menuItems.add(ListTile(
        title: Text("Report illegal activities",
            style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/sign_forbidden.png",
            width: _iconSize, height: _iconSize),
      ));*/

      /*menuItems.add(ListTile(
        title: Text("App instructions",
            style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Image.asset("assets/images/icons/about.png",
            width: _iconSize, height: _iconSize),
      ));*/

      menuItems.add(ListTile(
        title: Text("Log out",
            style: TextStyle(fontSize: _menuItemFontSize)),
        leading: Icon(Icons.close,size: _iconSize),
        onTap: () {
          //Navigator.pop(context); // Close the drawer
          _logOut();
          //_showIntroduction();

        },
      ));

      return menuItems;
    }

  _showPartnerPage(){
    Navigator.pushNamed(context, '/partner_page');
  }

  _showSiteListPage(){
    Navigator.pushNamed(context, '/site_page');
  }

  _showFamilyListPage(){
    Navigator.pushNamed(context, '/family_page');
  }

  _showAuthorList(){
    Navigator.pushNamed(context, '/authors_page');
  }

  _showExtinctLemurs(){
    Navigator.pushNamed(context, '/extinct_lemurs');
  }

  _showLemurLifeList(){
    Navigator.pushNamed(context, '/lemur_life_list');
  }

  _showOriginOfLemurs(){
    Navigator.pushNamed(context, '/origin_of_lemurs');
  }

    _logOut() {

      setState(() {
        _isLoading = true;
      });

      Future<UserSession> session = UserSession.getCurrentSession();
      session.then((_session) {

        Future<User> user = User.getCurrentUser();
        user.then((_user){
          logOutPresenter.doLogOut(_user,_session);
        });

      });

    }

    _showLoginPage(){
      Navigator.pushReplacementNamed(context, '/login');
    }

    _showIntroduction() {
      Navigator.pushNamed(context, '/introduction');
      /*Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return IntroductionPage(title: "Introduction",);
      }),
    );*/
    }

    _showSightings(){
      Navigator.pushNamed(context, '/sighting_list');
    }

    _showSpeciesListPage() {
      Navigator.pushNamed(context, '/species_list');
      /*Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        //Navigator.pop(context);
        return SpeciesListPage(title: "Species list",);
      }),
    );*/
    }

    @override
    void onLogOutFailure(int statusCode) {
      //print("CODE");
      //print("CODE");
      setState(() {
        _isLoading = false;
      });
      ErrorHandler.handle(context, statusCode);
    }

    @override
    void onLogOutSuccess({String destPageName = "/introduction"}) {


      setState(() {
        _isLoading = false;
      });

      UserSession.closeCurrentSession();
      User.clearCurrentUser();

      Navigator.of(context).pushReplacementNamed(destPageName);

      /*showAlert(
        context: context,
        title: ErrorText.credentialTitle,
        body: SuccessText.logOutSuccess,
        actions: [],
      );*/
    }

    @override
    void onSocketFailure() {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handleSocketError(context);
  }

}
