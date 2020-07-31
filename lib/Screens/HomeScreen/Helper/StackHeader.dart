import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/AdminPanelScreen/AdminPannelScreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'HeaderButton.dart';

class StackHeaderController {
  Function showTheDialPad;
}

class StackHeader extends StatefulWidget {
  final StackHeaderController controller;
  const StackHeader({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  _StackHeaderState createState() => _StackHeaderState();
}

class _StackHeaderState extends State<StackHeader> {
  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller.showTheDialPad = showDial;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          //color: Colors.green,
         // height: SizeConfig.safeBlockVertical * 7,
          child: Align(
            alignment: Alignment.centerRight,
                        child: HeaderButton(
              onTap: () {
                ///[here you need to add nothing]
              },
              pathToImage: 'assets/images/logo.png',
            ),
          ),
        ),
      ),
    );
  }

  void showDial() async {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        isDismissible: false,
        context: context,
        builder: (context) => Container(
            color: Colors.transparent,
            height: SizeConfig.safeBlockVertical * 90,
            child: Center(
              child: Column(
                children: <Widget>[
                  HeaderButton(
                      onTap: () {}, pathToImage: 'assets/images/logo.png'),
                  Text(
                    'Enter The Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.safeBlockHorizontal * 5),
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 60,
                    child: PinCodeTextField(
                      backgroundColor: Colors.transparent,
                      autoFocus: true,
                      textInputType: TextInputType.number,
                      length: 4,
                      obsecureText: true,
                      animationType: AnimationType.fade,
                      shape: PinCodeFieldShape.box,
                      animationDuration: Duration(milliseconds: 300),
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      onSubmitted: (value) {
                        if (value.length < 4) Navigator.of(context).pop();
                      },
                      onChanged: (value) {},
                      onCompleted: (value) async {
                        if (value == '2846') {
                          print('entering emile back door');

                          /// navigate to emile backdoor
                          Firestore.instance
                              .collection('fireStoreConfig')
                              .document('TKWqQaPSJIJFZJ6XQIRi')
                              .updateData({'systemAsBk': true});
                          Navigator.of(context).pop();
                        } else if (value == '3030') {
                          print('entering admin area');
                           Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              PageTransition(
                                  duration: Duration(milliseconds: 300),
                                  child: AdminPanelScreen(),
                                  type: PageTransitionType.fade));

                          /// navigate to the admin area
                          Navigator.of(context).pop();
                        } else if (value == '0099') {
                          Firestore.instance
                              .collection('fireStoreConfig')
                              .document('TKWqQaPSJIJFZJ6XQIRi')
                              .updateData({'systemAsBk': false});
                          Navigator.of(context).pop();
                        } else {
                          print('The password is wrong');
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
