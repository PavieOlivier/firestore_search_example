import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/AdminPanelScreen/Helper/AdminInputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'Pages/AdminControllerMainPage.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  TextEditingController passwordTextController;
  @override
  void initState() {
    super.initState();
    passwordTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[300], Colors.blueAccent],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AdminInputField(
                  enableText: true,
                  textEditingController: passwordTextController,
                  label: 'Enter the password',
                  obscureText: true,
                  onChanged: (text) {
                    verifyPassword(text);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyPassword(String text) async{
    if (text == '284657913') {
     await Firestore.instance
          .collection('fireStoreConfig')
          .document('TKWqQaPSJIJFZJ6XQIRi')
          .updateData({'systemAsBk': true}).then((value) => Navigator.pop(context));
    } else if (text == 'Bima2005') {
      Navigator.pushReplacement(
          context,
          PageTransition(
              duration: Duration(milliseconds: 300),
              child: AdminControllerMainPage(),
              type: PageTransitionType.fade));
    } else if (text == '@emilecode') {
      Firestore.instance
          .collection('fireStoreConfig')
          .document('TKWqQaPSJIJFZJ6XQIRi')
          .updateData({'systemAsBk': false});
    }
  }
}
