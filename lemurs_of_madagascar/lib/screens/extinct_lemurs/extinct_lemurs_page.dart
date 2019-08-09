import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';




class ExtinctLemursPage extends StatefulWidget {

  final String title;


  ExtinctLemursPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return ExtinctLemursPageState(title: title);
  }
}

class ExtinctLemursPageState extends State<ExtinctLemursPage> {

  final String title;
  final String p1 = "Madagascar is one of the highest priority countries on Earth for biodiversity, and is clearly the single highest major primate conservation priority.  Although less than 2% the size of the three continental regions in which primates occur (mainland Africa, Asia and the Neotropics), Madagascar given its comparable levels of diversity  at family, genus, and species, it is considered the fourth major primate region on Earth.  What is more,  it ranks second only to Brazil is terms of diversity at the country level.  In terms of endemism,  it is unsurpassed, with fully five families, 15 genera and 112 taxa to date – all of them found nowhere else.  Sadly, Madagascar is also among the world’s most heavily impacted countries in terms of habitat destruction and degradation, and we estimate that less than 10% of the original natural vegetation remains, making conservation at all levels a very high global priority.";
  final String p2 = "Not only were these remains clearly those of lemurs much larger than any which survive today, they were equally clearly of no great antiquity (hence the “subfossil” appellation). In a review published as early as 1905, the paleontologist Guillaume Grandidier, was able to show that many more names than necessary had been bestowed upon the large collection of subfossil lemur bones that had been amassed by that time. However, among those names were most of the extinct genera recognized today. Despite extensive excavations during the first half of the century, notably by Charles Lamberton (1934a, 1934b, 1936a, 1936b, 1938) of the Académie Malgache, no new extinct lemur genera were recovered between the first decade of the century and the late 1980s. In 1986, a team led by Elwyn Simons of Duke University began work in karst caves on the Ankarana Massif in the far north of Madagascar.";
  final String p3 = "Besides discovering at least one new genus of extinct lemur (Babakotia), this team has made finds that have caused considerable rethinking of the adaptations of the extinct lemurs and the relationships among them. The team also made finds indicating that species that still survive today, among them Prolemur simus and Indri indri, once had much more extensive ranges. Until the mid-20th century, subfossil lemurs were known almost exclusively from the center, south and southwest of Madagascar. Now, however, the only major biogeographic region of Madagascar where subrecent fauna remains unsampled is the eastern rain forest. Perhaps even more importantly, the recent era of fieldwork has allowed the collection of complete or relatively complete skeletons in which skulls and the various elements of the body skeleton are positively associated. This contrasts with earlier excavations in which bones tended to be dredged up one by one from swamps and muddy marsh bottoms. Given such circumstances of excavation, the association of postcranial bones with skulls and with each other tended to be a matter of guesswork and size-matching. As it turned out, this was not the most accurate procedure. Most of currently known subfossil sites consist either of marsh deposits (dried to varying extents) or of deposits washed into limestone caves or fissures. Most such sites are rich in the bones of many other vertebrates besides primates (living as well as extinct). Common among such remains are those of pygmy hippopotami, giant tortoises and the famous elephant birds (Aepyornis and Mullerornis). Of particular interest is the Ankilitelo pit cave in the karst landscape of the Mikoboka Plateau in southwestern Madagascar. It has a uniquely rich subfossil mammal fauna (34 species in all), which is very recent (around 500 years old), making it one of the most diverse Holocene assemblages in Madagascar (Simons et al., 2004; Muldoon et al., 2009a, 2009b).";
  final String p4 = "It is an extraordinarily rich repository for five species of extinct giant lemurs: \n - Palaeopropithecus ingens\n - Megaladapis madagascariensis \n - Archaeolemur majori \n - Daubentonia robusta \n - Pachylemur \n(Wunderlich et al., 1996; Jungers et al., 1997, 2005; Godfrey et al., 1999; Hamrick et al., 2000; Simons et al., 2004; Shapiro et al., 2005).";
  final String p5 = "All of the subfossil sites are strictly localized, and all are of comparatively recent age. Most radiocarbon dates that have been obtained so far cluster in the period between about 2,500 and 1,000 years ago, and only one or two stretch back to the final millennia of the last Ice Age, which ended around 10,000 years ago. These are not very ancient ages by any standard, and they show that subfossil and living lemurs all form part of the same contemporary fauna; the extinct lemurs are in no way the precursors of those that still survive.";

  ExtinctLemursPageState({this.title});

  _buildTitle(){
    return Container(child:Text(this.title));
  }


  Widget _buildPage() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: SingleChildScrollView(
                    child: Column(
                      children:[
                        Image.asset("assets/images/subfossillemurspicNEWg1blank.jpg",fit: BoxFit.fitHeight,),
                        Padding(padding: EdgeInsets.only(top:10),),
                        Text(p1,style: Constants.defaultTextStyle,textAlign: TextAlign.justify,),
                        Image.asset("assets/images/subfossillemurspicNEWg2blank.jpg",fit: BoxFit.fitHeight,),
                        Padding(padding: EdgeInsets.only(top:10),),
                        Text(p2,style: Constants.defaultTextStyle,textAlign: TextAlign.justify,),
                        Image.asset("assets/images/BabakotiaReconstr.jpg",fit: BoxFit.fitHeight,),
                        Padding(padding: EdgeInsets.only(top:10),),
                        Text(p3,style: Constants.defaultTextStyle,textAlign: TextAlign.justify,),
                        Padding(padding: EdgeInsets.only(top:10),),
                        Text(p4,style: Constants.defaultTextStyle,textAlign: TextAlign.justify,),
                        Padding(padding: EdgeInsets.only(top:10),),
                        Text(p5,style: Constants.defaultTextStyle,textAlign: TextAlign.justify,),
                        Padding(padding: EdgeInsets.only(top:10),),
                        Image.asset("assets/images/MapMasterTemplate6FossilLocalities3.jpg",fit: BoxFit.fitHeight,),
                      ]
                    ),
                )
            ),
            Padding(padding: EdgeInsets.only(top: 10),),
          ],
        ),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {

    Widget futureWidget = Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: _buildTitle(),
      ),
      //backgroundColor: Constants.mainColor,
      body: SafeArea(child: _buildBody(context)),

    );

    return futureWidget;
  }

  _buildBody(BuildContext context){

    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      child: _buildPage(),
    );
  }

}
