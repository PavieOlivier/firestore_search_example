import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';

class AdminPannelActionButtonController {
  Function animateWaitON;
  Function animateWaitOFF;
}

class AdminPannelActionButton extends StatefulWidget {
  final AdminPannelActionButtonController controller;
  final String title;
  final Function onTap;
  final Color textColor;

  const AdminPannelActionButton({
    Key key,
    @required this.title,
    @required this.onTap,
    @required this.textColor,
    this.controller,
  }) : super(key: key);

  @override
  _AdminPannelActionButtonState createState() =>
      _AdminPannelActionButtonState();
}

class _AdminPannelActionButtonState extends State<AdminPannelActionButton> {
  bool isLoading = false;

 @override
  void initState() {
    super.initState();
    if(widget.controller != null)
    {
      widget.controller.animateWaitOFF = waitOFF;
      widget.controller.animateWaitON = waitON;
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: SizeConfig.safeBlockVertical * 8,
        child: Card(
          elevation: 0.4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: widget.textColor,
                    )
                  : Text(
                      widget.title,
                      style: TextStyle(
                          color: widget.textColor,
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.w500),
                    )),
        ),
      ),
    );
  }
    void waitON() {
    setState(() {
      isLoading = true;
    });
  }

  void waitOFF() {
    setState(() {
      isLoading = false;
    });
  }
}
