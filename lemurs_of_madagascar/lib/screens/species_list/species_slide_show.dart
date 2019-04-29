import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SpeciesSlideShow extends StatelessWidget {

  final Species species;
  List<String> _imageFileNames = List();

  SpeciesSlideShow({this.species}){
    _imageFileNames = _loadImageFilenames();
  }

  @override
  void initState(){
    //_imageFileNames = _loadImageFilenames();
  }


   _loadImageFilenames() async {


    print("******* #0");

    if(species != null) {
      // Load map image

      print("******* #1");

      String stringPhotoIDs   = species.photoIDs;
      List<int> photoID       = stringPhotoIDs.split(",").map((stringID){
         return int.parse(stringID) ;
      }).toList();

      photoID.forEach((id) {
        PhotographDatabaseHelper photographDatabaseHelper = PhotographDatabaseHelper();
        Future<Photograph> futurePhoto = photographDatabaseHelper.getPhotographWithID(id: id);
        futurePhoto.then((photo){
            _imageFileNames.add(photo.photograph);
        });
      });
    }

    print(_imageFileNames);


  }


  Widget _buildCarousel(){

    return CarouselSlider(
      height: 400.0,
      items: this._imageFileNames.map((fileName) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.amber
                ),
                child: Image.asset(fileName),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCarousel();
  }

}