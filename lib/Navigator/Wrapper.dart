import 'package:driverapp/Authenticate/SignIn.dart';
import 'package:driverapp/Models/Customer.dart';
import 'package:driverapp/Screens/DriverView.dart';
import 'package:driverapp/Shared/Loading.dart';
import 'package:driverapp/States/DriverViewState.dart';
import 'package:driverapp/States/SignInState.dart';
import 'package:driverapp/States/UserDrawerState.dart';
import 'package:driverapp/States/appState.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String role;
  int n = 0;

  @override
  Widget build(BuildContext context) {






    dynamic user = Provider.of<FirebaseUser>(context); // acessing user data from


    if (user==null){
      // user not signed in
      return ChangeNotifierProvider.value(
          value: SignInState(),
          child: SignIn()
      );
    }
    else{
      if(n ==0){
        DriverViewState().ensureApprovedDriver().then((value){
          setState(() {
            print("value: $value");
            role = value;
          });
        });

      }


      print('role is : $role');
      // Bastard signed in!
      if(role !=null && role == "Driver"){
        setState(() {
          n=1;
        });
        return  MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: UserDrawerState()),
              //StreamProvider<List<LocationN>>.value(value:DataBase().DriverLocation()),
              StreamProvider<List<Customer>>.value(value:DriverViewState().customerDriver())

            ],
            child: DriverView()
        );
      }
      else{
        setState(() {
          n=1;
        });
        print("role null : $role");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
                "Driver request"
            ),
            centerTitle: true,
          ),
          body: Center(
            child:Text(
                "You need to apply to become our driver partner",
                style:TextStyle(
                    fontSize: 25
                )
            )
          )
        );
      }
    }


  }
}
