import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';


class PartnerPage extends StatefulWidget {

  final String title;

  PartnerPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return PartnerPageState(this.title);
  }

}

class PartnerPageState extends State<PartnerPage>   {

  String title;
  int _currentPage = 0;
  DotsIndicator indicator;
  PageController pageController;

  PartnerPageState(this.title);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    pageController = PageController();
    indicator = DotsIndicator(controller:  pageController ,itemCount: 2,color:Constants.mainColor);
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
    return Container(
      child: _buildPartnerListView(buildContext),
    );
  }

  Widget _buildPartnerListView(BuildContext buildContext) {

    return PageView.builder(
      controller: pageController,
      itemCount: 2,
        itemBuilder: (context,index) {
          return SingleChildScrollView(child: _page(index));
        }
    );
  }

  Widget _page(int index) {
    switch(index) {
      case 0 :
        {
          return Container(
            child:Center(
              child: Column(
                children:[
                  Padding(padding: EdgeInsets.only(top:10),),
                  Image.asset(Constants.appImagesAssetsFolder + "GWC-logo.png",width: 250,height: 150,),
                  Image.asset(Constants.appImagesAssetsFolder + "PSGlogoNEW.jpg",width: 200,height: 200,),
                  Padding(padding:EdgeInsets.only(top:20)),
                  Image.asset(Constants.appImagesAssetsFolder + "iucn-logo.jpg",width: 150,height: 150,),
                  Image.asset(Constants.appImagesAssetsFolder + "LCN Logo.png",width: 150,height: 150,),
                  Padding(padding: EdgeInsets.only(bottom:10),),
                ]
              ),
            ),
          );
        }
      case 1 :
        {
          return Container(
            child:Center(
              child: Column(
                  children:[
                    Image.asset(Constants.appImagesAssetsFolder + "gerp-logo.jpg",width: 200,height: 200,),
                    Image.asset(Constants.appImagesAssetsFolder + "fanamby-logo.jpg",width: 150,height: 150,),
                    Padding(padding:EdgeInsets.only(top:20)),
                    Image.asset(Constants.appImagesAssetsFolder + "bristolzoo-logo.jpg",width: 150,height: 150,),
                  ]
              ),
            ),
          );
        }
    }

    setState(() {
      _currentPage = index;
    });

    return Container();
  }


}





