import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search_example/Fork/WidgetAnimator.dart';
import 'package:firestore_search_example/Logic/fireStoreSearch.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/AdminPanelScreen/AdminPannelScreen.dart';
import 'package:firestore_search_example/Screens/DetailScreen/DetailsScreen.dart';
import 'package:firestore_search_example/Screens/HomeScreen/Helper/WaveBackground.dart';

import 'package:firestore_search_example/Screens/SearchScreen/SearchScreen.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firestore_search_example/SearchHelper/categoryResultWidget.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vibration/vibration.dart';

import 'SearchBar.dart';

class Body extends StatefulWidget {
  final WaveBackgroundController waveBackgroundController;
  const Body({
    Key key, @required this.waveBackgroundController,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String welcomeText = 'Welcome';
  SearchController firestoreSearchController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.safeBlockHorizontal * 4,
            right: SizeConfig.safeBlockHorizontal * 4,
            top: SizeConfig.safeBlockVertical),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WidgetAnimator(
              animateFromTop: true,
              child: GestureDetector(
                onLongPress: () async {
                  if (await Vibration.hasVibrator()) {
                    Vibration.vibrate();
                    setState(() {
                      welcomeText = 'Checking';
                    });
                  }
                  await DataConnectionChecker()
                      .hasConnection
                      .then((value) async {
                    if (value == false) {
                      EdgeAlert.show(context,
                          title: 'Can\'t Connect',
                          description: 'Need internet to access this area',
                          gravity: EdgeAlert.BOTTOM,
                          duration: 2,
                          backgroundColor: Colors.blue[300]);
                      setState(() {
                        welcomeText = 'Welcome';
                      });
                    } else {
                      setState(() {
                        welcomeText = 'Welcome';
                      });
                      await Future.delayed(Duration(milliseconds: 700));
                      Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 300),
                              child: AdminPanelScreen(),
                              type: PageTransitionType.fade));
                    }
                  });
                },
                child: Text(
                  welcomeText,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: SizeConfig.safeBlockHorizontal * 8.5,
                      wordSpacing: -6),
                ),
              ),
            ),
            Expanded(
              child: WidgetAnimator(
                animateFromTop: false,
                child: SearchBar(
                  onTap: () async {
                    SearchController scontrol = SearchController();
                    scontrol.searchPageBackgroundDecoration = BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.waveBackgroundController.firstColor, widget.waveBackgroundController.secondColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    );
                    scontrol.inputDecoration = InputDecoration(
                      
                      hintText: 'Search within categories',
                      hintStyle: TextStyle(
                          color: Colors.white60, fontWeight: FontWeight.bold),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    );
                    scontrol.cursorColor = Colors.white;
                    scontrol.textFieldTextStyle = TextStyle(
                      color: Colors.white
                    );
                    
                    scontrol.custonResultWidget = ResultWidget(waveBackgroundController: widget.waveBackgroundController,
                      inCollection: 'categories', searchController: scontrol);
                     // widget.waveBackgroundController.stopColorChange();
                    await FirestoreIndexingSearch.showSearch(context,
                        inCollection: 'categories',
                        indexedField: 'name',
                        searchController: scontrol);
                    //widget.waveBackgroundController.resumeColorChange();
                    // Navigator.push(
                    //   context,
                    //   PageTransition(
                    //       type: PageTransitionType.fade,
                    //       child: SearchScreen(
                    //         isWithinCategory: true,
                    //         indexedField: 'name',
                    //         inCollection: 'categories',
                    //       )),
                    // );
                  },
                  flavorText: 'What are you looking for?',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultWidget extends StatefulWidget {
  final String inCollection;
  //we will use it to get the permanant index
  final SearchController searchController;
  final WaveBackgroundController waveBackgroundController;
  const ResultWidget({Key key, @required this.inCollection, @required this.searchController,@required  this.waveBackgroundController}) : super(key: key);
  @override
  _ResultWidgetState createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  int internalIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    internalIndex = widget.searchController.internalIndex;
  }
  @override
  Widget build(BuildContext context) {
    if(widget.inCollection == 'categories')
    {
      return CategoryResultWidget(
        waveBackgroundController: widget.waveBackgroundController,
        widget: widget, internalIndex: internalIndex);
    }
    else
    {
      return Container(
        height: SizeConfig.safeBlockVertical*30,
          width: SizeConfig.safeBlockHorizontal*90,
          child: Text('hereX'),
      );
    }
  }
}

