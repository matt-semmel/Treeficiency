import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// applianceDatabase
//   stores app data in Hive database, as well as
//   applianceDatabase class variables accessible
//   to other classes
class applianceDataBase {
  List appList = [];
  List categoryList = [];
  List categoryAppList = [];
  List totalPoints = [];
  List userMonthElec = [];
  List themeData = [];
  List themes = [];
  List<FlSpot> graphNode = [];
  List graphNodeVals = [];
  List<FlSpot> eBillNode = [];
  List eBillNodeVals = [];
  List<FlSpot> expectedNode = [];
  List expectedNodeVals = [];
  List graphStats = [];
  List graphSelection = [];

  // reference the hive box
  final _myBox = Hive.box('mybox');

  // creates initial data for hive storage
  //  any time app is ran for the first time or databases have been manually reset
  //  this method will initialize all lists to their default values
  void createInitialData() {
    // APPLIST
    // [0] appliance
    // [1] powered on checkbox
    // [2] brandname UNUSED
    // [3] watt num
    // [4] UNUSED
    // [5] phantom energy checkbox
    // [6] phantom watts
    // [7] time start
    // [8] time end
    // [9] total watts consumed
    // [10] total power on time in hours
    // [11] total phantom watts consumed
    // [12] total phantom time in seconds
    appList = [
      [
        "Example Microwave",
        false, // power-on checkbox state
        "",
        "1200", // watts
        "",
        false, // phantom-energy checkbox state
        "20", // phantom watts
        "0",
        "0",
        0.0,
        0.0,
        0.0,
        0.0,
      ],
    ];

    // TOTALPOINTS
    // [0] = watt hours consumed
    // [1] = tree points
    // [2] = watts consumed
    // [3] = total seconds of power-on time elapsed
    // [4] = total watts since last tree point calculation
    // [5] = total points earned (spent points inclusive)
    totalPoints = [
      0.0, // watt hours
      0.0, // tree points
      0.0, // watts consumed
      0.0, // total seconds power-on time
      0.0, // all watts since last tree point check
      0.0, // all tree points ever earned
    ];

    // USERMONTHELEC
    // [0] = Month 1 kWH from user
    // [1] = Month 2 kWH from user
    // [2] = Month 3 kWH from user
    // [3] = Avg monthly kWH from user month kWH submissions
    // [4] = time of first recorded power-on (resets for cheat detection on tree points)
    // [5] = Avg monthly kWS from user month kWH submissions
    // [6] = time of first recorded power-on. DOES NOT RESET. Permanent value used for graph tracking
    userMonthElec = [
      0.0,
      0.0,
      0.0,
      0.0, // avg monthly kWH
      "", // dateTime of first power-on (RESETS. Accounts for cheat detection)
      0.0, // avg monthly kWS
      "", // dateTime of first power-on (DOES NOT RESET. Used for graph)
    ];

    // GRAPHNODE
    // FlSpot node list
    //
    // holds nodes for all user appliance power events for graph_page
    //    the line created from these nodes represents every interaction between
    //    the user and the appliance's power states.
    // [0] = seconds since first power-on
    // [1] = total watts during this power event
    graphNode = [
      /*[
        0, // seconds since first value
        0.0, // total watts at that time
      ],*/
    ];

    // GRAPHNODEVALS
    // dynamic list for graphNode
    //
    // holds values related to graphNode FlSpot graph points.
    // Used for translating expected avg nodes back and forth between Hive database
    graphNodeVals = [];

    // EBILLNODE
    // FlSpot node list
    // holds nodes for the electric bill average consumption line for graph_page
    // [0] = seconds since first power-on
    // [1] = total watts during this power event
    eBillNode = [];

    // EBILLNODEVALS
    // dynamic list for eBillNode
    // holds values related to eBillNode FlSpot graph points.
    // Used for translating expected avg nodes back and forth between Hive database
    eBillNodeVals = [];

    // EXPECTEDNODE
    // FlSpot node list
    // holds nodes for the expected average consumption line for graph_page
    // [0] = seconds since first power-on
    // [1] = total watts during this power event
    expectedNode = [];

    // EXPECTEDNODEVALS
    // dynamic list for expectedNode
    // holds values related to expectedNode FlSpot graph points.
    // Used for translating expected avg nodes back and forth between Hive database
    expectedNodeVals = [];

    // GRAPHSTATS
    // [0] minX
    // [1] maxX
    // [2] minY
    // [3] maxY
    // [4] bottom interval
    // [5] side interval
    // [6] bottom title
    // [7] side title
    // [8] bool show main graph line
    // [9] x-axis interval type  0 = sec, 1 = min, 2 = hr, 3 = day
    // [10] y-axis interval type  0 = watts, 1 = kW
    // [11] graph title
    graphStats = [
      0.0, // minX
      10.0, // maxX
      0.0, // minY
      5.0, // maxY
      1.0, // bottom interval
      1.0, // side interval
      "Time (Seconds)", // bottom title
      "Watts (W)", // side title
      false, // show main graph line
      0, // x-axis  0 = seconds, 1 = minutes, 2 = hours, 3 = days
      0, // y-axis  0 = watts, 1 = kW
      "Watts over Time", // graph title
    ];

    // GRAPHSELECTION
    // [0] = UNUSED
    // [1] = UNUSED
    // [2] = eBillCheckbox state
    // [3] = expectedAvgCheckbox state
    graphSelection = [
      '',
      '',
      false, // eBillCheckbox state
      false, // expectedAverageCheckbox state
    ];

    // THEMES
    // [0] = selected theme
    //         - 0 = default
    //         - 1 = blue
    //         - 2 = dark
    //         - 3 = beta
    // [1] = default theme unlocked
    // [2] = blue theme locked
    // [3] = dark theme locked
    // [4] = beta theme locked
    themes = [
      0, // selected theme
      true, // default theme
      false, // blue theme
      false, // dark theme
      false, // original theme
    ];

    // initialize theme to default theme
    setUpTheme(0);
  }

