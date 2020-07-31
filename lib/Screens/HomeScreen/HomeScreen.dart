import 'dart:math';
import 'package:firestore_search_example/Fork/WidgetAnimator.dart';
import 'package:firestore_search_example/MainHelper/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'Helper/Body.dart';
import 'Helper/CustomGrid.dart';
import 'Helper/DeviceInfo.dart';
import 'Helper/StackHeader.dart';
import 'Helper/WaveBackground.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StackHeaderController stackHeaderController;
  WaveBackgroundController waveController;
  double inchSize;
  @override
  void initState() {
    waveController = WaveBackgroundController();
    inchSize = sqrt((SizeConfig.screenHeight * SizeConfig.screenHeight) +
        (SizeConfig.screenWidth * SizeConfig.screenWidth));
    print('The screen diag is $inchSize ');
    super.initState();

    stackHeaderController = StackHeaderController();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        WidgetAnimator(
            duration: Duration(milliseconds: 750),
            animateFromTop: false,
            child: WaveBackground(controller: waveController,)),
        StackHeader(
          controller: stackHeaderController,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: WidgetAnimator(
            duration: Duration(milliseconds: 850),
            child: ClipPath(
              clipper: ArcClipper(),
              child: Container(
                height: SizeConfig.safeBlockVertical * 7.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.purple[50], Colors.blueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
              ),
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.safeBlockVertical * 13.5,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //    color: Colors.pink,
              height: SizeConfig.safeBlockVertical * 89,

              child: Column(
                children: <Widget>[
                  Expanded(flex: 2, child: WidgetAnimator(child: DeviceInfo())),
                  Expanded(flex: 2, child: Body(waveBackgroundController: waveController,)),
                  Expanded(flex: 8, child: CustomGrid(
                    waveController: waveController,
                  ))
                ],
              ),
            ),
          ),
        ),
        
      ],
    );
  }
}
