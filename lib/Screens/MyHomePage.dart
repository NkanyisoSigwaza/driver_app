import 'dart:typed_data';

import 'package:driverapp/LocationN.dart';
import 'package:driverapp/Models/Customer.dart';
import 'package:driverapp/Screens/DriverView.dart';
import 'package:driverapp/Screens/messageCustomer.dart';
import 'package:driverapp/Shared/Database.dart';
import 'package:driverapp/States/appState.dart';
import 'package:driverapp/States/messageCustomerState.dart';
import 'package:driverapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';


import 'package:google_maps_flutter/google_maps_flutter.dart';


class MyHomePage extends StatefulWidget {
  final String title;
  final String custId;
  final Customer customer;


  MyHomePage({this.title,this.custId,this.customer});


  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int directionsApi =0;

  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    print("_________LENGTH_____________");

    if (appState.markers.length >2){
      appState.markers.clear();
    }


    return appState.initialPosition == null
        ? Container(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    )
        : StreamBuilder(
      stream: DataBase().customerLocation(widget.custId),
      builder: (context,snapshot) {

    try{


      appState.getAdress(snapshot.data.lat, snapshot.data.long);
      print(appState.destinationController.text);
      if(directionsApi==0){
        appState.sendRequest(snapshot.data.lat,snapshot.data.long);
        directionsApi++;
      }

      appState.markers.add(
          Marker(
            markerId:MarkerId("Customer"),// where user is currently at
            position: LatLng(snapshot.data.lat,snapshot.data.long),
            infoWindow: InfoWindow(    //just adds more info
                title:"Driver",
                snippet: "Delivering Order"

            ),
            icon:BitmapDescriptor.defaultMarker,  // just the default marker icon
          )
      );



    }
    catch(e){
      print("______________________No data from db__________________ $e");
    }


        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: appState.initialPosition,
                  zoom: 10,
                ),
                mapType: MapType.normal,
                onMapCreated: appState.onCreated,
                //created method onCreated ourselves. What should happen when map is created?
                myLocationEnabled: true,
                //Will get back current location of user
                compassEnabled: true,
                // will show you direction of north, south etc
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                //
                polylines:
                appState.polyLines, // Own method, will draw lines onto map
              ),
              Positioned(
                top: 50.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: appState.locationController,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "pick up",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 105.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: appState.destinationController,
                    textInputAction: TextInputAction
                        .go,
                    // main action on keyboard, we want it to write go
//                    onSubmitted: (value) {
//                      //appState.sendRequest(value);
//                    },
                    onTap: () async {
                      // appState.autoComplete(context);

                      Prediction p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: "AIzaSyASIYsed8JC-nUwfXfUKXpMoxYykp3KrU4",
                          language: "en",
                          components: [Component(Component.country, "za")]
                      );
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        width: 10,
                        height: 10,
                        child: Icon(
                          Icons.local_taxi,
                          color: Colors.black,
                        ),
                      ),
                      hintText: "destination?",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left:130,
                child: FlatButton(
                  color:Colors.black,
                    onPressed: (){
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => messageCustomer(customerUid: widget.custId,)
                            )
                        );
                      });
                    },
                    child: Text(
                        "Message Cutsomer",
                      style: TextStyle(
                        color:Colors.white
                      ),
                    )
                ),
              ),
              Positioned(
                bottom: 0,
                left:130,
                child: FlatButton(
                  child:Text(
                      "Order Completed"),
                  color: Colors.green,
                  onPressed: ()async{
                    await messageCustomerState().deleteMessages(widget.custId);


                      await DataBase().orderDelivered(widget.custId, widget.customer.orderNames);

                    setState(() {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApp()
                          )
                      );

                    });

                  },
                ),
              )

            ],
          ),
        );

      }
    );
  }
}


