
import 'package:driverapp/Shared/Constants.dart';
import 'package:driverapp/States/messageCustomerState.dart';
import 'package:flutter/material.dart';
class messageCustomer extends StatefulWidget {

  dynamic customerUid;


  messageCustomer({this.customerUid});
  @override
  _messageCustomerState createState() => _messageCustomerState();
}

class _messageCustomerState extends State<messageCustomer> {
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("Hi there!");
    print(widget.customerUid);
    return widget.customerUid == null ?  CircularProgressIndicator(
        value:10
    ):
    StreamBuilder(

        stream:messageCustomerState().Messages(widget.customerUid),
        builder:( BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);

          if (!snapshot.hasData) {
            print("No data");
            return Scaffold(
                appBar: AppBar(
                  title:Text("Messages"),
                  centerTitle: true,
                  backgroundColor: Colors.black,
                ),
              body:Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      "No messages :)",
                      style: TextStyle(
                        fontSize: 30
                      ),
                    ),
                  ),
//                  Container(
//                    height:500
//                  ),
                  TextFormField(
                    controller: message,
                    decoration: textInputDecoration,

                  ),
                  FlatButton(
                    child: Text(
                      "Send!",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    color: Colors.black,
                    onPressed: () async {

                      await messageCustomerState().sendDriverMessage(message.text,widget.customerUid);
                      setState(() {
                        message.text = "";
                      });


                    },
                  ),
                ],
              )
            );

          }
          return Scaffold(
            resizeToAvoidBottomInset : false, // avoids overflowing at the bottom when keyboard shows
            appBar: AppBar(
              title:Text("Messages"),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height:500,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,


                      itemBuilder: (context, index) {
                        return Card(
                          child:snapshot.data[index].from=="Customer"? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text(
                                  snapshot.data[index].message,
                                  style: TextStyle(
                                      color:Colors.red,
                                      fontSize: 20

                                  ),
                                ),
                                Text(
                                  snapshot.data[index].time.toDate().toString().substring(10,16),
                                  style: TextStyle(
                                      color:Colors.grey
                                  ),
                                ),

                              ],
                            ),
                          ) :Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    snapshot.data[index].message,
                                    style:TextStyle(
                                        fontSize: 18
                                      //color:Colors.green
                                    )
                                ),
                                Text(
                                  snapshot.data[index].time.toDate().toString().substring(10,16),
                                  style: TextStyle(
                                      color:Colors.grey[300]
                                  ),
                                ),

                              ],


                            ),
                          )



                        );
                      }
                  ),
                ),
                TextFormField(
                  controller: message,
                  decoration: textInputDecoration,

                ),
                FlatButton(
                  child: Text(
                    "Send!",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  color: Colors.black,
                  onPressed: () async {

                    await messageCustomerState().sendDriverMessage(message.text,widget.customerUid);
                    setState(() {
                      message.text = "";
                    });


                  },
                ),

              ],
            ),
          );

        }
    );
  }
  }

