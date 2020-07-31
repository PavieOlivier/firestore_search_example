import 'package:firestore_search_example/Logic/JsonServices.dart';
import 'package:firestore_search_example/Logic/fireStoreSearch.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:firestore_search_example/Screens/HomeScreen/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BootScreen extends StatefulWidget {
  @override
  _BootScreenState createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  String textToDisplay = 'Starting Services';
  Color textToDisplayColor = Colors.black45;
  bool isLogged = true;
  @override
  void initState() {
    
    super.initState();
    initAuth();
  }

  void lauchAwaitingServices({String withText}) async {
    setState(() {
      textToDisplay = withText;
          
      textToDisplayColor = Colors.red;
    });

    DataConnectionChecker().onStatusChange.listen((newStatus) {
      if (newStatus == DataConnectionStatus.connected) {
        setState(() {
          textToDisplay = 'Connected to the internet\nPlease wait';
          initAuth();
        });
      }
    });
  }

  ///This will authenticate the user using fire base
  void initAuth() async {
    await Firestore.instance.settings(persistenceEnabled: true);

    await FirebaseAuth.instance.currentUser().then((user) async {
      if (user == null) {
        print('User is not logged in; attempt to log');
        setState(() {
          isLogged = false;
        });
        await Connectivity().checkConnectivity().then((connectionValue) async {
          if (connectionValue == ConnectivityResult.mobile ||
              connectionValue == ConnectivityResult.wifi) {
            await DataConnectionChecker()
                .hasConnection
                .then((isConnected) async {
              if (isConnected == true) {
                setState(() {
                  textToDisplay = 'Connecting to the Database\nPlease wait';
                  textToDisplayColor = Colors.black45;
                });
                await FirebaseAuth.instance.signInAnonymously().then((value) {
                  print('anonyme user logged in');
                  
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 500),
                          child: HomeScreen(),
                          type: PageTransitionType.fade),
                      (route) => false);
                }).catchError((onError) {
                  print(onError);
                });
              } else {
                lauchAwaitingServices(
                  withText: 'No internet connection on your network\nawaiting for the network to be availaible'
                );
              }
            });
          } else if (connectionValue == ConnectivityResult.none) {
            lauchAwaitingServices(
              withText: 'No Network connection\nPlease enable your Wi-Fi or your mobile data'
            );
            return;
          }
        });
      } else {
        print('user already logged');
        print(user.isAnonymous);
       // await decodeJson();

        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                duration: Duration(milliseconds: 1500),
                child: HomeScreen(),
                type: PageTransitionType.fade),
            (route) => false);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return isLogged
        ? Container(
            color: Colors.white,
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                  width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.safeBlockHorizontal*90,
                      height: SizeConfig.safeBlockVertical*25,
                      color: Colors.white,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    
                    Text(
                      textToDisplay,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 6,
                          color: textToDisplayColor,
                          fontWeight: FontWeight.w400),
                    ),
                    Image.asset('assets/images/loading.gif'),
                  ],
                ),
              ),
            ),
          );
  }
}
