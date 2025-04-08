import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:datadeck/main.dart';
import 'package:datadeck/navigation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(seconds: 5), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Navigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: mq.width * .5,
            left: mq.width * .15,
            width: mq.width * .7,
            child: Image.asset('assets/images/logo.png'),
          ),
          //label
          Positioned(
            bottom: mq.height * .35,
            width: mq.width,
            child: Center(
              child: Text(
                'DataDesk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BoldFont',
                  fontSize: 40,
                ),
              ),
            ),
          ),
          //label
          Positioned(
            bottom: mq.height * .27,
            width: mq.width,
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Snap. Save. Slide!',
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'BoldFont',
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 220),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
