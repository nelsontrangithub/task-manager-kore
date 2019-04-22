import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  // LoadingIndicator({Key key}),
  //       super(key: key);

  @override
  _SplashIndicatorState createState() => _SplashIndicatorState();
}

class _SplashIndicatorState extends State<Splash>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = AnimatedBuilder(
      animation: controller,
      child: SizedBox(
        height: 155.0,
        child: Image.asset(
          "assets/KORE-Logo.png",
          fit: BoxFit.contain,
        ),
      ),
      builder: (BuildContext context, Widget _widget) {
          return new Transform.rotate(
            angle: controller.value * 6.3,
            child: _widget,
          );
      },
    );

    return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: logo,
        );
  }
}
