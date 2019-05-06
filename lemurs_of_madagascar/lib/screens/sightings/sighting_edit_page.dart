import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';

class SightingEditPage extends StatefulWidget {

  final String title;
  final Sighting sighting;


  SightingEditPage({this.title,this.sighting});

  @override
  State<StatefulWidget> createState() {
    return _SightingEditPage(this.title,this.sighting);
  }

}

class _SightingEditPage extends State<SightingEditPage> {

  String title;
  Sighting sighting;
  List<String> imageFileNameList = List<String>();

  _SightingEditPage(this.title,this.sighting);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: _buildBody(),
    );
  }

  _buildBody(){

    return ListView(
        children : <Widget> [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            child:Column(
              children: <Widget>[
                _buildTitleView(),
                _buildImageListView(),
              ],
            )
          )
        ],
    );

  }

  _buildImageListView(){

    return Container(


    );

  }
  _buildTitleView(){

    return Container(

      child: Text("Sighting title"),

    );

  }

}

