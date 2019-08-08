import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/screens/Introduction.dart';
import 'package:lemurs_of_madagascar/screens/authors/authors_page.dart';
import 'package:lemurs_of_madagascar/screens/families/family_page.dart';
import 'package:lemurs_of_madagascar/screens/instructions/instructions_page.dart';
import 'package:lemurs_of_madagascar/screens/lemur_life_list/lemur_life_list_page.dart';
import 'package:lemurs_of_madagascar/screens/origin_of_lemurs/origin_of_lemurs.dart';
import 'package:lemurs_of_madagascar/screens/partners/partner_page.dart';
import 'package:lemurs_of_madagascar/screens/sites/site_page.dart';
import 'package:lemurs_of_madagascar/screens/species_list/species_list_page.dart';
import 'package:lemurs_of_madagascar/screens/sightings/sighting_list_page.dart';
import 'package:lemurs_of_madagascar/screens/lom_splash_screen.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/screens/user/login_page.dart';
import 'package:lemurs_of_madagascar/screens/user/register_page.dart';


import 'extinct_lemurs/extinct_lemurs_page.dart';


final routes = {

  '/introduction'    : (BuildContext context) => IntroductionPage(title: "Lemurs of madagascar",),
  '/lemur_life_list' : (BuildContext context) => LemurLifeListPage(title: "My lemur life list",),
  '/origin_of_lemurs': (BuildContext context) => OriginOfLemursPage(title: "Origin of lemurs",),
  '/extinct_lemurs'  : (BuildContext context) => ExtinctLemursPage(title: "Extinct lemurs",),
  '/authors_page'    : (BuildContext context) => AuthorsPage(title: "Authors",),
  '/species_list'    : (BuildContext context) => SpeciesListPage(title: "Species",),
  '/family_page'     : (BuildContext context) => FamilyPage(title: "Family",),
  '/site_page'       : (BuildContext context) => SitePage(title: "Watching sites",),
  '/partner_page'    : (BuildContext context) => PartnerPage(title: "Partner page",),
  '/instructions'    : (BuildContext context) => InstructionsPage(title: "App instructions",),
  '/login'           : (BuildContext context) => LoginPage(),
  '/register'        : (BuildContext context) => RegisterPage(),
  '/'                : (BuildContext context) => LOMSplashScreen(),
  '/sighting_list'   : (BuildContext context) => SightingListPage(title:"My sightings"),


};

void main() => runApp(LOMApp());

class LOMApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lemurs of Madagascar',
      theme: ThemeData(
        primarySwatch: Constants.mainColor,
      ),
      routes: routes,
      initialRoute: '/',
      //home: IntroductionPage(title: 'Lemurs of madagascar'),
    );
  }
}

