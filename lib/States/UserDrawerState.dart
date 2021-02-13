import 'package:driverapp/Authenticate/Auth.dart';
import 'package:driverapp/Models/Driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class UserDrawerState with ChangeNotifier {




  String name;
  String email;



  UserDrawerState() {
    DriverInfo();
    //validPromo = "";
  }




  Future<Driver> DriverInfo() async {
    String uid = await Auth().inputData();
    return await Firestore.instance.collection("Users")
        .document(uid)
        .snapshots()
        .forEach((element) {
      //print(element.data["email"]);
      Driver driver = Driver(
          name: element.data["name"],
          email: element.data["email"]
      );
      name = element.data["name"];
      email = element.data["email"];
      return driver;
    });
  }


  }







