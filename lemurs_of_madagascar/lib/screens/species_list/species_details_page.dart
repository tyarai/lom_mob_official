import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class SpeciesDetailsPage extends StatelessWidget {
  Species species;

  SpeciesDetailsPage({species: Species}) {
    this.species = species;
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );*/
    return Scaffold(
      backgroundColor: Constants.mainColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        child: Material(
            elevation: 5.0,
            borderRadius:
                BorderRadius.circular(Constants.speciesImageBorderRadius),
            shadowColor: Colors.blueGrey,
            child: Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: OutlineButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close),
                    )),
                _buildBody(),
              ],
            )),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(species.title),
    );
  }

  Widget _buildBody() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          child: Column(children: <Widget>[
            Species.buildLemurPhoto(species,
                imageClipper: SpeciesImageClipperType.rectangular,
                width: 100,
                height: 100),
            Container(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

              Species.buildTextInfo(species) ,
            ]),
          ]),
        ));

    /*
    return Material(
        child: Column(children: <Widget>[
          Species.buildLemurPhoto(species,imageClipper: SpeciesImageClipperType.rectangular),
          Text(
            species.title,
            style: TextStyle(fontSize: Constants.titleFontSize),
          )
    ]));*/
  }
}
