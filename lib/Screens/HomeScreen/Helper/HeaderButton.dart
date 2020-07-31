
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';

///This is the circular button on top of the page 
class HeaderButton extends StatelessWidget {
  final Function onTap;
  final String pathToImage;
  const HeaderButton({
    Key key,
    @required this.onTap,
    @required this.pathToImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
    padding:  EdgeInsets.all(SizeConfig.safeBlockHorizontal*1.2),
    child: ClipOval(
      child: Container(
        color: Colors.transparent,
        height: SizeConfig.safeBlockVertical * 6.5,
        width: SizeConfig.safeBlockHorizontal * 12,
        child: Image.asset(pathToImage, fit: BoxFit.cover,),
      ),
    ),
        ),
      );
  }
}
