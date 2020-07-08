import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class OrderManagement{

  getOrder()async{
    return await Firestore.instance.collection('PlaceOrder').snapshots();
  }

  getUserList(String id)async{
    return await Firestore.instance.collection('UserRecentList').document(id).collection('CurrentList').snapshots();
  }

  updateData(selectedDoc,newValues){
       Firestore.instance.collection('PlaceOrder').document(selectedDoc).updateData(newValues).catchError((e){
         print(e);
       });
    }

}