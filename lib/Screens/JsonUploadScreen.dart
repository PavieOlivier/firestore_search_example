

import 'package:firestore_search_example/Logic/JsonServices.dart' as JsonService;
import 'package:flutter/material.dart';

class JsonUploadScreen extends StatefulWidget {
  @override
  _JsonUploadScreenState createState() => _JsonUploadScreenState();
}

class _JsonUploadScreenState extends State<JsonUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: IconButton(icon: Icon(Icons.ac_unit), onPressed: ()async{
            String ase;
            ase =await JsonService.decodeJson();
            print(ase);
          }),
        ),
      ),
    );
  }
}