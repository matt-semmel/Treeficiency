import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:treefficiency/data/database.dart';

// retrieves main graph line values from hive
// if no values present, sets graph to 1 node at (0,0)
List<FlSpot> setGraphSpots(applianceDataBase db) {
  if (db.graphNode.length == 0) {
    return [FlSpot(0, 0)];
  }

  return db.graphNode;
}

// retrieves monthly average line values from hive
// if no values present, sets graph to 1 node at (0,0)
List<FlSpot> setEbillSpots(applianceDataBase db) {
  if (db.eBillNode.length == 0) {
    return [FlSpot(0, 0)];
  }

  return db.eBillNode;
}

// retrieves expected average line values from hive
// if no values present, sets graph to 1 node at (0,0)
List<FlSpot> setExpectedSpots(applianceDataBase db) {
  if (db.expectedNode.length == 0) {
    return [FlSpot(0, 0)];
  }

  return db.expectedNode;
}

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphssPageState();
}

class _GraphssPageState extends State<GraphsPage> {
  final TextEditingController colorController = TextEditingController();
  bool? eBillCheck;
  bool? expectedCheck;

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments
        as Map<String, applianceDataBase>;
    final db = routeArgs['db'];
    eBillCheck = db!.graphSelection[2];
    expectedCheck = db!.graphSelection[3];
    return Scaffold(
      backgroundColor: db!.themeData[1],
      appBar: AppBar(
        backgroundColor: db!.themeData[0],
        centerTitle: false,
        toolbarHeight: 80,
        title: Container(
          child: Row(
            children: [
              Text(
                "Energy Usage  ",
              ),
              Icon(Icons.auto_graph_rounded),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              Spacer(),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Graph Info  '),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: db.themeData[1],
                        title: Container(
                            child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: db.themeData[4],
                              size: 35,
                            ),
                            Text(
                                style: TextStyle(
                                  color: db.themeData[10],
                                ),
                                '  Graph Info'),
                          ],
                        )),
                        content: Text(
                          style: TextStyle(
                            color: db.themeData[10],
                          ),
                          'Energy is logged with each action within the app. \n\n'
                          '-- \'Electric Bill Average\' will show the rate of energy consumption that would have occurred during a regular month given user submitted monthly info.\n\n'
                          '-- \'Expected Average\' will predict the rate of energy consumption given power cycling data already processed.\n\n'
                          'These values can help you keep track of when electricity consumption is spiking throughout the month',
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
                },
                child: Icon(
                  Icons.info,
                  color: db!.themeData[4],
                  size: 35,
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  style: TextStyle(color: db.themeData[10], fontSize: 20),
                  db.graphStats[11].toString()),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  // Expected avg Line
                  LineChartBarData(
                    show: expectedCheck!,
                    spots: setExpectedSpots(db),
                    isCurved: false,
                    dotData: FlDotData(show: true),
                    color: Colors.purple,
                    barWidth: 5,
                  ),
                  // Recorded Energy Line
                  LineChartBarData(
                    show: db.graphStats[8],
                    spots: setGraphSpots(db),
                    isCurved: false,
                    dotData: FlDotData(show: true),
                    color: db!.themeData[4],
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      color: db!.themeData[4].withOpacity(0.7),
                    ),
                  ),
                  // eBill Avg Line
                  LineChartBarData(
                    show: eBillCheck!,
                    spots: setEbillSpots(db),
                    isCurved: false,
                    dotData: FlDotData(show: true),
                    color: db!.themeData[5],
                    barWidth: 5,
                  ),
                ],
                minX: db.graphStats[0],
                maxX: db.graphStats[1],
                minY: db.graphStats[2],
                maxY: db.graphStats[3],
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval: db.graphStats[5],
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                        style: TextStyle(
                          color: db.themeData[10],
                        ),
                        db.graphStats[6].toString()),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: db.graphStats[4],
                      getTitlesWidget: (value, meta) {
                        return Text(
                            style: TextStyle(
                              color: db.themeData[10],
                            ),
                            value.toStringAsFixed(0));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                        style: TextStyle(
                          color: db.themeData[10],
                        ),
                        db.graphStats[7].toString()),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                            style: TextStyle(
                              color: db.themeData[10],
                            ),
                            value.toString());
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  verticalInterval: db.graphStats[4] / 2,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: db!.themeData[3], strokeWidth: 0.5),
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) => FlLine(
                    color: db!.themeData[3],
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: db!.themeData[3],
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Checkbox(
                value: eBillCheck,
                activeColor: db.themeData[5],
                onChanged: (bool? value) {
                  setState(() {
                    if (db.userMonthElec[3] == 0) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: db.themeData[1],
                            content: Text(
                              style: TextStyle(
                                color: db.themeData[10],
                              ),
                              '\nThe Monthly Average Energy Consumption Rate can only be calculated after submitting monthly energy info on the home screen.',
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
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
                    } else {
                      db.graphSelection[2] = value;
                      eBillCheck = value;
                    }
                  });
                },
              ),
              Text(
                  style: TextStyle(color: db.themeData[10]),
                  'Electric Bill Average'),
              Checkbox(
                value: expectedCheck,
                activeColor: Colors.purple,
                onChanged: (bool? value) {
                  setState(() {
                    if (db.graphNodeVals.length <= 1) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: db.themeData[1],
                            content: Text(
                              style: TextStyle(
                                color: db.themeData[10],
                              ),
                              '\nAt least 2 energy nodes must exist to calculate the expected average energy consumption rate.',
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
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
                    } else {
                      db.graphSelection[3] = value;
                      expectedCheck = value;
                    }
                  });
                },
              ),
              Text(
                  style: TextStyle(color: db.themeData[10]),
                  'Expected Average'),
              Spacer(),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
