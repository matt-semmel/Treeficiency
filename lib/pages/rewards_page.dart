import 'package:flutter/material.dart';
import 'package:treefficiency/data/database.dart';
//import 'package:treefficiency/data/database.dart';
//import 'package:treefficiency/util/notify.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments
        as Map<String, applianceDataBase>;
    final db = routeArgs['db'];
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
                " Rewards  ",
              ),
              Icon(Icons.wallet_giftcard_rounded),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 9),
          Row(
            // ---------------------------------------------------------------------- Tree Point Counter
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 7),
              GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/images/tree.png',
                  height: 30,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  "Tree Points: " + db!.totalPoints[1].toStringAsFixed(2)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 3),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(220, 34, 134, 138)),
                  onPressed: () {
                    setState(() {
                      db.setUpTheme(0);
                    });
                  },
                  child: Text('  REDEEMED  ')),
              SizedBox(width: 5),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Change Theme: DEFAULT'),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 3),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (db.themes[2] == true) {
                      setState(() {
                        db.setUpTheme(1);
                      });
                    } else if (db.totalPoints[1] > 50) {
                      db.totalPoints[1] -= 50;
                      db.themes[2] = true;
                      db.setUpTheme(1);
                      setState(() {});
                    }
                  },
                  child: Text(db.themes[2] ? '  REDEEMED  ' : 'COST: 50pts  ')),
              SizedBox(width: 5),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Change Theme: BLUE'),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 3),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(220, 50, 56, 21)),
                  onPressed: () {
                    if (db.themes[3] == true) {
                      setState(() {
                        db.setUpTheme(2);
                      });
                      return;
                    } else if (db.totalPoints[1] > 100) {
                      db.totalPoints[1] -= 100;
                      db.themes[3] = true;
                      db.setUpTheme(2);
                      setState(() {});
                    }
                  },
                  child: Text(db.themes[3] ? '  REDEEMED  ' : 'COST: 100pts')),
              SizedBox(width: 5),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Change Theme: OLIVE'),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 3),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen),
                  onPressed: () {
                    if (db.themes[4] == true) {
                      setState(() {
                        db.setUpTheme(3);
                      });
                      return;
                    } else if (db.totalPoints[1] > 200) {
                      db.totalPoints[1] -= 200;
                      db.themes[4] = true;
                      db.setUpTheme(3);
                      setState(() {});
                    }
                  },
                  child: Text(db.themes[4] ? '  REDEEMED  ' : 'COST: 200pts')),
              SizedBox(width: 5),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Change Theme: BETA'),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 3),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    db.totalPoints[1] += 1000;
                    setState(() {});
                  },
                  child: Text('GET: 1000pts')),
              SizedBox(width: 5),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Test Rewards: (Receive 1000 tree points)'),
            ],
          ),
        ],
      ),
    );
  }
}
