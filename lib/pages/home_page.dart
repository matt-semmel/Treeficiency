//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:treefficiency/data/database.dart';
import 'package:treefficiency/util/dialog_box.dart';
import 'package:treefficiency/util/my_button.dart';
import '../util/appliance_tile.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  applianceDataBase db = applianceDataBase();

  @override
  void initState() {
    // if this is the first time ever opening the app, then create default data
    if (_myBox.get("APPLIST") == null) {
      db.createInitialData();
      db.updateDatabase();
    } else {
      // there already exists data
      db.loadData();
    }
  }

  // text controllers
  // used for receiving info from the user
  // after user interacts with the floating action button
  final _controller1 = TextEditingController(); // app name, Monthly Energy 1
  final _controller2 = TextEditingController(); // app brand, Monthly Energy 2
  final _controller3 = TextEditingController(); // app watts, Monthly Energy 3

  // specifies energy counter's text interactable state
  // touching the used power value changes the value of this state to
  // signal changing from kWH to W, W to power-on time, power-on time to kWH
  int energyChoice = 0;

  // phantom checkbox tapped
  // index = applianceIndex for appliance that was interacted with
  // value = checkBox currentValue (checkbox val is updated here. this value reflects the state before the press)
  void checkBoxPhantom(bool? value, int index) {
    setState(() {
      // Set Start/End times depending on appliance state
      DateTime now = DateTime.now();
      // log first power on / plugged in time
      if (db.userMonthElec[4] == "") {
        db.userMonthElec[4] = now.toString();
        if (db.userMonthElec[5] == "") {
          db.userMonthElec[5] = now.toString();
        }
      }
      bool addNode = phantomPtsAndTime(index, now);

      if (addNode) {
        addGraphNode(now);
      }

      db.appList[index][5] = !db.appList[index]
          [5]; // reverse phantom energy (plugged-in) checkbox state
      if (db.appList[index][1] && !db.appList[index][5]) {
        db.appList[index][1] = !db.appList[index][1];
      } // if turned on and phantom energy (plugged-in) just turned off, appliance 'turned-on' state must be off too.
    });
    db.updateDatabase();
  }

  // Power-on / Power off points calculations and time updater for a given appliance
  // index = index of specified appliance
  // now = DateTime of power event
  bool powerOnOffPtsAndTime(int index, DateTime now) {
    // powered off & unplugged, user just powered on. (AND FORCED PLUGGED IN)
    if (!db.appList[index][1] && !db.appList[index][5]) {
      final start = now;
      db.appList[index][7] = start.toString(); // power on start time recorded
      return false;
    }
    // powered off but plugged in, user just powered on. record phantom energy that was consumed in between.
    else if (!db.appList[index][1] && db.appList[index][5]) {
      final start = DateTime.parse(db.appList[index][7]);
      final end = now;
      db.appList[index][8] = end.toString(); // record time for debugging

      // Point Calculations
      double difference = end.difference(start).inSeconds.toDouble();
      db.totalPoints[3] += difference; // log total recorded time
      db.appList[index][11] = (difference / 60 / 60) *
          (double.parse(
              db.appList[index][6])); // log total phantom watts consumed
      db.appList[index][12] += difference; // log appliance phantom total time

      double pWattHours =
          // seconds to hours * phantom watts
          (difference / 3600) * (double.parse(db.appList[index][6]));

      db.totalPoints[0] += pWattHours; // update watt hours pts
      db.totalPoints[2] += db.appList[index][11]; // update watt pts
      db.totalPoints[4] +=
          db.appList[index][11]; // update watt pts for tree counter
      db.appList[index][7] = end.toString(); // power on start time recorded
      return true;
    }
    // powered on, user just powered off.
    else if (db.appList[index][1]) {
      final start = DateTime.parse(db.appList[index][7]);
      final end = now;
      db.appList[index][8] = end.toString(); // record time for debugging

      // Point Calculations
      double difference = end.difference(start).inSeconds.toDouble();
      db.totalPoints[3] += difference; // log total recorded time
      db.appList[index][9] = (difference / 60 / 60) *
          (double.parse(
              db.appList[index][3])); // log total power on watts consumed
      db.appList[index][10] += difference; // log appliance power on total time

      double wattHours =
          // seconds to hours * power on watts
          (difference / 3600) * (double.parse(db.appList[index][3]));

      db.totalPoints[0] += wattHours; // update watt hours pts
      db.totalPoints[2] += db.appList[index][9]; // update watt pts
      db.totalPoints[4] +=
          db.appList[index][9]; // update watt pts for tree counter
      db.appList[index][7] = end.toString(); // phantom start time recorded
      return true;
    }
    return false;
  }

  // Phantom points calculations and time updater for a given appliance
  // index = index of specified appliance
  // now = DateTime of phantom power event
  bool phantomPtsAndTime(int index, DateTime now) {
    // powered on and plugged in, user just unplugged (FORCE POWER OFF)
    if (db.appList[index][1] && db.appList[index][5]) {
      return powerOnOffPtsAndTime(index, now);
    } else if (!db.appList[index][1] && !db.appList[index][5]) {
      final start = now;
      db.appList[index][7] = start.toString(); // power on start time recorded
      return false;
    }
    // powered on, user just powered off.
    else if (!db.appList[index][1] && db.appList[index][5]) {
      final start = DateTime.parse(db.appList[index][7]);
      final end = now;
      db.appList[index][8] = end.toString(); // record time for debugging

      // Point Calculations
      double difference = end.difference(start).inSeconds.toDouble();
      db.totalPoints[3] += difference; // log total recorded time
      db.appList[index][11] = (difference / 60 / 60) *
          (double.parse(
              db.appList[index][6])); // log total phantom watts consumed
      db.appList[index][12] += difference; // log appliance phantom total time

      double pWattHours =
          // seconds to hours * phantom watts
          (difference / 3600) * (double.parse(db.appList[index][6]));

      db.totalPoints[0] += pWattHours; // update watt hours pts
      db.totalPoints[2] += db.appList[index][11]; // update watt pts
      db.totalPoints[4] +=
          db.appList[index][11]; // update watt pts for tree counter
      return true;
    }
    return false;
  }

  // adds a graph node for the new power-on event
  // average lines are also updated where applicable
  void addGraphNode(DateTime now) {
    // check if graph empty
    // if false (empty) set to true so line appears on graph
    if (!db.graphStats[8]) {
      db.graphStats[8] = true;
    }
    if (db.graphNode.length == 0) {
      db.userMonthElec[6] = now.toString();
      db.graphNodeVals.add([0, db.totalPoints[0]]);
      db.graphNode.add(FlSpot(0.0, db.totalPoints[0]));

      // out of bounds -- expand y axis bound
      if (db.totalPoints[0] > db.graphStats[3]) {
        db.graphStats[3] = db.totalPoints[0] * 2;
        db.graphStats[5] = db.totalPoints[0] / 5;
      }
    } else {
      DateTime start = DateTime.parse(db.userMonthElec[6]);
      double difference = 0;
      switch (db.graphStats[9]) {
        case 0:
          {
            difference = now
                .difference(start)
                .inSeconds
                .toDouble(); // every node after compares and stores the difference in seconds
          }
        case 1:
          {
            difference = now.difference(start).inSeconds.toDouble() /
                60; // every node after compares and stores the difference in seconds
          }
        case 2:
          {
            difference = now.difference(start).inSeconds.toDouble() /
                60 /
                60; // every node after compares and stores the difference in seconds
          }
        case 3:
          {
            difference = now.difference(start).inSeconds.toDouble() /
                60 /
                60 /
                24; // every node after compares and stores the difference in seconds
          }
      }

      // out of bounds -- expand y axis bound (watts)
      if (db.totalPoints[0] > db.graphStats[3]) {
        double expandRatio = 0.0;
        if (db.graphStats[10] == 1) {
          expandRatio = db.totalPoints[0].toDouble() / 1000 * 2;
        } else if (db.graphStats[10] == 0) {
          expandRatio = db.totalPoints[0].toDouble() * 2;
        }
        expandRatio = double.parse(expandRatio.toStringAsFixed(1));
        db.graphStats[3] = expandRatio;
        db.graphStats[5] = db.graphStats[3] / 5;
      }

      // out of bounds -- expand x axis bound
      if (difference > db.graphStats[1]) {
        db.graphStats[1] = difference * 2;
        db.graphStats[4] = db.graphStats[1] / 10;
      }

      // y value changes depending on w or kW
      double graphYvalue = db.totalPoints[0];
      if (db.graphStats[10] == 1) {
        graphYvalue /= 1000;
      }
      db.graphNodeVals.add([difference, graphYvalue]);
      db.graphNode.add(FlSpot(difference, graphYvalue));

      // bloated x axis, graph needs to be completely reorganized
      if (db.graphStats[1] > 120) {
        resetupGraph(db.graphStats[9] + 1);
      }

      // bloated y axis, graph needs to be reorganized
      if (db.graphStats[3] > 1000) {
        resetupGraphY(1);
      }
    }

    // calculate ebill average nodes
    addAverageNodes(now);

    // calculate expected average nodes
    addExpectedNodes(now);
  }

  // calculates expected average line and charts the line
  // to an FlSpot graph
  void addExpectedNodes(DateTime now) {
    if (db.graphNode.length <= 1) {
      return;
    }

    double yIntercept = 0.0;
    double avgSlope = 0.0;
    double totalSlope = 0.0;
    int slopeCount = 0;
    double previousX = 0.0;
    double previousY = 0.0;
    for (int i = 0; i < db.graphNode.length; i++) {
      if (i == 0) {
        yIntercept = db.graphNodeVals[i][1].toDouble();
        previousX = db.graphNodeVals[i][0].toDouble();
        previousY = db.graphNodeVals[i][1].toDouble();
        continue;
      }
      double yDiff = 0.0;
      double xDiff = 0.0;

      xDiff = db.graphNodeVals[i][0] - previousX;
      yDiff = db.graphNodeVals[i][1] - previousY;

      if (xDiff != 0) {
        totalSlope += (yDiff / xDiff);
        slopeCount++;
      }
      previousX = db.graphNodeVals[i][0];
      previousY = db.graphNodeVals[i][1];
    }

    avgSlope = totalSlope / slopeCount;

    // if eBillAvg slope > default slope,
    // a line starting at 0 with eBillAvg slope will intersect y-axis bounds first
    //
    // if eBillAvg slope < default slope,
    // a line starting at 0 with eBillAvg slope will intersect x-axis bounds first
    double defaultSlope = (db.graphStats[3] + yIntercept) / db.graphStats[1];

    db.expectedNode = [];
    db.expectedNodeVals = [];
    // y known, calculate x
    if (avgSlope > defaultSlope) {
      double x = (db.graphStats[3] + yIntercept) / avgSlope;
      db.expectedNode.add(FlSpot(0, db.graphNodeVals[0][1]));
      db.expectedNode.add(FlSpot(x, db.graphStats[3]));
      db.expectedNodeVals.add([0.0, db.graphNodeVals[0][1]]);
      db.expectedNodeVals.add([x, db.graphStats[3]]);
      return;
    }
    // x known, calculate y
    else if (avgSlope < defaultSlope) {
      double y = (db.graphStats[1] * avgSlope) + yIntercept;
      db.expectedNode.add(FlSpot(0, db.graphNodeVals[0][1]));
      db.expectedNode.add(FlSpot(db.graphStats[1], y));
      db.expectedNodeVals.add([0.0, db.graphNodeVals[0][1]]);
      db.expectedNodeVals.add([db.graphStats[1], y]);
      return;
    }

    return;
  }

  // calculates monthly average line and charts the line
  // to an FlSpot graph
  void addAverageNodes(DateTime now) {
    // if no monthly average in db or no start time to compare
    if (db.userMonthElec[3] == 0 || db.userMonthElec[6] == "") {
      return;
    }
    DateTime start = DateTime.parse(db.userMonthElec[6]);
    double difference = now.difference(start).inSeconds.toDouble();
    double monthlyConverted = 0;
    // convert based on x-axis type
    switch (db.graphStats[9]) {
      // seconds
      case 0:
        {
          if (db.graphStats[10] == 1) {
            difference /= 1000;
            monthlyConverted = db.userMonthElec[3] / 31 / 24 / 60 / 60;
          } else {
            monthlyConverted = db.userMonthElec[3] / 31 / 24 / 60 / 60 * 1000;
          }
        }

      // minutes
      case 1:
        {
          if (db.graphStats[10] == 1) {
            difference = difference / 60 / 1000;
            monthlyConverted = db.userMonthElec[3] / 31 / 24 / 60;
          } else {
            difference /= 60;
            monthlyConverted = db.userMonthElec[3] / 31 / 24 / 60 * 1000;
          }
        }
      // hours
      case 2:
        {
          if (db.graphStats[10] == 1) {
            difference = difference / 3600 / 1000;
            monthlyConverted = db.userMonthElec[3] / 31 / 24;
          } else {
            difference /= 3600;
            monthlyConverted = db.userMonthElec[3] / 31 / 24 * 1000;
          }
        }
      // days
      case 3:
        {
          if (db.graphStats[10] == 1) {
            difference = difference / 86400 / 1000;
            monthlyConverted = db.userMonthElec[3] / 31;
          } else {
            difference /= 86400;
            monthlyConverted = db.userMonthElec[3] / 31 * 1000;
          }
        }
    }

    double avgE = difference * monthlyConverted;
    double avgSlope = avgE / difference;

    // if eBillAvg slope > default slope,
    // a line starting at 0 with eBillAvg slope will intersect y-axis bounds first
    //
    // if eBillAvg slope < default slope,
    // a line starting at 0 with eBillAvg slope will intersect x-axis bounds first
    double defaultSlope = db.graphStats[3] / db.graphStats[1];

    db.eBillNode = [];
    db.eBillNodeVals = [];
    // y known, calculate x
    if (avgSlope > defaultSlope) {
      double x = db.graphStats[3] / avgSlope;
      db.eBillNode.add(FlSpot(0, 0));
      db.eBillNode.add(FlSpot(x, db.graphStats[3]));
      db.eBillNodeVals.add([0.0, 0.0]);
      db.eBillNodeVals.add([x, db.graphStats[3]]);
      return;
    }
    // x known, calculate y
    else if (avgSlope < defaultSlope) {
      double y = db.graphStats[1] * avgSlope;
      db.eBillNode.add(FlSpot(0, 0));
      db.eBillNode.add(FlSpot(db.graphStats[1], y));
      db.eBillNodeVals.add([0.0, 0.0]);
      db.eBillNodeVals.add([db.graphStats[1], y]);
      return;
    }
    return;
  }

  // resets all graph values after x-axis resize
  void resetupGraph(int timeVal) {
    // 0 = seconds, 1 = minutes, 2 = hours, 3 = days
    int curTimeVal = db.graphStats[9];

    double convertRatio = resetupGraphHelper(curTimeVal, timeVal);
    if (convertRatio == 0) {
      return;
    }

    // retrieve graph
    db.graphNode = [];
    for (int i = 0; i < db.graphNodeVals.length; i++) {
      db.graphNodeVals[i][0] *= convertRatio;
      db.graphNode.add(FlSpot(db.graphNodeVals[i][0].toDouble(),
          db.graphNodeVals[i][1].toDouble()));
    }
    db.graphStats[1] = (db.graphStats[1] * convertRatio).ceil().toDouble();

    // this fixes a bug where duplicate values appear along the bottom of the x axis
    if (db.graphStats[1].toDouble() / 10.0 < 1.0) {
      db.graphStats[4] = 1.0;
    } else {
      db.graphStats[4] = db.graphStats[1].toDouble() / 10.0;
    }

    db.graphStats[9] = timeVal;
  }

  // returns conversion ratio for converting graph after x-axis resize
  double resetupGraphHelper(int curTimeVal, int timeVal) {
    switch (curTimeVal) {
      // seconds to ??
      case 0:
        {
          switch (timeVal) {
            case 0:
              return 0;
            case 1:
              {
                db.graphStats[6] = "Time (Minutes)";
                return 0.01666667;
              }
            case 2:
              {
                db.graphStats[6] = "Time (Hours)";
                return 0.0002777778;
              }
            case 3:
              {
                db.graphStats[6] = "Time (Days)";
                return 0.00001157407;
              }
          }
        }
      // minutes to ??
      case 1:
        {
          switch (timeVal) {
            case 0:
              {
                db.graphStats[6] = "Time (Seconds)";
                return 60;
              }
            case 1:
              return 0;
            case 2:
              {
                db.graphStats[6] = "Time (Hours)";
                return 0.01666667;
              }
            case 3:
              {
                db.graphStats[6] = "Time (Days)";
                return 0.0006944444;
              }
          }
        }
      // hours to ??
      case 2:
        {
          switch (timeVal) {
            case 0:
              {
                db.graphStats[6] = "Time (Seconds)";
                return 3600;
              }
            case 1:
              {
                db.graphStats[6] = "Time (Minutes)";
                return 60;
              }
            case 2:
              return 0;
            case 3:
              {
                db.graphStats[6] = "Time (Days)";
                return 0.04166667;
              }
          }
        }

      // days to ??
      case 3:
        {
          switch (timeVal) {
            case 0:
              {
                db.graphStats[6] = "Time (Seconds)";
                return 86400;
              }
            case 1:
              {
                db.graphStats[6] = "Time (Minutes)";
                return 1440;
              }
            case 2:
              {
                db.graphStats[6] = "Time (Hours)";
                return 24;
              }
            case 3:
              return 0;
          }
        }
    }
    return 0;
  }

  // resets all graph values after y-axis resize
  void resetupGraphY(int choice) {
    double convertRatio = 0;

    // kW to w
    if (choice == 0 && db.graphStats[10] == 1) {
      convertRatio = 1000;
      db.graphStats[7] = "Watts (W)";
      db.graphStats[11] = "Watts over Time";
    }
    // w to kW
    else if (choice == 1 && db.graphStats[10] == 0) {
      convertRatio = 0.001;
      db.graphStats[7] = "kilowatts (kW)";
      db.graphStats[11] = "Kilowatts over Time";
      db.graphStats[10] = 1;
    } else {
      convertRatio = 0.001;
    }

    // retrieve graph
    db.graphNode = [];
    for (int i = 0; i < db.graphNodeVals.length; i++) {
      db.graphNodeVals[i][1] =
          db.graphNodeVals[i][1].toDouble() * convertRatio.toDouble();
      db.graphNode.add(FlSpot(db.graphNodeVals[i][0].toDouble(),
          db.graphNodeVals[i][1].toDouble()));
    }
    db.graphStats[3] = (db.graphStats[3] * convertRatio).toDouble();

    // this fixes a bug where duplicate values appear along the bottom of the x axis
    if (db.graphStats[3].toDouble() / 5.0 < 0.5) {
      db.graphStats[5] = 0.5;
    } else {
      db.graphStats[5] =
          double.parse((db.graphStats[3].toDouble() / 5.0).toStringAsFixed(1));
    }
  }

  // power-on checkbox tapped
  // index = applianceIndex for appliance that was interacted with
  // value = checkBox currentValue (checkbox val is updated here. this value reflects the state before the press)
  void checkBoxPowerOnOff(bool? value, int index) {
    setState(() {
      // Set Start/End times depending on appliance state
      DateTime now = DateTime.now();
      // log first power on / plugged in time
      if (db.userMonthElec[4] == "") {
        db.userMonthElec[4] = now.toString();
        if (db.userMonthElec[5] == "") {
          db.userMonthElec[5] = now.toString();
        }
      }
      bool addNode = powerOnOffPtsAndTime(index, now);

      if (addNode) {
        addGraphNode(now);
      }

      // Actually Reverse Checkbox values in DB
      db.appList[index][1] =
          !db.appList[index][1]; // reverse power on/off checkbox state
      if (db.appList[index][1] && !db.appList[index][5]) {
        db.appList[index][5] = !db.appList[index][5];
      } // if turned on, appliance must also be plugged in too
    });
    db.updateDatabase();
  }

  // create new appliance
  void createNewApp() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          db: db,
          controller1: _controller1,
          controller2: _controller2,
          controller3: _controller3,
          controller1hint: "Add Appliance Name",
          controller2hint: "Add Watt Number",
          controller3hint: "Add Phantom Watt Number",
          backColor: db.themeData[1],
          saveColor: db.themeData[0],
          cancelColor: db.themeData[5],
          textFColor: db.themeData[1],
          textColor: db.themeData[10],
          onSave: saveNewApp, // saves to database
          onCancel: () {
            Navigator.of(context).pop();
            _controller1.clear();
            _controller2.clear();
            _controller3.clear();
          }, // dismisses the dialog
        );
      },
    );
  }

  // prompt the user for monthly kWh data
  // receives monthly data using 3 text controllers
  // stored data is saved to the hive
  void createNewUserData() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          db: db,
          controller1: _controller1,
          controller2: _controller2,
          controller3: _controller3,
          controller1hint: "Add Monthly kWh #1",
          controller2hint: "Add Monthly kWh #2",
          controller3hint: "Add Monthly kWh #3",
          backColor: db.themeData[1],
          saveColor: db.themeData[0],
          cancelColor: db.themeData[5],
          textFColor: db.themeData[1],
          textColor: db.themeData[10],
          onSave: saveNewUserData, // saves to database
          onCancel: () {
            Navigator.of(context).pop();
            _controller1.clear();
            _controller2.clear();
            _controller3.clear();
          }, // dismisses the dialog
        );
      },
    );
  }

  // save new appliance
  // new appliance is saved to hive using user submitted values
  // clears textcontrollers after use
  void saveNewApp() {
    setState(() {
      db.appList.add([
        _controller1.text, // appliance name
        false, // powered on checkbox state
        "", // todo: delete later
        _controller2.text, // watts
        "", // todo: delete later
        false, // phantom checkbox state
        _controller3.text, // phantom watts
        "0", // start time
        "0", // end time
        0.0, // total watts consumed
        0.0, // total power on time in hours
        0.0, // total phantom watts consumed
        0.0, // total phantom time in seconds
      ]);
    });
    Navigator.of(context).pop();
    // do this to prevent textbox from retaining old value hint
    _controller1.clear();
    _controller2.clear();
    _controller3.clear();
    db.updateDatabase();
  }

  // save user submitted monthly data
  // monthly kWh data is saved to the hive
  // clears text controllers after use
  void saveNewUserData() {
    setState(() {
      db.userMonthElec[0] = double.parse(_controller1.text); // month 1
      db.userMonthElec[1] = double.parse(_controller2.text); // month 2
      db.userMonthElec[2] = double.parse(_controller3.text); // month 3
      db.userMonthElec[3] = (double.parse(_controller1.text) +
              double.parse(_controller2.text) +
              double.parse(_controller3.text)) /
          3; // store average of all 3 months to database
      db.userMonthElec[5] =
          db.userMonthElec[3] / 30 / 24 / 60 / 60; // store avg kWS
      addAverageNodes(DateTime.now());
    });
    Navigator.of(context).pop();
    // do this to prevent textbox from retaining old value hint
    _controller1.clear();
    _controller2.clear();
    _controller3.clear();
    db.updateDatabase();
  }

  // delete specific appliance
  // removes specific appliance from the hive
  void deleteApp(int index) {
    setState(() {
      db.appList.removeAt(index);
      db.updateDatabase();
    });
  }

  // energy info is displayed through a dialog box after the energy icon is clicked
  void energyIconInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: db.themeData[1],
          title: Container(
              child: Row(
            children: [
              Image.asset(
                'assets/images/watt.png',
                height: 30,
              ),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  ' Used Energy'),
            ],
          )),
          content: Text(
            style: TextStyle(
              color: db.themeData[10],
            ),
            'Consumed energy is recorded in watts/kilowatts. '
            '\n\nEverytime an appliance is left plugged in / turned on '
            'it will consume energy.\n\nUnplugging or turning off an '
            'appliance will record the energy consumed while it was active.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // tree point info is displayed through a dialog box after the tree icon is clicked
  void treeIconInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: db.themeData[1],
          title: Container(
              child: Row(
            children: [
              Image.asset(
                'assets/images/tree.png',
                height: 30,
              ),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  ' Tree Points'),
            ],
          )),
          content: Text(
            style: TextStyle(
              color: db.themeData[10],
            ),
            'Tree Points are awarded for consuming less energy over time '
            'than the previous average from a user\'s own electrical bill.\n\n '
            'Tree Pt Conversions: \n\n'
            '1000pts = 1 lb of absorbed carbon emmision\n\n'
            '1 tree = 48 lbs of absorbed carbon per year.\n\n',
            //'HINT: Pressing the \'Tree Points\' will show the equivalent amount of trees for the current points.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // main menu floating action button choices
  void userAddChoice() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: db.themeData[1],
          content: Container(
            height: 175,
            child: Column(
              children: [
                Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Please select an option',
                ),
                SizedBox(height: 10),
                MyButton(
                    text: 'Add Appliance',
                    onPressed: () {
                      Navigator.of(context).pop();
                      createNewApp();
                    },
                    buttonColor: db.themeData[4],
                    messageColor: db.themeData[6]),
                MyButton(
                    text: 'Add Monthly Energy',
                    onPressed: () {
                      Navigator.of(context).pop();
                      createNewUserData();
                    },
                    buttonColor: db.themeData[0],
                    messageColor: db.themeData[6]),
                MyButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    buttonColor: db.themeData[5],
                    messageColor: db.themeData[6]),
              ],
            ),
          ),
        );
      },
    );
  }

  // updates energy counter based on ALL current appliances/appliances' power states
  void updateEnergyCounter() {
    DateTime now = DateTime.now();
    for (int i = 0; i < db.appList.length; i++) {
      if (db.appList[i][5]) {
        if (db.appList[i][1]) {
          powerOnOffPtsAndTime(i, now); // powered on appliance data logged
          continue;
        }
        phantomPtsAndTime(i, now); // plugged in appliance data logged
      }
    }
    setState(() {});
  }

  // updates tree counter based on current watt totals and monthly kWh averages submitted by the user
  void updateTreeCounter() {
    DateTime end = DateTime.now();
    updateEnergyCounter();
    if (db.userMonthElec[3] == 0.0 || db.totalPoints[2] == 0.0) {
      String errorText =
          "Please submit monthly energy info and appliance usage info before checking for Tree Points.";
      if (db.userMonthElec[3] != 0.0) {
        errorText =
            "Please record appliance usage info before checking for Tree Points.";
      } else if (db.totalPoints[2] != 0.0) {
        errorText =
            "Please submit monthly energy info before checking for Tree Points.";
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: db.themeData[1],
            content: Text(
              style: TextStyle(
                color: db.themeData[10],
              ),
              errorText,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      final start = DateTime.parse(db.userMonthElec[4]);

      // difference is total time elapsed since first power on in seconds -- total recorded user energy state time in seconds
      double difference = end.difference(start).inSeconds.toDouble();

      // avg kWH per month to avg kWH per second
      // double avgKWHSec = db.userMonthElec[3] / 30 / 24 / 60 / 60;
      double avgKWHSec = db.userMonthElec[5];

      double avgKWH = difference * avgKWHSec;
      double actualKWH = db.totalPoints[4] / 1000;

      // https://www.eia.gov/tools/faqs/faq.php?id=74&t=11
      // 1kWh of generic electricity (any source) = 0.86 lbs of carbon emission
      // 1 tree absorbs about 48lbs of carbon per year
      if (avgKWH > actualKWH) {
        db.totalPoints[1] += ((avgKWH - actualKWH) *
            0.86 *
            1000); // treept count is now total saved kWH * 1000.
        db.totalPoints[5] += db.totalPoints[
            1]; // track all received points independent of spent points for high score tracking
      }
      db.userMonthElec[4] = end
          .toString(); // reset start time so user doesn't double dip on points*/
      db.totalPoints[4] =
          0; // reset watts since last refresh so user doesn't double dip on points
      setState(() {});
    }
  }

  // updates energy info
  // updates the text widget that displays the energy value on the screen
  String wattCounter() {
    double wPts = db.totalPoints[0].toDouble();
    if (energyChoice == 0) {
      wPts = wPts / 1000;
      return wPts.toStringAsFixed(4) + " kWh"; // kilowatt/hour counter
    } else if (energyChoice == 1) {
      if (db.totalPoints[2] > 1000) {
        return (db.totalPoints[2] / 1000).toStringAsFixed(3) +
            " kW"; // kW counter
      }
      return db.totalPoints[2].toStringAsFixed(3) + " W"; // watt counter
    } else {
      if (db.totalPoints[3] < 60) {
        return db.totalPoints[3].toStringAsFixed(0) +
            " sec"; // time in seconds counter
      } else if (db.totalPoints[3] > 3600) {
        return (db.totalPoints[3] / 3600).toStringAsFixed(2) +
            " hrs"; // time in seconds counter
      } else if (db.totalPoints[3] > 86400) {
        return (db.totalPoints[3] / 86400).toStringAsFixed(2) +
            " days"; // time in seconds counter
      }
      //else
      return (db.totalPoints[3] / 60).toStringAsFixed(2) +
          " min"; // time in seconds counter
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: db.themeData[1],
      appBar: AppBar(
        backgroundColor: db.themeData[0],
        toolbarHeight: 45,
        elevation: 0, // removes shadow from appbar
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Treefficiency",
        ),

        leading: IconButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/rewardspage',
                arguments: {'db': db});
            setState(() {});
          },
          icon: Icon(Icons.wallet_giftcard_rounded),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/graphspage',
                  arguments: {'db': db});
              setState(() {});
            },
            icon: Icon(Icons.auto_graph_rounded),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/leaderboard',
                  arguments: {'db': db});
              setState(() {});
            },
            icon: Icon(Icons.leaderboard),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/settingspage',
                  arguments: {'db': db});
              setState(() {});
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 9),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 3),
              GestureDetector(
                onTap: energyIconInfo,
                child: Image.asset(
                  'assets/images/watt.png',
                  height: 30,
                ),
              ),
              const SizedBox(width: 3),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if (energyChoice == 2) {
                        energyChoice = 0;
                        return;
                      }
                      energyChoice++;
                    });
                  },
                  child: (Text(
                      style: TextStyle(
                        color: db.themeData[10],
                      ),
                      "Used Power: " + wattCounter()))),
              Spacer(),
              GestureDetector(
                onTap: updateTreeCounter,
                child: Icon(
                  Icons.refresh_sharp,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  "Tree Points: " + db.totalPoints[1].toStringAsFixed(0)),
              const SizedBox(width: 3),
              GestureDetector(
                onTap: treeIconInfo,
                child: Image.asset(
                  'assets/images/tree.png',
                  height: 30,
                ),
              ),
              const SizedBox(width: 7),
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: db.appList.length,
                  itemBuilder: (context, index) {
                    return ApplianceTile(
                      applianceName: db.appList[index][0],
                      applianceBrand: db.appList[index][2],
                      appliancePower: db.appList[index][3],
                      pluggedInStatus: db.appList[index][1],
                      phantomStatus: db.appList[index][5],
                      onChangedPowerOnOff: (value) =>
                          checkBoxPowerOnOff(value, index),
                      onChangedPhantom: (value) =>
                          checkBoxPhantom(value, index),
                      deleteFunction: (context) => deleteApp(index),
                      startTimeVal: db.appList[index][7],
                      endTimeVal: db.appList[index][8],
                      powerOnColor: db.themeData[3],
                      powerOffColor: db.themeData[2],
                      powerCheckboxColor: db.themeData[7],
                      phantomCheckboxColor: db.themeData[5],
                      powerOnTextColor: db.themeData[8],
                      powerOffTextColor: db.themeData[9],
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: db.themeData[0],
        onPressed: userAddChoice,
        child: const Icon(Icons.add),
      ),
    );
  }
}
