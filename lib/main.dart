import 'package:driverapp/Authenticate/Auth.dart';
import 'package:driverapp/LocationN.dart';
import 'package:driverapp/Models/Customer.dart';
import 'package:driverapp/Screens/DriverView.dart';
import 'package:driverapp/Screens/MyHomePage.dart';
import 'package:driverapp/Screens/messageCustomer.dart';
import 'package:driverapp/Shared/Database.dart';
import 'package:driverapp/States/DriverViewState.dart';
import 'package:driverapp/States/appState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Navigator/Wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      StreamProvider<FirebaseUser>.value(value:Auth().user)
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Wrapper(),//MyHomePage(title: 'Uber Clone'),
    );
  }
}



