import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  // LoadingIndicator({Key key}),
  //       super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = ScaleTransition(
      scale: animation,
      child: SizedBox(
        height: 155.0,
        child: Image.asset(
          "assets/KORE-Logo.png",
          fit: BoxFit.contain,
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white10,
        body: Center(
          // child: CircularProgressIndicator(),
          child: logo,
        ));
  }
}