  // retrieves user selection from Hive and translates theme data back to the app
  // Choice
  // used for determining user selected theme
  // choice 0 = default theme
  // choice 1 = blue theme
  // choice 2 = dark theme
  // choice 3 = beta theme
  //
  // themeData
  // stores Color data for themes
  // [0]  = AppBar, Floating action button, dialog add monthly energy button
  // [1]  = Background: Off white
  // [2]  = Appliance Tile (double off) : brown
  // [3]  = Appliance Tile (on) : yellow
  // [4]  = refresh button, add appliance button: blue
  // [5]  = dialog cancel button, PluggedInCheckbox color: Red
  // [6]  = Appliance Off Text color: white
  // [7]  = Power On/Off checkbox color
  // [8]  = Power on text color
  // [9]  = Power off text color
  // [10] = all other text color
  void setUpTheme(int choice) {
    if (choice == 0) {
      themeData = [
        // default theme
        Color.fromARGB(255, 63, 143,
            122), // [0] AppBar, Floating action button, dialog add monthly energy button
        Color.fromARGB(255, 251, 250, 246), // [1] Background
        Color.fromARGB(255, 203, 218, 214), // [2] Appliance Tile (double off)
        Color.fromARGB(255, 248, 214, 83), // [3] Appliance Tile (on)
        Colors.blue, // [4] refresh button, add appliance button: blue
        Colors.red, // [5] dialog cancel button, PluggedInCheckbox color
        Colors.white, // [6] Appliance Off Text color
        Colors.orange, // [7] Power On/Off checkbox color
        Colors.black, //[8] Power on text color
        Colors.black, // [9] Power off text color
        Colors.black, // [10] all other text color
      ];
      themes[0] = 0;
      _myBox.put("THEMES", themes);
    } else if (choice == 1) {
      themeData = [
        // blue theme
        Colors
            .blue, // [0] AppBar, Floating action button, dialog add monthly energy button: Light Green
        Colors.white, // [1] Background: Off white
        Colors.lightBlue, // [2] Appliance Tile (double off) : brown
        Colors.orange, // [3] Appliance Tile (on) : grey
        Colors.orange, // [4] refresh button, add appliance button: blue
        Colors.red, // [5] dialog cancel button: Red
        Colors.white, // [6] Appliance Off Text color: white
        Colors.orange, // [7] Power On/Off checkbox color
        Colors.white, //[8] Power on text color
        Colors.white, // [9] Power off text color
        Colors.black, // [10] all other text color
      ];
      themes[0] = 1;
      _myBox.put("THEMES", themes);
    } else if (choice == 2) {
      themeData = [
        // dark theme
        Color.fromARGB(220, 50, 56,
            21), // [0] AppBar, Floating action button, dialog add monthly energy button
        Colors.black, // [1] Background
        Color.fromARGB(220, 103, 116, 43), // [2] Appliance Tile (double off)
        Color.fromARGB(204, 194, 207, 130), // [3] Appliance Tile (on)
        Colors.orange, // [4] refresh button, add appliance button
        Colors.red, // [5] dialog cancel button: Red
        Colors.white, // [6] Appliance Off Text color: white
        Colors.orange, // [7] Power On/Off checkbox color
        Colors.white, //[8] Power on text color
        Colors.white, // [9] Power off text color
        Colors.white, // [10] all other text color
      ];
      themes[0] = 2;
      _myBox.put("THEMES", themes);
    } else if (choice == 3) {
      themeData = [
        // beta theme
        Colors
            .lightGreen, // [0] AppBar, Floating action button, dialog add monthly energy button
        Color.fromARGB(255, 253, 244, 231), // [1] Background
        Color.fromARGB(255, 156, 103, 84), // [2] Appliance Tile (double off)
        Colors.grey, // [3] Appliance Tile (on)
        Colors.blue, // [4] refresh button, add appliance button
        Colors.red, // [5] dialog cancel button, PluggedInCheckbox color
        Colors.white, // [6] Appliance Off Text color
        Colors.orange, // [7] Power On/Off checkbox color
        Colors.black, //[8] Power on text color
        Colors.white, // [9] Power off text color
        Colors.black, // [10] all other text color
      ];
      themes[0] = 3;
      _myBox.put("THEMES", themes);
    }
  }

