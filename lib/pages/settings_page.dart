import 'package:flutter/material.dart';
import 'package:treefficiency/data/database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                "Settings  ",
              ),
              Icon(Icons.settings),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 7),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    db!.createInitialData();
                    setState(() {});
                  },
                  child: Text('RESET')),
              SizedBox(width: 5),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Reset Databases'),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 7),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {},
                  child: Text('LOGOUT')),
              SizedBox(width: 5),
              Text(
                  style: TextStyle(
                    color: db.themeData[10],
                  ),
                  'Logout'),
            ],
          ),
        ],
      ),
    );
  }
}
