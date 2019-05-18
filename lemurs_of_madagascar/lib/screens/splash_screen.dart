import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/user_session.dart';
import 'package:lemurs_of_madagascar/screens/user/login_page.dart';
import 'package:lemurs_of_madagascar/screens/Introduction.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _SplashScreenState();
  }

}

class _SplashScreenState extends State<SplashScreen> {


  Future<UserSession> userSession;


  @override
  void initState() {
    super.initState();

    userSession = UserSession.getCurrentSession();

    userSession.then((session){

      if(session != null) {
        /*Timer(
            Duration(seconds: Constants.splashDurationInSecond), () {
          _navigateToNextPage(IntroductionPage(title: Constants.appName,),);
          }
        );*/

      }else{

        /*Timer(
            Duration(seconds: Constants.splashDurationInSecond), () {
          _navigateToNextPage(LoginPage());
          }
        );*/

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

      body: Stack(
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
                  flex: 2,
                  child: Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Center(child: Text(Constants.appName,textAlign: TextAlign.center,style: Constants.splashAppTitleStyle, textScaleFactor: 1,)),
                        Padding(padding: EdgeInsets.only(bottom:100),),
                        /*CircleAvatar(
                          backgroundColor:Colors.white,
                          radius: 50,
                          //child: Icon(Icons.pets,color: Constants.mainColor,size:50),
                          backgroundImage :
                                      AssetImage(
                                        "assets/images/ram-everglades(resized).jpg"),

                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10.0,right:10),
                          child: Center(child: Text(Constants.appCreed, textAlign: TextAlign.center ,style: Constants.splashAppCreedStyle, textScaleFactor: 1,)),
                        ),*/
                        //Padding(padding: EdgeInsets.only(top:20),),

                      ],

                    ),
                  ),

                ),

                Expanded(
                  flex:1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      //CircularProgressIndicator(),
                      //Padding(padding: EdgeInsets.only(top: 20.0),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor:Colors.white,
                                radius: 50,
                                //child: Icon(Icons.pets,color: Constants.mainColor,size:50),
                                backgroundImage :
                                AssetImage(
                                    "assets/images/ram-everglades(resized).jpg"),

                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:10.0,left:10),
                                child: SizedBox(width: 150, child: Align(alignment: Alignment.center, child: Text(Constants.appCreed,style: Constants.splashAppCreedStyle,textScaleFactor: 1.0,))),
                              ),
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

      ),


    );

  }

}