  // load the data from database
  //   retrieves data from the Hive and updates class variables accordingly
  void loadData() {
    appList = _myBox.get("APPLIST");
    totalPoints = _myBox.get("TOTALPOINTS");
    userMonthElec = _myBox.get("USERMONTHELEC");
    graphNodeVals = _myBox.get("GRAPHNODEVALS");
    eBillNodeVals = _myBox.get("EBILLNODEVALS");
    expectedNodeVals = _myBox.get("EXPECTEDNODEVALS");
    graphStats = _myBox.get("GRAPHSTATS");
    graphSelection = _myBox.get("GRAPHSELECTION");
    themes = _myBox.get("THEMES");
    setUpTheme(themes[0]);

    // retrieve main graph line
    for (int i = 0; i < graphNodeVals.length; i++) {
      graphNode.add(FlSpot(
          graphNodeVals[i][0].toDouble(), graphNodeVals[i][1].toDouble()));
    }

    // retrieve eBill line
    for (int i = 0; i < eBillNodeVals.length; i++) {
      eBillNode.add(FlSpot(
          eBillNodeVals[i][0].toDouble(), eBillNodeVals[i][1].toDouble()));
    }

    // retrieve expected line
    for (int i = 0; i < expectedNodeVals.length; i++) {
      expectedNode.add(FlSpot(expectedNodeVals[i][0].toDouble(),
          expectedNodeVals[i][1].toDouble()));
    }
  }

  // update the database
  //    pushes data to the hive using updated
  //    applianceDatabase class variables
  void updateDatabase() {
    _myBox.put("APPLIST", appList);
    _myBox.put("TOTALPOINTS", totalPoints);
    _myBox.put("USERMONTHELEC", userMonthElec);
    _myBox.put("GRAPHNODEVALS", graphNodeVals);
    _myBox.put("EBILLNODEVALS", eBillNodeVals);
    _myBox.put("EXPECTEDNODEVALS", expectedNodeVals);
    _myBox.put("GRAPHSTATS", graphStats);
    _myBox.put("GRAPHSELECTION", graphSelection);
    _myBox.put("THEMES", themes);
    setUpTheme(themes[0]);
  }
}
