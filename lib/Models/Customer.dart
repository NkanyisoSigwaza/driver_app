
class Customer{

  String custId;
  String orderNumber;
  String shop;
  List<String> orderNames = [];


  Customer({this.custId,this.orderNumber,this.shop});


  addOrderName(String name){
    orderNames.add(name);
  }


}