//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ApplianceTile extends StatelessWidget {
  final String applianceName;
  final String applianceBrand;
  final String appliancePower;
  final bool pluggedInStatus;
  final bool phantomStatus;
  Function(bool?)? onChangedPowerOnOff;
  Function(bool?)? onChangedPhantom;
  Function(BuildContext)? deleteFunction;
  final String startTimeVal;
  final String endTimeVal;
  final Color powerOnColor;
  final Color powerOffColor;
  final Color powerCheckboxColor;
  final Color phantomCheckboxColor;
  final Color powerOnTextColor;
  final Color powerOffTextColor;
  //VoidCallback deleteFunction;

  ApplianceTile({
    super.key,
    required this.applianceName,
    required this.applianceBrand,
    required this.appliancePower,
    required this.pluggedInStatus,
    required this.phantomStatus,
    required this.onChangedPowerOnOff,
    required this.onChangedPhantom,
    required this.deleteFunction,
    required this.startTimeVal,
    required this.endTimeVal,
    required this.powerOnColor,
    required this.powerOffColor,
    required this.powerCheckboxColor,
    required this.phantomCheckboxColor,
    required this.powerOnTextColor,
    required this.powerOffTextColor,
  });

  /*String elapsedString() {
    if (startTimeVal == "0" || endTimeVal == "0") {
      return "0";
    }
    final start = DateTime.parse(startTimeVal);
    final end = DateTime.parse(endTimeVal);
    final difference = start.difference(end);

    return difference.inSeconds.toString();
  }*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: phantomStatus ? powerOnColor : powerOffColor,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                children: [
                  /* Task Name
                  Text(applianceBrand,
                      style: TextStyle(
                          color: pluggedInStatus ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: pluggedInStatus
                              ? TextDecoration.lineThrough
                              : TextDecoration.none)),*/

                  SizedBox(width: 5),
                  Text(applianceName,
                      style: TextStyle(
                        color: phantomStatus
                            ? powerOnTextColor
                            : powerOffTextColor,
                        fontSize: 16,
                        /*decoration: phantomStatus
                              ? TextDecoration.lineThrough
                              : TextDecoration.none*/
                      )),
                  SizedBox(width: 5),
                  Text(appliancePower + " W",
                      style: TextStyle(
                        color: phantomStatus
                            ? powerOnTextColor
                            : powerOffTextColor,
                        fontSize: 16,
                        /*decoration: phantomStatus
                              ? TextDecoration.lineThrough
                              : TextDecoration.none*/
                      )),
                  Spacer(),
                  /*IconButton(
                    onPressed: deleteFunction,
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                  ),*/
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text("Time Start: " + startTimeVal),
                      Text("Time End: " + endTimeVal),
                      //Text("Time Elapsed: " + elapsedString() + " seconds"),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  // Checkbox
                  Checkbox(
                      value: pluggedInStatus,
                      onChanged: onChangedPowerOnOff,
                      activeColor: powerCheckboxColor),
                  Text(
                    //pluggedInStatus ? "Turned ON" : "Turned OFF",
                    "Turned ON",
                    style: TextStyle(
                      color:
                          phantomStatus ? powerOnTextColor : powerOffTextColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: phantomStatus,
                      onChanged: onChangedPhantom,
                      activeColor: phantomCheckboxColor),
                  Text(
                    //phantomStatus ? "Plugged-In" : "Unplugged",
                    "Plugged-In",
                    style: TextStyle(
                      color:
                          phantomStatus ? powerOnTextColor : powerOffTextColor,
                    ),
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
