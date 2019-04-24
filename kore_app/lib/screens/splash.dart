import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  // LoadingIndicator({Key key}),
  //       super(key: key);

  @override
  _SplashIndicatorState createState() => _SplashIndicatorState();
}

const TextStyle textStyle = TextStyle(
  color: Color(0xff1282c5),
  fontFamily: 'Poppins',
);

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

    final companyName = Text(
      'KORE',
      style: textStyle.copyWith(fontSize: 48),
    );

    return new Material(
        type: MaterialType.transparency,
        child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[logo, companyName],
        )));
  }
}
