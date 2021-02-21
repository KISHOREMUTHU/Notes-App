import 'package:board_app/customcard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BoardApp extends StatefulWidget {
  @override
  _BoardAppState createState() => _BoardAppState();
}

class _BoardAppState extends State<BoardApp> {
  var firestoreDb = FirebaseFirestore.instance.collection('board').snapshots();
  TextEditingController nameInputController ;
  TextEditingController titleInputController ;
  TextEditingController descriptionInputController ;


  @override
  void initState() {
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descriptionInputController = TextEditingController();


  } // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar (
        title : Text ('Boards App'),
      ),
      floatingActionButton:FloatingActionButton (
        onPressed: (){
_showDialog(context);
        },
        child: Icon(FontAwesomeIcons.pencilAlt),
      ),
      body : StreamBuilder(

        stream : firestoreDb,
        builder : (context ,snapshot){
               if (!snapshot.hasData){
                 return CircularProgressIndicator(

                 );
               }
               else {
                 return ListView.builder(
                   itemCount: snapshot.data.docs.length,
                   itemBuilder: (context , int index){
                     //return Text(snapshot.data.docs[index]['title']);
                     return CustomCard(snap : snapshot.data, index : index);
                   },);
               }
        },
      ),
    );
  }

  _showDialog(BuildContext context )async{
    await showDialog ( context : context ,
        child : Container(

          child: AlertDialog(
            contentPadding: EdgeInsets.all(10),
            content : Container(
              width : double.maxFinite ,
              height : 300,
              child: Column(
                children : [
                  Text ( ' Please enter some details !! '),
                  SizedBox(height: 20),
                  Expanded(
                    child : TextField(
                      autofocus :true,
                      autocorrect : true,
                      decoration: InputDecoration(
                        labelText : 'Your Name*',

                      ),
                      controller :nameInputController,
                    ),
                  ),
                  Expanded(
                    child : TextField(
                      autofocus :true,
                      autocorrect : true,
                      decoration: InputDecoration(
                        labelText : 'Title*',

                      ),
                      controller :titleInputController,
                    ),
                  ),
                  Expanded(
                    child : TextField(
                      autofocus :true,
                      autocorrect : true,
                      decoration: InputDecoration(
                        labelText : 'Description*',

                      ),
                      controller :descriptionInputController,
                    ),
                  ),

                ],
              ),
            ),
            actions:[
              FlatButton(
                onPressed : (){
                  nameInputController.clear();
                  titleInputController.clear();
                  descriptionInputController.clear();
                  Navigator.pop(context);

                },
                child :Text('Cancel'),
              ),
              FlatButton(
                onPressed : (){
                  if(titleInputController.text.isNotEmpty && nameInputController.text.isNotEmpty && descriptionInputController.text.isNotEmpty){
                    FirebaseFirestore.instance.collection("board").add({
                      "name" : nameInputController.text,
                      "title":titleInputController.text,
                      "description" : descriptionInputController.text,
                      "timestamp":new DateTime.now(),
                    }).then((response){
                      print(response.id);
                      Navigator.pop(context);

                      nameInputController.clear();
                      titleInputController.clear();
                      descriptionInputController.clear();


                    }).catchError((error){
                      print ( 'Error');
                    });
                  }

                },
                child :Text('Save'),
              ),

            ],
          ),
        ),);
  }
}
