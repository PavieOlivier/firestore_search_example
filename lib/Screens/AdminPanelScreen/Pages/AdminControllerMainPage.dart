

import 'package:firestore_search_example/Fork/WidgetAnimator.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/AdminPanelScreen/Helper/AdminPannelMainButton.dart';
import 'package:firestore_search_example/Screens/AdminPanelScreen/Pages/AdminControllerAddingPage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AdminControllerMainPage extends StatelessWidget {
  const AdminControllerMainPage({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Material(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.blue[300], Colors.blueAccent],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        )),
        child: SingleChildScrollView(
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                WidgetAnimator(
                  animateFromTop: true,
                                child: Container(
                    color: Colors.transparent,
                    width: SizeConfig.safeBlockHorizontal * 80,
                    height: SizeConfig.safeBlockVertical * 10,
                    child: Center(
                      child: Text(
                        'Welcome to the admin pannel\n what would you like to do',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.safeBlockHorizontal * 5.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                WidgetAnimator(
                  animateFromTop: true,
                                child: AdminPannelMainButton(
                    title: 'Create a Category',
                    onTap: () {
                     Navigator.pushReplacement(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 300),
                      child: AdminControllerAddingPage( 
                        mainTitle:'Please fill up the form to create a category in your database' ,
                        subTitle: '\n( You must add an item along with the category, leave irrelevant field empty )',
                        isCreatingCat: true),
                      type: PageTransitionType.fade));
                  
                    },
                  ),
                ),
                WidgetAnimator(
                  animateFromTop: false,
                                child: AdminPannelMainButton(
                    title: 'Add an Element',
                    onTap: () {
                       Navigator.pushReplacement(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 300),
                      child: AdminControllerAddingPage( 
                        mainTitle: 'Please fill up the form to add an item to your database',
                        subTitle: '\n( If a field is irrelevant please leave it empty )',
                        isCreatingCat: false),
                      type: PageTransitionType.fade));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

