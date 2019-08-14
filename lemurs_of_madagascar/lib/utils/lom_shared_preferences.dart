
import 'package:lemurs_of_madagascar/database/site_database_helper.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';

class LOMSharedPreferences{

  static String recentSpeciesSearchKey   = "recentSpeciesSearchKey";
  static String recentSiteSearchKey      = "recentSiteSearchKey";
  static String lastSightingMenuIndexKey = "lastSightingMenuIndexKey";
  static String lastSyncDateTime         = "lastSyncDateTime";

  static void addToRecentSpeciesSearch(Species species) async {

    if(species != null){

      List<Species> speciesList =  await LOMSharedPreferences.loadRecentSpeciesSearch();


     //print("1- ADD - LIST: "+speciesList.toString());

      if (!Species.isInList(species, speciesList)){

        speciesList.add(species);
        //print(speciesList[0].title);
        List<String> newIDList = List();
        for(int i = 0 ; i < speciesList.length ; i++){
          newIDList.add(species.id.toString());
        }
        final prefs = await SharedPreferences.getInstance();
        prefs.setStringList(recentSpeciesSearchKey, newIDList);


      }


    }
  }

  static Future<List<Species>> loadRecentSpeciesSearch() async {

    final prefs = await SharedPreferences.getInstance();
    List<String> idList = prefs.getStringList(LOMSharedPreferences.recentSpeciesSearchKey);
    List<Species> recentSearchList = List();

    //print("1- LOAD LIST:"+idList.toString());

    if(idList != null) {
      for (int i = 0; i < idList.length; i++) {
          SpeciesDatabaseHelper helper = SpeciesDatabaseHelper();
          Species species = await helper.getSpeciesWithID(int.parse(idList[i]));
          //print("2-"+species.toString());
          recentSearchList.add(species);

       }
    }
    return recentSearchList;

  }

  static Future<List<Site>> loadRecentSiteSearch() async {

    final prefs = await SharedPreferences.getInstance();
    List<String> idList = prefs.getStringList(LOMSharedPreferences.recentSiteSearchKey);
    List<Site> recentSearchList = List();

    if(idList != null) {
      for (int i = 0; i < idList.length; i++) {
        SiteDatabaseHelper helper = SiteDatabaseHelper();
        Site site = await helper.getSiteWithID(int.parse(idList[i]));
        recentSearchList.add(site);
      }
    }
    return recentSearchList;

  }

  static Future<String> loadString(String paramName) async {

    String resultValue = "";


    try{

      final prefs = await SharedPreferences.getInstance();
      resultValue = prefs.getString(paramName) ;

    }catch(e){
      print("[Shared preferences - loadUserSession()]  :" + e.toString());
    }


    return resultValue;
  }

  static Future<void> setString(String paramName,String value) async {

    try{

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(paramName,value);

    }catch(e){
      print("[Shared preferences - saveUserSession()]" + e.toString());
    }


  }

}