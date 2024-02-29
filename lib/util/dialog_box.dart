import 'package:flutter/material.dart';
import 'package:treefficiency/data/database.dart';
import 'package:treefficiency/util/my_button.dart';

class DialogBox extends StatefulWidget {
  final applianceDataBase db;
  final controller1; // appliance name
  final controller2; // appliance brand
  final controller3; // appliance watts
  String controller1hint;
  String controller2hint;
  String controller3hint;
  final Color backColor;
  final Color saveColor;
  final Color cancelColor;
  final Color textFColor;
  final Color textColor;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.db,
    required this.controller1,
    required this.controller2,
    required this.controller3,
    required this.controller1hint,
    required this.controller2hint,
    required this.controller3hint,
    required this.backColor,
    required this.saveColor,
    required this.cancelColor,
    required this.textFColor,
    required this.textColor,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.backColor,
      content: Container(
        height: 240,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Get user input
              TextField(
                style: TextStyle(color: widget.textColor),
                controller: widget.controller1,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.textFColor,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.saveColor)),
                  hintText: widget.controller1hint,
                  hintStyle: TextStyle(
                    color: widget.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Get user input
              TextField(
                style: TextStyle(color: widget.textColor),
                controller: widget.controller2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.textFColor,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.saveColor)),
                  hintText: widget.controller2hint,
                  hintStyle: TextStyle(
                    color: widget.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Get user input
              TextField(
                style: TextStyle(color: widget.textColor),
                controller: widget.controller3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.textFColor,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: widget.saveColor)),
                  hintText: widget.controller3hint,
                  hintStyle: TextStyle(
                    color: widget.textColor,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              //buttons -> save + cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // save button
                  MyButton(
                    text: "Save",
                    onPressed: widget.onSave,
                    buttonColor: widget.saveColor,
                    messageColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  // cancel button
                  MyButton(
                    text: "Cancel",
                    onPressed: widget.onCancel,
                    buttonColor: widget.cancelColor,
                    messageColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
