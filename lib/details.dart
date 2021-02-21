import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_app/customcard.dart';
import 'package:board_app/description_page.dart';

class Details extends StatelessWidget {
  final QuerySnapshot snap ;
  final int index ;

  const Details({Key key, this.snap, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child : Text(snap.docs[index]['title']),
    );
  }
}
