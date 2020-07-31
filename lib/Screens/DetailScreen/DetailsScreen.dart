import 'dart:async';

import 'package:firestore_search_example/Fork/WidgetAnimator.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/DetailScreen/Helper/europeanCities.dart';
import 'package:firestore_search_example/Screens/HomeScreen/Helper/WaveBackground.dart';

import 'package:firestore_search_example/Screens/SearchScreen/SearchScreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'Helper/animeCardElement.dart';
import 'Helper/bookCardElement.dart';

class DetailScreen extends StatefulWidget {
  final String ofCategory;

  ///This is the controller that contains the value of the background
  final WaveBackgroundController waveController;
  const DetailScreen(
      {Key key, @required this.ofCategory, @required this.waveController})
      : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  //we implemented an asynch method here to load the data fro firebase
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void changeColor() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        print('changing colors');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: <Widget>[
        Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              widget.waveController.firstColor ?? Colors.orange,
              widget.waveController.secondColor ?? Colors.orange[100]
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
        ),
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AppBar(
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: SearchScreen(
                                isWithinCategory: false,
                                indexedField: 'none',
                                inCollection: widget.ofCategory,
                              )),
                        );
                      })
                ],
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Hero(
                  transitionOnUserGestures: true,
                  tag: widget.ofCategory,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.ofCategory,
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.safeBlockHorizontal * 5),
                    ),
                  ),
                ),
              ),
              Container(
                //color: Colors.pink,
                height: SizeConfig.verticalBloc * 89.5,
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(widget.ofCategory)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    if (snapshot.data == null) return SizedBox();
                    if (snapshot.data.documents.isEmpty)
                      return Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.safeBlockVertical * 15),
                        child: Container(
                          width: SizeConfig.safeBlockHorizontal * 95,
                          height: SizeConfig.safeBlockVertical * 12,
                          child: Text(
                            'This category has no data or there is an issue in the Database',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.safeBlockHorizontal * 7),
                          ),
                        ),
                      );
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 15),
                          child: Text(
                            'Waiting...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.safeBlockHorizontal * 7),
                          ),
                        );
                      case ConnectionState.none:
                        return Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 15),
                          child: Text(
                            'Could not connect',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: SizeConfig.safeBlockHorizontal * 7),
                          ),
                        );

                      default:
                        return new ListView(
                          physics: BouncingScrollPhysics(),
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            if (widget.ofCategory == 'anime') {
                              return WidgetAnimator(
                                animateFromTop: false,
                                duration: Duration(milliseconds: 500),
                                child: AnimeCardElement(
                                  name: document['name'],
                                  category: document['category'],
                                  episodes: document['episodes'].toString(),
                                  imageUrl: document['imageUrl'],
                                  rating: document['rating'],
                                  studio: document['animation studio'],
                                  description: document['description'],
                                ),
                              );
                            } else if (widget.ofCategory == 'book') {
                              return BookCardElement(
                                name: document['name'],
                                category: document['category'],
                                imageUrl: document['imageUrl'],
                                pageCount: document['page count'].toString(),
                                description: document['description'],
                                authors: document['authors'],
                              );
                            } else if (widget.ofCategory == 'european cities') {
                              return EuropeanCardElement(
                                  imageUrl: document['imageUrl'],
                                  description: document['description'],
                                  cityName: document['city name'],
                                  countryName: document['country name']);
                            } else {}
                          }).toList(),
                        );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
