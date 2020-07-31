
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';

import 'package:flutter/material.dart';

class SearchHeader extends StatefulWidget {
  final Function(String,String) onHeaderChanged;
  const SearchHeader({
    Key key,
    @required this.onHeaderChanged,
  }) : super(key: key);

  @override
  _SearchHeaderState createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  bool isNameSelected, isPartNumberSelected, isGadiSelected;

  @override
  void initState() {
    super.initState();
    isNameSelected = true;
    isGadiSelected = false;
    isPartNumberSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 90,
      height: SizeConfig.safeBlockVertical * 8,
      color: Colors.transparent,
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: GestureDetector(
                   onTap: (){
                    isGadiSelected = false;
                    isNameSelected = true;
                    isPartNumberSelected = false;
                    widget.onHeaderChanged('name','NameSearchKey');
                    setState(() {
                      
                    });
                  },
                  child: Container(
                    
                      height: double.infinity,
                      child: Center(
                          child: Text(
                        'Name',
                        style: TextStyle(
                            color: isNameSelected? Colors.lightBlue:Colors.black38,
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            fontWeight: FontWeight.bold),
                      ))),
                )),
            VerticalDivider(),
            Expanded(
                flex: 3,
                child: GestureDetector(
                   onTap: (){
                    isGadiSelected = false;
                    isNameSelected = false;
                    isPartNumberSelected = true;
                    widget.onHeaderChanged('part number','PartNumberSearchKey');
                    setState(() {
                      
                    });
                  },
                  child: Container(
                      height: double.infinity,
                      child: Center(
                          child: Text(
                        'Part No',
                        style: TextStyle(
                            color: isPartNumberSelected? Colors.lightBlue:Colors.black38,
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            fontWeight: FontWeight.bold),
                      ))),
                )),
            VerticalDivider(),
            Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: (){
                    isGadiSelected = true;
                    isNameSelected = false;
                    isPartNumberSelected = false;
                    widget.onHeaderChanged('gadi','GadiSearchKey');
                    setState(() {
                      
                    });
                  },
                  child: Container(
                      height: double.infinity,
                      child: Center(
                          child: Text(
                        'Gadi',
                        style: TextStyle(
                            color: isGadiSelected? Colors.lightBlue:Colors.black38,
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            fontWeight: FontWeight.bold),
                      ))),
                )),
          ],
        ),
      ),
    );
  }
}
