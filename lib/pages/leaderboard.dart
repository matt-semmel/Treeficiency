import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:treefficiency/data/database.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Map<String, applianceDataBase?> routeArgs;
  late applianceDataBase? db;
  List<Map<String, dynamic>> leaderboardData = [];
  late String currentUserEmail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, applianceDataBase?>;

    if (routeArgs != null) {
      db = routeArgs['db'];
      currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

      // Fetch leaderboard data
      fetchLeaderboardData();

      // USE THIS FORMAT TO ADD USER TREE DATA TO THE CLOUD!!!!!!!!!!!!
      if (db != null) {
        double user_trees = db!.totalPoints[1];
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference energyInfo = FirebaseFirestore.instance.collection('energyInfo');

        var user_energy = {
          'full_name': FirebaseAuth.instance.currentUser!.displayName!,
          'trees': user_trees,
          'email': FirebaseAuth.instance.currentUser!.email!,
        };

        energyInfo.doc(FirebaseAuth.instance.currentUser!.email!).set(user_energy);
      }
    } else {
      // Handle the case where routeArgs is null
    }
  }

  // Fetch leaderboard data from Firestore
  Future<void> fetchLeaderboardData() async {
    try {
      var fireDb = FirebaseFirestore.instance;
      final energyInfo = fireDb.collection("energyInfo");

      // Modify the query to order by the "trees" field
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await energyInfo.orderBy("trees", descending: true).limit(10).get();

      // Iterate through documents and add data to the list
      leaderboardData = querySnapshot.docs.map((doc) => doc.data()).toList();

      // Update the UI with the new data
      setState(() {});

    } catch (error) {
      print("Error fetching leaderboard data: $error");
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: db?.themeData[0] ?? Colors.blue, // Set app bar color
      ),
      body: Center(
        child: leaderboardData.isEmpty
            ? CircularProgressIndicator() // Show a loading indicator while data is being fetched
            : ListView.builder(
                itemCount: leaderboardData.length,
                itemBuilder: (context, index) {
                  var entry = leaderboardData[index];
                  bool isCurrentUser = entry['email'] == currentUserEmail;

                  return ListTile(
                    title: Text(
                      entry['full_name'].split(' ')[0],
                      style: TextStyle(
                        color: isCurrentUser ? Colors.green : db?.themeData[10] ?? Colors.black,
                        fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      'Trees: ${entry['trees'].toStringAsFixed(0)}',
                      style: TextStyle(
                        color: isCurrentUser ? Colors.green : db?.themeData[10] ?? Colors.black,
                        fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
      ),
      backgroundColor: db?.themeData[1] ?? Colors.white, // Set background color
    );
  }
}
