import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:deliverypartner/Services/OrderManagement.dart';
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
      backgroundColor: Colors.blueAccent,
       body: Stack(
         children: <Widget>[
           Positioned(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text("Delivery Partner", style: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat')),
                 ),
              ),
               SizedBox(height: 50),
              Positioned(
                top: 80.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  height: MediaQuery.of(context).size.height - 50.0,
                  width: MediaQuery.of(context).size.width,
                )
              ),
              orders()
         ],
       )
        
    );
  }

   Widget orders(){
    if(placedOrder != null){
      return Column(
        children: <Widget>[
          Container(
                height: 100.0,
              ),
          Expanded(
            child :  StreamBuilder(
          stream: placedOrder,
          builder: (context,snapshot){
            return (snapshot.data.documents.length == null)? CircularProgressIndicator():ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context,i){
                  return Card(
                    elevation: 7.0,
                 child: ListTile(
                    title: Text("ORDER ID: ",style: TextStyle(fontWeight: FontWeight.bold,)),
                    subtitle: Text(snapshot.data.documents[i].data['userId']),
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
                    navigateToDetails(snapshot.data.documents[i].data['userId'], time,snapshot.data.documents[i].documentID,snapshot.data.documents[i].data['total']);
                    },
                    trailing: snapshot.data.documents[i].data['delivered'] ? OutlineButton(
                        onPressed: null,
                        child: Text("Delivered", style: TextStyle(color: Colors.green),),
                        color: Colors.green,
                        
                      )
                    
                    :OutlineButton(
                      onPressed: null,
                      child: Text("Not Delivered", style: TextStyle(color: Colors.red),),
                      color: Colors.red,
                      highlightedBorderColor: Colors.red,
                      highlightColor: Colors.red,
                    ),
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

  navigateToDetails(String id,String currentTime,String docID,int total){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Details(userId:id,time:currentTime,docId: docID,total: total,),));
  }
  
} 