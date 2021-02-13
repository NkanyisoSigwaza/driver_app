import 'package:driverapp/Models/Customer.dart';
import 'package:driverapp/Screens/CollectOrder.dart';
import 'package:driverapp/Shared/Database.dart';
import 'package:driverapp/Shared/UserDrawer.dart';
import 'package:driverapp/States/DriverViewState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverView extends StatefulWidget {
  @override
  _DriverViewState createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<List<Customer>>(context);

    return customers ==null ? Scaffold(
      appBar: AppBar(
        title:Text("Orders"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          "No orders yet",
            style:TextStyle(
                fontSize: 20
            )

        ),
      ),
    ):Scaffold(
      drawer: UserDrawer(),
      appBar: AppBar(
        title:Text("Orders"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: customers.length,
          itemBuilder: (context,index){
          print(customers[index].shop);
            return Padding(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(
                    'Order $index',
                  style:TextStyle(
                    fontSize: 20
                  )
                ),
                subtitle: Text(
                    customers[index].shop ?? " ",
                    style:TextStyle(
                        fontSize: 18
                    )
                ),
                onTap: ()async{

                    await DriverViewState().customerSelected(customers[index].custId,customers[index].orderNames);



                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CollectOrder(
                              customer: customers[index],
                            )

                              )
                    );

                  });
                },
              ),
            );

          }),
    );
  }
}
