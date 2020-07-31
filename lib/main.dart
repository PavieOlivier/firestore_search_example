import 'package:firestore_search_example/Screens/BootScreen/bootScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//   statusBarColor: Colors.transparent,
// ));

    return MaterialApp(
        title: 'Bima',
       // home: HomeScreen(),
        home: BootScreen()
        //home: AdminPanelScreen(),
        //home: JsonUploadScreen(),
        //home: HomeScreen());
    );
  }
}
