import 'package:firestore_search_example/Fork/WidgetAnimator.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/DetailScreen/DetailsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search_example/Screens/HomeScreen/Helper/WaveBackground.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CustomGrid extends StatelessWidget {
  ///The controller contains informations about the background
  final WaveBackgroundController waveController;
  const CustomGrid({
    @required this.waveController,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new CategoryListStreamer(waveBackgroundController: waveController,);
  }
}

class CategoryListStreamer extends StatelessWidget {
  final WaveBackgroundController waveBackgroundController;

  const CategoryListStreamer({Key key, @required this.waveBackgroundController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        if (snapshot.data == null) return SizedBox();
        if (snapshot.data.documents.isEmpty)
          return Padding(
            padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 15),
            child: Container(
              width: SizeConfig.safeBlockHorizontal * 95,
              height: SizeConfig.safeBlockVertical * 12,
              child: Text(
                'This category has no data are you connected to internet',
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
              padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 15),
              child: Text(
                'Waiting...',
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
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return CategoryGridObject(
                    isFromSearch: false,
                    //I had to put to lower case here because the collections are originally in lower case
                    categoryName: document['name'].toLowerCase(),
                    onTap: () async {
                      waveBackgroundController.stopColorChange();
                      await Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: DetailScreen(
                                waveController:waveBackgroundController ,
                                //TODO: add background color here
                                ofCategory: document['name'].toLowerCase(),
                              )));
                      waveBackgroundController.resumeColorChange();
                    },

                    );
              }).toList(),
            );
        }
      },
    );
  }
}

class CategoryGridObject extends StatefulWidget {

  final String categoryName;
  final Function onTap;
  final bool isFromSearch;
  const CategoryGridObject(
      {Key key,
      @required this.onTap,
      @required this.categoryName,
      @required this.isFromSearch})
      : super(key: key);

  @override
  _CategoryGridObjectState createState() => _CategoryGridObjectState();
}

class _CategoryGridObjectState extends State<CategoryGridObject> {
  @override
  Widget build(BuildContext context) {
    return widget.isFromSearch
        ? CategoryListObjectDelegate(widget: widget)
        : WidgetAnimator(
            duration: Duration(milliseconds: 700),
            animateFromTop: false,
            child: CategoryListObjectDelegate(widget: widget),
          );
  }
}

class CategoryListObjectDelegate extends StatelessWidget {
  const CategoryListObjectDelegate({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final CategoryGridObject widget;

  @override
  Widget build(BuildContext context) {
   
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          width: SizeConfig.safeBlockHorizontal * 40,
          //height: scaler.getHeight(9),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15)),
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white10.withOpacity(0.15),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 4),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        transitionOnUserGestures: true,
                        tag: widget.categoryName,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            
                            child: Text(
                              
                              widget.categoryName,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.safeBlockHorizontal*5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.safeBlockHorizontal * 2),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection(widget.categoryName)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError)
                              return new Text(
                                'Error loading the data',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 3),
                              );
                            if (snapshot.data == null)
                              return Text(
                                'Awaiting for data',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        SizeConfig.safeBlockHorizontal * 3),
                              );
                            return Text(
                              'There are ${snapshot.data.documents.length} elements here',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 3),
                            );
                          },
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: SizeConfig.safeBlockHorizontal * 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
