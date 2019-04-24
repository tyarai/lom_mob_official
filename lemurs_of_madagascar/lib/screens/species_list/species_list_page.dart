import 'package:flutter/material.dart';


class SpeciesListPage extends StatefulWidget {


  SpeciesListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return SpeciesListPageState();
  }

}

class  SpeciesListPageState extends State<SpeciesListPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text("SPECIES LIST"),
      ),
    );
  }

}