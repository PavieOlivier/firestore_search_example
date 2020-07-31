import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDropDownMenu extends StatefulWidget {
  const AdminDropDownMenu({
    Key key,
    @required this.onItemSelected,
  }) : super(key: key);

  final Function(String) onItemSelected;

  @override
  _AdminDropDownMenuState createState() => _AdminDropDownMenuState();
}

class _AdminDropDownMenuState extends State<AdminDropDownMenu> {
  QuerySnapshot snapshots;
  String selected;
  List<DropdownMenuItem> dropDownMenuItemList;
  @override
  void initState() {
    super.initState();
    dropDownMenuItemList = [];
    getSnapshots();
  }

  void getSnapshots() async {
    snapshots =
        await Firestore.instance.collection('categories').getDocuments();
    snapshots.documents.forEach((documents) {
      dropDownMenuItemList.add(DropdownMenuItem(
        child: Text(
          documents['name'],
          style: TextStyle(color: Colors.white),
        ),
        value: documents['name'],
      ));
    });
    selected = snapshots.documents[0]['name'];
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: SizeConfig.safeBlockHorizontal * 95,
      //height: SizeConfig.safeBlockVertical * 15,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          color: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.safeBlockHorizontal * 4,
                right: SizeConfig.safeBlockHorizontal * 4,
                top: SizeConfig.verticalBloc * 0.5),
            child: Theme(
              data: ThemeData(canvasColor: Colors.lightBlueAccent),
              child: DropdownButtonFormField(
                elevation: 0,
                items: dropDownMenuItemList,
                iconEnabledColor: Colors.white,
                iconDisabledColor: Colors.red,
                value: selected,
                onChanged: (newValue) {
                  setState(() {
                    selected = newValue;
                    widget.onItemSelected(newValue);
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  labelText: 'Categories',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.safeBlockHorizontal * 5),
                ),
              ),
            ),
          )),
    );
  }
}
