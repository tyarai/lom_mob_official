import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';


class InstructionsPage extends StatefulWidget {

  final String title;

  InstructionsPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return InstructionsPageState(this.title);
  }

}

class InstructionsPageState extends State<InstructionsPage>   {

  String title;
  DotsIndicator indicator;
  PageController pageController;
  int _currentPageValue = 0;

  InstructionsPageState(this.title);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    indicator = DotsIndicator(controller:  pageController ,itemCount: 4,color:Constants.mainColor,dotIncreaseSize: 5,dotSize: 12,dotSpacing: 18,);
  }

  Widget _buildTitle() {
    String title  = this.title;
    return Text(title);

  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1.0,
          centerTitle: true,
          title: _buildTitle(),
        ),
        body: _buildBody(context),
      );
  }



  Widget _buildBody(BuildContext buildContext){
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children:[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _buildInstructionsListView(buildContext),
        ),
        Positioned(bottom:0,child: indicator),
      ],

    );
  }

  Widget _buildInstructionsListView(BuildContext buildContext) {

    return Container(

        child:PageView.builder(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context,index) {
            return SingleChildScrollView(child: _page(index));
          },
          onPageChanged: (int page) {
            getChangedPageAndMoveBar(page);
          },
        ),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    setState(() {
      _currentPageValue = page;
    });
  }

  Widget _page(int index,{double height = 500.0}) {
    switch(index) {
      case 0 :
        {
          return Container(
            child:Center(
              child:Image.asset(Constants.appInstructionsAssetsFolder + "1.jpg",height: height,),
            ),
          );
        }
      case 1 :
        {
          return Container(
            child:Center(
              child:Image.asset(Constants.appInstructionsAssetsFolder + "2.jpg",height: height,),
            ),
          );
        }
      case 2 :
        {
          return Container(
            child:Center(
              child:Image.asset(Constants.appInstructionsAssetsFolder + "3.jpg",height: height,),
            ),
          );
        }
      case 3 :
        {
          return Container(
            child:Center(
              child:Image.asset(Constants.appInstructionsAssetsFolder + "4.jpg",height: height,),
            ),
          );
        }
    }


    return Container();
  }


}





