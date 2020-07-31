
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/DetailScreen/DetailsScreen.dart';
import 'package:firestore_search_example/Screens/HomeScreen/Helper/Body.dart';
import 'package:firestore_search_example/Screens/HomeScreen/Helper/WaveBackground.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CategoryResultWidget extends StatelessWidget {
  const CategoryResultWidget({
    Key key,
    @required this.widget,
    @required this.internalIndex,
    @required this.waveBackgroundController,
  }) : super(key: key);

  final ResultWidget widget;
  final int internalIndex;
  final WaveBackgroundController waveBackgroundController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
         Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: DetailScreen(
                              
                              waveController: waveBackgroundController,
                              ofCategory: widget.searchController.searchResult[internalIndex]['name'],
                            )));
      },
            child: Card(
        shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        color: Colors.white10.withOpacity(0.15),
              child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15)),
          height: SizeConfig.safeBlockVertical*10,
          width: SizeConfig.safeBlockHorizontal*90,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:EdgeInsets.only(left:SizeConfig.safeBlockHorizontal*4,right: SizeConfig.safeBlockHorizontal*4),
              child: Row(
                
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    height: SizeConfig.safeBlockVertical*8,
                    width: SizeConfig.safeBlockHorizontal*15,
                  ),
                  SizedBox(width: SizeConfig.safeBlockHorizontal*3,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        transitionOnUserGestures: true,
                        tag: widget.searchController.searchResult[internalIndex]['name'],
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            
                            child: Text(
                              
                              widget.searchController.searchResult[internalIndex]['name'],
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
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                        
                            .collection(widget.searchController.searchResult[internalIndex]['name'].toLowerCase())
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
                      
                    ],
                  ),
                ],
              ),
                ],
              ),
            )),
        ),
      ),
    );
  }
}