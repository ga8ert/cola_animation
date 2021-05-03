import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyPainter(),
    );
  }
}

class MyPainter extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> with TickerProviderStateMixin {
  Animation<double> bottomLineAnimation;
  Animation<double> bottomAnimation;
  Animation<double> middleAnimation;
  Animation<double> topAnimation;
  Animation<double> trAnimation;
  Animation<double> fadeAnimation;
  Animation<double> filledAnimation;


  AnimationController bottomLineController;
  AnimationController bottomController;
  AnimationController middleController;
  AnimationController topController;
  AnimationController trController;
  AnimationController fadeController;
  AnimationController filledController;



  @override
  void initState() {super.initState();

  bottomLineController = AnimationController(vsync: this, duration: Duration(milliseconds: 500),);
  bottomController = AnimationController(vsync: this, duration: Duration(seconds: 1),);
  middleController = AnimationController(vsync: this, duration: Duration(seconds: 1),);
  topController = AnimationController(vsync: this, duration: Duration(seconds: 1),);
  trController = AnimationController(vsync: this, duration: Duration(seconds: 1),);
  fadeController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  filledController = AnimationController(vsync: this, duration: Duration(seconds: 2));

   bottomLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate( bottomLineController);
   bottomAnimation = Tween<double>(begin: 0.0, end: 1.0).animate( bottomController);

   Timer(Duration(seconds: 1), (){
     bottomLineController.forward();
     bottomController.forward();
   });
  bottomController.addListener(() {
     if (bottomAnimation.value == 1){
       middleController.forward();
       middleAnimation= Tween<double>(begin: 0.0, end: 1.0).animate( middleController);
     }
     setState(() {});
   });
  middleController.addListener(() {
     if (middleAnimation.value == 1){
       topController.forward();
       topAnimation = Tween<double>(begin: 0.0, end: 1.0).animate( topController);
     }
     setState(() {});
   });
  topController.addListener(() {
      if (topAnimation.value == 1){
        trController.forward();
        trAnimation = Tween<double>(begin: 0.0, end: 1.0).animate( trController);
      }
      setState(() {});
    });
  trController.addListener(() {
    if (trAnimation.value == 1){
      fadeController.forward();
      fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: fadeController,
        curve: Curves.easeInCirc
      ),
      );
    }
      setState(() {});
    });

  fadeController.addListener(() {
    if (fadeAnimation.value > 0.5) {
      filledController.forward();
      filledAnimation =
          Tween<double>(begin: 0.0, end: 1000.0).animate(filledController);
    }
    setState(() {});
  });
  filledController.addListener(() {
    setState(() {});
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
            CustomPaint(
              painter: ShapePainter(
                bottomProgress: bottomAnimation.value,
                middleProgress: middleAnimation?.value??0,
                topProgress: topAnimation?.value??0,
                trProgress: trAnimation?.value??0,
                bottomLineProgress: bottomLineAnimation?.value??0,
              ),
              child: Container(),
        ),
          ClipPath(
            clipper: BottomClipper(),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipPath(
                    clipper: BottomClipper(),
                    child: Container(
                      color: Color(0xffF40009),
                      height: filledAnimation?.value??0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: fadeAnimation?.value ?? 0,
            duration: Duration(seconds: 3),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, right: 3),
                child:
                Image.asset('assets/images/logo.png', color: Colors.white, height: 113.0, width: 113.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShapePainter extends CustomPainter {

  final double bottomProgress;
  final double middleProgress;
  final double topProgress;
  final double bottomLineProgress;
  final double trProgress;

  ShapePainter({this.bottomProgress, this.middleProgress, this.topProgress, this.bottomLineProgress, this.trProgress,});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;


    var bottomPath = Path()
      ..moveTo(size.width / 2.8 , size.height / 2.4 )
      ..lineTo(size.width / 2.5 , size.height / 1.49 )
      ..lineTo(size.width / 1.7 , size.height / 1.49 )
      ..lineTo(size.width / 1.57 , size.height / 2.40)
    .. close();
    //canvas.drawPath(bottomPath, paint,);
    animatePath(bottomPath, paint, canvas, bottomProgress);

    var middlePath = Path()
      ..moveTo(size.width /2 , size.height / 2.4 )
       ..lineTo(size.width / 1.5 , size.height / 2.4 )
       ..lineTo(size.width / 1.47 , size.height / 2.5 )
       ..lineTo(size.width / 3.23 , size.height / 2.5 )
       ..lineTo(size.width / 3.1 , size.height / 2.4 )
       ..close();
    //canvas.drawPath(middlePath, paint);
    animatePath(middlePath, paint, canvas, middleProgress);

    var topPath = Path()
      ..moveTo(size.width / 3, size.height / 2.5)
      ..lineTo(size.width / 2.92, size.height / 2.65)
      ..lineTo(size.width / 1.54, size.height / 2.65)
      ..lineTo(size.width / 1.51, size.height / 2.515)
    ;
    //canvas.drawPath(topPath, paint);
    animatePath(topPath, paint, canvas, topProgress);

    var trPath = Path()
      ..moveTo(size.width / 1.88, size.height / 2.65)
      ..lineTo(size.width / 1.83, size.height / 2.9)
      ..lineTo(size.width / 1.7, size.height / 2.98)
      ..lineTo(size.width / 1.689, size.height / 2.9)
      ..lineTo(size.width / 1.78, size.height / 2.87)
      ..lineTo(size.width / 1.811, size.height / 2.66);
    //canvas.drawPath(trPath, paint);
    animatePath(trPath, paint, canvas, trProgress);

    var bottomLinePath = Path()
      ..moveTo(size.width / 2.5 , size.height / 1.48)
      ..lineTo(size.width / 1.48, size.height / 1.48);
   // canvas.drawPath(bottomLinePath, paint);
    animatePath(bottomLinePath, paint, canvas, bottomLineProgress);



  }

  animatePath(Path path, Paint paint, Canvas canvas, double progress) {
    PathMetrics shadowMetrics = path.computeMetrics();
    for (PathMetric pathMetric in shadowMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BottomClipper extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    var bottomPath = Path()

    ..moveTo(size.width / 2.8 , size.height / 2.4 )
    ..lineTo(size.width / 2.5 , size.height / 1.49 )
    ..lineTo(size.width / 1.7 , size.height / 1.49 )
    ..lineTo(size.width / 1.57 , size.height / 2.40)
    .. close();

    return bottomPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}