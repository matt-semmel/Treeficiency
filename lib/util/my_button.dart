import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  Color buttonColor;
  Color messageColor;
  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.buttonColor,
    required this.messageColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: messageColor,
      color: buttonColor,
      child: Text(text),
    );
  }
}
