import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenID = 'Welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  Animation colorAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      //upperBound: 100,  * this wont work when you use curvedanimation.
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

    colorAnimation = ColorTween(begin: Colors.blue[100], end: Colors.white).animate(controller);
    // Detect the status of the animation
    controller.forward();
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    //   print(status);
    // });

    //controller.reverse( from: 1.0); << when you want to make it bigger to smaller.
    //print('100');
    //check the value of the controller value
    controller.addListener(() {
      setState(() {});
      //print('Controller value = ${controller.value}');
      //print('Curved Animation value = ${animation.value}');
      //print(colorAnimation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    //height: animation.value * 60,
                    height: 60,
                  ),
                ),
                // TypewriterAnimatedTextKit(

                //   //'Flash Chat',

                //   ,
                //   textStyle: TextStyle(
                //     fontSize: 45.0,
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),
                TypewriterAnimatedTextKit(
                    onTap: () {
                      print("Tap Event");
                    },
                    text: ['Flash Chat'],
                    totalRepeatCount: 4,
                    speed: Duration(milliseconds: 200),
                    textStyle: TextStyle(fontSize: 40.0, fontFamily: "Agne", fontWeight: FontWeight.w900),
                    textAlign: TextAlign.start,
                    alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                    ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    //Go to login screen.
                    Navigator.pushNamed(
                      context,
                      LoginScreen.screenID,
                    );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    //Go to registration screen.
                    Navigator.pushNamed(
                      context,
                      RegistrationScreen.screenID,
                    );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
