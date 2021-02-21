import 'package:board_app/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_app/customcard.dart';
import 'package:board_app/board_app.dart';

class DescriptionPage extends StatelessWidget {

  final QuerySnapshot snap ;
  final int index ;

  const DescriptionPage({Key key, this.snap, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var firestoreDb = FirebaseFirestore.instance.collection('board').snapshots();

    return Scaffold(
      appBar:AppBar(
        title : Text('Description Page'),
      ),
      body: StreamBuilder(
        stream: firestoreDb,
        builder: (context, snapshot) {
    if (!snapshot.hasData){
         return CircularProgressIndicator(

    );
    }
    else {
          return ListView.builder(
    itemCount: snapshot.data.docs.length,
    itemBuilder: (context , int index){

            return Text(snap.docs[index]['']);
    },);
        }}
      ),
    );
  }
}
