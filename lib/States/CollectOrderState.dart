import 'package:cloud_firestore/cloud_firestore.dart';
class CollectOrderState{


  Future orderCollected(String docId,List<String> titles) async{

    for(int i =0;i<titles.length;i++){
      Firestore.instance.collection("OrdersRefined").document(docId).updateData({
        "${titles[i]}.orderCollected":"Yes",
      },);
    }


  }









}