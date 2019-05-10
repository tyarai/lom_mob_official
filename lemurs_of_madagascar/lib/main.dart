import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/screens/Introduction.dart';
import 'package:lemurs_of_madagascar/screens/species_list/species_list_page.dart';
import 'package:lemurs_of_madagascar/screens/sightings/sighting_list_page.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/screens/user/login_page.dart';
import 'package:lemurs_of_madagascar/screens/user/register_page.dart';


final routes = {

  '/introduction'    : (BuildContext context) => IntroductionPage(title: "Lemurs of madagascar",),
  '/species_list'    : (BuildContext context) => SpeciesListPage(title: "Species",),
  '/login'           : (BuildContext context) => LoginPage(),
  '/register'        : (BuildContext context) => RegisterPage(),
  //'/'                : (BuildContext context) => IntroductionPage(title: "Lemurs of madagascar",),//(BuildContext context) => LoginPage(),
  '/'                : (BuildContext context) => LoginPage(),
  '/sighting_list'   : (BuildContext context) => SightingListPage(title:"Sightings"),


};

void main() => runApp(LOMApp());

class LOMApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Constants.mainColor,
      ),
      routes: routes,
      initialRoute: '/',
      //home: IntroductionPage(title: 'Lemurs of madagascar'),
    );
  }
}

