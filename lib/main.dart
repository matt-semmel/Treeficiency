//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:treefficiency/pages/add_appliance_page.dart';
import 'package:treefficiency/pages/graphs_page.dart';
import 'package:treefficiency/pages/home_page.dart';
import 'package:treefficiency/pages/rewards_page.dart';
import 'package:treefficiency/pages/settings_page.dart';
import 'package:treefficiency/pages/tips_page.dart';
import 'package:treefficiency/pages/login_page.dart';
import 'package:treefficiency/pages/leaderboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

Future main() async {
  // init the hive (local storage)
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox('mybox');

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'Treefficiency',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // call authStateChanges() to check if user is logged in
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  // END QUERING FIREBASE DATABASE FOR LEADERBOARD

  runApp(const Treefficiency());
}

class Treefficiency extends StatelessWidget {
  const Treefficiency({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthService().handleAuthState(),
        // initialRoute: '/loginpage',
        routes: {
          '/loginpage': (context) => LoginPage(),
          '/homepage': (context) => HomePage(),
          '/graphspage': (context) => GraphsPage(),
          '/addappliancepage': (context) => AddAppliancePage(),
          '/tipspage': (context) => TipsPage(),
          '/settingspage': (context) => SettingsPage(),
          '/rewardspage': (context) => RewardsPage(),
          '/leaderboard': (context) => LeaderboardPage(),
        });
  }
}
