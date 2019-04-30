import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SpeciesSlideShow extends StatelessWidget {

  final Species species;
  List<String> _imageFileNames = List();

  SpeciesSlideShow({this.species});



  @override
  void initState(){
    //_imageFileNames = _loadImageFilenames();
  }


   _loadImageFilenames() async {


    //print("******* #0");

    if(species != null) {
      // Load map image

      //print("******* #1");

      String stringPhotoIDs = species.photoIDs;
      List<int> photoID = stringPhotoIDs.split(",").map((stringID) {
        return int.parse(stringID);
      }).toList();


      for (int i = 0; i < photoID.length; i++) {
        int id = photoID[i];
        PhotographDatabaseHelper photographDatabaseHelper = PhotographDatabaseHelper();
        Photograph futurePhoto = await photographDatabaseHelper
            .getPhotographWithID(id: id);
        _imageFileNames.add(futurePhoto.photograph);
        //print("#2" + futurePhoto.photograph);
      }
    }

  }


  Future<Widget> _buildCarousel() async {

     await _loadImageFilenames();

     print("#0 "+_imageFileNames.toString());

    return CarouselSlider(
      height: 400.0,
      items: this._imageFileNames.map((fileName) {

        String newImageFile = "assets/images/" + fileName + ".jpg";
        print("#1 " + newImageFile);

        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.amber
                ),
                child: Image.asset(newImageFile),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context)   {

    Future<Widget> futureWidget =  _buildCarousel();
    print("#3 ");

    futureWidget.then((_widget){
      print("#4 ");
      return  _widget;
    });

    print("#6 ");
    return Container(child:Center(child:Text("NONE")));
  }

}