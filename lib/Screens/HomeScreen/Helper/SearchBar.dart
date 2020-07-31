


import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function onTap;
  final String flavorText;
  const SearchBar({Key key, @required this.onTap, @required this.flavorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              //color: Colors.yellow,
              border: Border(bottom: BorderSide(color: Colors.white))),
          width: SizeConfig.safeBlockHorizontal * 70,
          height: SizeConfig.safeBlockVertical * 8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical),
                child: Text(flavorText,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        wordSpacing: -4)),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical),
                child: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
