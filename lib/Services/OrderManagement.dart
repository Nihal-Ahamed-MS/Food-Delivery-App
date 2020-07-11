import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class OrderManagement{

  Firestore ref = Firestore.instance;

  getOrder()async{
    return await ref.collection('PlaceOrder').orderBy('delivered',descending: false).snapshots();
  }

  getUserList(String id)async{
    return await ref.collection('UserRecentList').document(id).collection('CurrentList').snapshots();
  }

  updateData(selectedDoc,newValues){
       ref.collection('PlaceOrder').document(selectedDoc).updateData(newValues).catchError((e){
         print(e);
       });
    }

}