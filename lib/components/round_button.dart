import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  Color color;
  Function onPressed;
  String title = '';

  RoundedButton({@required this.color, @required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        //color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          // onPressed: () {
          //   //Go to registration screen.
          //   Navigator.pushNamed(
          //     context,
          //     RegistrationScreen.screenID,
          //   );
          // },
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            // 'Register',
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
