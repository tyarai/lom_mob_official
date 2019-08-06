import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/user_session.dart';
import 'package:lemurs_of_madagascar/screens/user/login_page.dart';
import 'package:lemurs_of_madagascar/screens/Introduction.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

class LOMSplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _SplashScreenState();
  }

}

class _SplashScreenState extends State<LOMSplashScreen> {

  Future<UserSession> userSession;
  Widget _nextPage;

  @override
  void initState() {
    super.initState();

    userSession = UserSession.getCurrentSession();

    userSession.then((session){

      if(session != null) {
        Timer(
            Duration(seconds: Constants.splashDurationInSecond), () {
          _navigateToNextPage(IntroductionPage(title: Constants.appName,),);
          }
        );

      }else{

        Timer(
            Duration(seconds: Constants.splashDurationInSecond), () {
          _navigateToNextPage(LoginPage());
          }
        );

      }

    });


  }

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SplashScreen("assets/animations/splash.flr",
      IntroductionPage(),
        backgroundColor: Constants.mainColor,
        startAnimation: 'INTRO',
      ),
      
      
      /*Stack(
        fit: StackFit.expand,
        children: <Widget>[

          Container(
            decoration: BoxDecoration(color:Constants.mainSplashColor),
            //decoration: BoxDecoration(color:Colors.indigoAccent),
          ),

          Container(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,
              children:<Widget>[

                Expanded(
                  flex: 3,
                  child: Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(child: Text(Constants.appName,textAlign: TextAlign.center,style: Constants.splashAppTitleStyle, textScaleFactor: 1.10,)),
                        Padding(padding: EdgeInsets.only(bottom:100),),
                      ],

                    ),
                  ),

                ),

                Expanded(
                  flex:1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:<Widget>[
                      //CircularProgressIndicator(),
                      //Padding(padding: EdgeInsets.only(top: 20.0),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[
                            SizedBox(width:100,height:100,child: ConstantImage.getRussImage()),
                            Container(width: 10,),
                            Expanded(
                              flex:2,
                              child: Hero(
                                tag: "creed",
                                child:Text("Lemur-watching with Russ Mittermeier",
                                    style: Constants.splashAppCreedStyle),
                              ),
                            )
                          ],
                        ),
                      ),


                    ],
                  ),
                ),

              ],


            ),
          ),


        ],

      ),*/


    );

  }

}