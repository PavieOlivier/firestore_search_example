import 'package:firestore_search_example/Fork/WidgetAnimator.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';

class AdminInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final bool obscureText;
  final bool enableText;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  const AdminInputField(
      {Key key,
      @required this.textEditingController,
      @required this.label,
      @required this.enableText,
      this.keyboardType,
      this.onChanged,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetAnimator(
      child: Container(
        color: Colors.transparent,
        width: SizeConfig.safeBlockHorizontal * 95,
        //height: SizeConfig.safeBlockVertical * 12,
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
              child: TextField(
                keyboardType: keyboardType,
                enabled: enableText,
                obscureText: obscureText,
                onEditingComplete: () {
                  print('editing complete');
                },
                onSubmitted: (text) {
                  print('text submitted');
                },
                onChanged: (text) {
                  onChanged(text);
                },
                controller: textEditingController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: label,
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.safeBlockHorizontal * 5),
                ),
              ),
            )),
      ),
    );
  }
}
