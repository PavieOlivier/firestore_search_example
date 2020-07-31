import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';

class AdminPannelMainButton extends StatelessWidget {
  final Function onTap;
  final String title;
  const AdminPannelMainButton({
    Key key,
    @required this.onTap,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.safeBlockHorizontal * 80,
      height: SizeConfig.safeBlockVertical * 9,
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
            elevation: 0,
            color: Colors.white.withOpacity(0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Center(
                child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal * 5),
            ))),
      ),
    );
  }
}
