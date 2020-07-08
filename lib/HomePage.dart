import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'OrderManagement.dart';
import 'package:intl/intl.dart';
import 'Details.dart';

class HomePage extends StatefulWidget {
  @override
   _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  OrderManagement _orderManagement = new OrderManagement();
  Stream placedOrder;

  getOrders(){
    _orderManagement.getOrder().then((result){
      setState(() {
         placedOrder = result;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getOrders();
  }
  
   @override
   Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('DeliveryPartner'),
       ),
       body: orders()
    );
  }

   Widget orders(){
    if(placedOrder != null){
      return Column(
        children: <Widget>[
          Expanded(
            child :  StreamBuilder(
          stream: placedOrder,
          builder: (context,snapshot){
            return ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context,i){
                  return Card(
                 child: ListTile(
              title: Text(snapshot.data.documents[i].data['userId']),
              onTap: (){
              var now = new DateTime.now();
              var format = new DateFormat('HH:mm a');
              var date = DateTime.fromMillisecondsSinceEpoch(snapshot.data.documents[i].data['timestamp'], isUtc: true);
              var diff = date.difference(now);
              var time = '';

              if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
                time = format.format(date);
              } else {
                if (diff.inDays == 1) {
                  time = diff.inDays.toString() + 'DAY AGO';
                } else {
                  time = diff.inDays.toString() + 'DAYS AGO';
                }
              }
              print(time);
              navigateToDetails(snapshot.data.documents[i].data['userId'], time,snapshot.data.documents[i].documentID);
              },
            ),
                );
              },
            );
          },
        ),
      ),
      
     ],
      );
    }
    else{
      return Text('Loading. Please Wait for a second.....');
    }
  }

  navigateToDetails(String id,String currentTime,String docID){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Details(userId:id,time:currentTime,docId: docID),));
  }
  
} 