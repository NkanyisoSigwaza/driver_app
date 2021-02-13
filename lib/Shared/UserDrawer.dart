import 'package:driverapp/Authenticate/Auth.dart';
import 'package:driverapp/Models/Driver.dart';
import 'package:driverapp/Navigator/Wrapper.dart';
import 'package:driverapp/States/UserDrawerState.dart';
import 'package:driverapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}


class _UserDrawerState extends State<UserDrawer> {
  Driver driver;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserDrawerState().DriverInfo().then((value){
      driver = value;

    });
  }

  @override
  Widget build(BuildContext context) {
    final userDrawerState = Provider.of<UserDrawerState>(context);

    return Container(
      margin: EdgeInsets.only(right:80),
      color:Colors.grey[800],
      child: ListView(
        children: <Widget>[
          Container(


            height:300,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),


              accountName: Padding(
                padding: const EdgeInsets.only(bottom:12),
                child: Text(
                    userDrawerState.name ?? "Nah"
                ),
              ),
              accountEmail: Text(
                  userDrawerState.email ?? "Nah"
              ),
              currentAccountPicture:CircleAvatar(
                radius:50,
                backgroundImage:AssetImage("Picture/avatar.png") ,
                backgroundColor: Colors.grey[400],


              ),
            ),
          ),

          ListTile(
            title:Text(
              "Sign out",
              style: TextStyle(
                  color:Colors.red
              ),
            ),
            onTap: (){
              Auth().signOut();
              Navigator.of(context).pop();//closes menu in home pAGE
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp())
              );
            },
          ),
          Divider(
            height:5,
            color:Colors.black,
          ),




        ],
      ),
    );
  }
}
