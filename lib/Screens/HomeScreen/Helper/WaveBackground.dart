import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaveBackgroundController
{
  ///The first color to pass to the gradient
  Color firstColor;
  ///The second color to pass to the gradient 
  Color secondColor;
  ///This will stop the change of color
  Function stopColorChange;
  ///This will resume the color change
  
  Future<bool> resumeColorChange() async
  {
    await _resumeColorChange();
    return true;
  }
  Function _resumeColorChange;
}
class WaveBackground extends StatefulWidget {
 
  final WaveBackgroundController controller;
  const WaveBackground({
    Key key,  @required this.controller
  }) : super(key: key);

  @override
  _WaveBackgroundState createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with SingleTickerProviderStateMixin {
      //the value in which the color change animation was stopped
      double stoppedValue;
  AnimationController animControl;
  Animatable<Color> colorTweenLevel1,
      colorTweenLevel2,
      colorTweenLevel3,
      colorTweenLevel4;
  Animatable<Color> colorTweenLevel11,
      colorTweenLevel22,
      colorTweenLevel33,
      colorTweenLevel44;

  
 

  @override
  void initState() {
    super.initState();
    stoppedValue = 0;
    setColors();
    animControl = AnimationController(
        vsync: this, duration: Duration(seconds: 60))..repeat();
    if(widget.controller!= null)
    {
        widget.controller.stopColorChange = stopColorAnim;
        widget.controller._resumeColorChange = resumeColorAnim;
    }
    animControl.addListener(() { 
      if(widget.controller != null)
      {
        
        widget.controller.firstColor = colorTweenLevel4.evaluate(AlwaysStoppedAnimation(animControl.value));
        widget.controller.secondColor = colorTweenLevel44.evaluate(AlwaysStoppedAnimation(animControl.value));
      }
    });
  }
  void stopColorAnim()
  {

    stoppedValue = animControl.value;
    print('stopping animation at value $stoppedValue');
    animControl.stop(canceled: false);
  }
  void resumeColorAnim() async
  {
    print('Resuming the color change at value $stoppedValue');
    animControl.forward(from: stoppedValue);
  }
  void setColors(){
    colorTweenLevel1 = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin:Color(0xff9686F9) ,end:Colors.red[50] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.red[50] ,end:Colors.blue[50] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.blue[50] ,end:Colors.cyan[50] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.cyan[50] ,end:Colors.orange[50] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.orange[50] ,end:Colors.orange[50] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.orange[50],end:Color(0xff9686F9)  ), weight: 1),
      ]
    );
    colorTweenLevel11 = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin:Color(0xffD184FD) ,end:Colors.red ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.red ,end: Colors.blue), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.blue ,end:Colors.blue ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.blue ,end:Colors.orange ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.orange,end:Colors.pink[50]), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.pink[50] ,end:Color(0xffD184FD)), weight: 1),
      ]
    );
    colorTweenLevel2 = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin:Colors.purple[100] ,end:Colors.red[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.red[100] ,end:Colors.blue[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.blue[100] ,end: Colors.cyan[100]), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.cyan[100] ,end:Colors.orange[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.orange[100] ,end:Colors.orange[200] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.orange[200] ,end:Colors.purple[100] ), weight: 1),
      ]
    );
    colorTweenLevel22 = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin:Colors.purple[200] ,end:Colors.red[200] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.red[200] ,end:Colors.blue[200] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.blue[200],end:Colors.blue[300] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.blue[300] ,end:Colors.orange[200] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.orange[200] ,end:Colors.pink[200] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.pink[200],end:Colors.purple[200] ), weight: 1),
      ]
    );
    colorTweenLevel3 = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin:Color(0xff5080F9) ,end:Colors.redAccent, ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.redAccent ,end:Colors.blueAccent ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.blueAccent,end:Colors.cyanAccent ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.cyanAccent,end:Colors.orangeAccent ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.orangeAccent,end:Colors.pink[100]), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.pink[100],end:Color(0xff5080F9) ), weight: 1),
      ]
    );
     colorTweenLevel33 = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin:Color(0xffD184FD) ,end:Colors.redAccent[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.redAccent[100],end:Colors.blue[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.blue[100],end:Colors.blue[200] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.blue[200],end:Colors.orange[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.orange[100] ,end:Colors.pink[200] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.pink[200] ,end:Color(0xffD184FD) ), weight: 1),
      ]
    );

    colorTweenLevel4 = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin:Color(0xff9680F9) ,end:Colors.red[400] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.red[400] ,end:Colors.blue[300] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.blue[300] ,end:Colors.cyan ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.cyan,end:Colors.orange ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.orange ,end:Colors.orange[200] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.orange[200] ,end:Color(0xff9680F9) ), weight:1),
      ]
    );
    colorTweenLevel44 = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin:Color(0xffD184FD) ,end:Colors.red[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin: Colors.red[100],end:Colors.blueAccent ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.blueAccent ,end:Colors.blueAccent[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.blueAccent[100] ,end:Colors.orange[100] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.orange[100] ,end:Colors.pink[300] ), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin:Colors.pink[300] ,end:Color(0xffD184FD) ), weight: 1),
      ]
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animControl, builder: (BuildContext context, Widget child) { 

        return  Container(
        child: WaveWidget(
          config: CustomConfig(
            gradients: [
              [colorTweenLevel1.evaluate(AlwaysStoppedAnimation(animControl.value)), colorTweenLevel11.evaluate(AlwaysStoppedAnimation(animControl.value))],
              [colorTweenLevel2.evaluate(AlwaysStoppedAnimation(animControl.value)), colorTweenLevel22.evaluate(AlwaysStoppedAnimation(animControl.value))],
              [colorTweenLevel3.evaluate(AlwaysStoppedAnimation(animControl.value)), colorTweenLevel33.evaluate(AlwaysStoppedAnimation(animControl.value))],
              [colorTweenLevel4.evaluate(AlwaysStoppedAnimation(animControl.value)), colorTweenLevel44.evaluate(AlwaysStoppedAnimation(animControl.value))],
            ],
            durations: [35000, 19440, 10800, 6000],
            heightPercentages: [0.008, 0.0012, 0.0035, 0.0050],
            blur: MaskFilter.blur(BlurStyle.solid, 19),
            gradientBegin: Alignment.bottomLeft,
            gradientEnd: Alignment.topRight,
          ),
          waveAmplitude: 12,
          backgroundColor: Colors.white,
          size: Size(
            double.infinity,
            double.infinity,
          ),
        ),
      );
       },
          
    );
  }
 
 

}
