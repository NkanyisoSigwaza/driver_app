import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driverapp/LocationN.dart';
import 'package:driverapp/Models/Customer.dart';
import 'package:firebase_core/firebase_core.dart';



class DataBase{
  LocationN location;
  LocationN _locationFromSnapshot(DocumentSnapshot snapshot){
    location = LocationN(
      lat:snapshot.data["latitude"],
      long: snapshot.data["longitude"]
    );

    return location;

  }




  // Returns user location

  Stream<LocationN> customerLocation(String custId){

    return Firestore.instance.collection("Location").document(custId).snapshots().map(_locationFromSnapshot);
  }







  Future orderDelivered(String docId,List<String> titles) async{
    for(int i=0;i<titles.length;i++){
      await Firestore.instance.collection("OrdersRefined").document(docId).updateData({
        "${titles[i]}.active":0,
      },);
    }

  }

  Future loadLocation(double latitude,double longitude,String uid)async{
    return await Firestore.instance.collection("Location").document(uid).setData({


      "latitude":latitude,
      "longitude":longitude,

    });

  }



}