
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';

class LOMSharedPreferences{


    static String recentSpeciesSearchKey = "recentSpeciesSearchKey";

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
          Species species = await helper.getSpeciesWithID(id: int.parse(idList[i]));
          //print("2-"+species.toString());
          recentSearchList.add(species);

       }
    }

    //print("3- LOAD LIST:"+recentSearchList.toString());
    return recentSearchList;

  }



}