
import 'package:driverapp/Authenticate/Auth.dart';
import 'package:driverapp/Models/Customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverViewState{


  // Gets orders for each customer on db
  List<Customer> _customers(QuerySnapshot snapshot){
    List<Customer> customers = [];
    Customer customer ;
    String custID;

    String shop;
    String orderNumber;
    String title;// so that i can access order later on
    //doc == each user
    snapshot.documents.forEach((doc) {

      // element == each order(for specific user) [number of orders]
      int n=0;
      int active =0;
      // for each order in document
      doc.data.values.forEach((value) {

        //place any restrictions here...

        if (value["active"] ==1 && value["checkOut"]=="Yes" && value["driverSeen"]==null) {
          n++;
          active ++;
          print("_________________Got in!!!!!!!!!!!");
          shop = value["shop"] ?? " ";
          orderNumber = value["orderNumber"] ?? "Pending";
          title = value["title"];


          custID = doc.documentID;



          if (n == 1) {

            customer = Customer(
                custId: custID,
                orderNumber: orderNumber,
                shop: shop

            );



          }
          customer.addOrderName(title);




        }

      });




      if(active>0) {
        if (customer != null) {
          print("Shop : ${customer.shop}");
          customers.add(customer);
        }
      }




    });
    return customers;

  }


  Stream<List<Customer>> customerDriver(){
    //returns snapshot of database and tells us of any changes [provider]
    return Firestore.instance.collection("OrdersRefined").snapshots().map(_customers);
  }

  Future customerSelected(String docId,List<String> titles) async{
    for(int i = 0;i<titles.length;i++){
      await Firestore.instance.collection("OrdersRefined").document(docId).updateData({
        "${titles[i]}.driverSeen":"Yes",
      },);
    }

  }

  Future<String>ensureApprovedDriver()async{
    print("Here");
    DocumentSnapshot doc;
    String role;
    dynamic uid = await Auth().inputData();
    print("There");
    doc= await  Firestore.instance.collection('Users').document(uid).get();
    role = doc.data['user'];

    print("role is :$role");
    return role;
  }














}