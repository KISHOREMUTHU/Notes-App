import 'package:board_app/description_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


class CustomCard extends StatefulWidget {
    QuerySnapshot snap ;
    int index ;

   CustomCard({Key key, this.snap, this.index}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {

    var timeTodate = new DateTime.fromMillisecondsSinceEpoch(widget.snap.docs[widget.index]["timestamp"].seconds *1000);
    var dateFormatted =  DateFormat("EEEE , MMM  d, y ").format(timeTodate);
    var documentId =widget.snap.docs[widget.index].id;
    TextEditingController nameInputController = TextEditingController(text:widget.snap.docs[widget.index]['name']);
    TextEditingController titleInputController = TextEditingController(text:widget.snap.docs[widget.index]['title']);
    TextEditingController descriptionInputController = TextEditingController(text:widget.snap.docs[widget.index]['description']);

    return MaterialButton(
      onPressed:(){
         setState(() {
           //getData();
         });

       // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DescriptionPage()));

      },
      child: Column(
        children: [
          Container(
            height : 180,
            width : 390,
            child: Card(

              elevation : 10,
              child: Column(
                children: [
                  ListTile(
                    title : Text(widget.snap.docs[widget.index]["title"]),
                    subtitle :Text (widget.snap.docs[widget.index]["description"]),
                    leading : CircleAvatar(

                      radius : 34 ,
                      child : Text(widget.snap.docs[widget.index]["title"].toString()[0]),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("By : ${widget.snap.docs[widget.index]["name"]}"),

                        Text(dateFormatted),
                      ],
                    ),
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.start,
                      children : [
                      IconButton(
                          icon:Icon(
                          FontAwesomeIcons.edit,
                          size : 15,),
                          onPressed: () async {
                            await showDialog(
                              context:context,
                              child : AlertDialog (
                                contentPadding : EdgeInsets.all(10),
                                content : Column(
                                  children : [
                                    Text ("Update Your Form !!"),
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
                                         FirebaseFirestore.instance.collection("board").doc(documentId).update({
                                           "name" : nameInputController.text,
                                           "title":titleInputController.text,
                                           "description" : descriptionInputController.text,
                                           "timestamp":new DateTime.now(),
                                         }).then((response){
                                          // print(response.id);
                                           Navigator.pop(context);

                                           nameInputController.clear();
                                           titleInputController.clear();
                                           descriptionInputController.clear();


                                         }).catchError((error){
                                           print ( 'Error');
                                         });

                                      }

                                    },
                                    child :Text('Update'),
                                  ),

                                ],
                              ),
                            );
                          }
                          ) ,
                        SizedBox(height: 20),
                        IconButton(
                            icon:Icon(
                              FontAwesomeIcons.trashAlt,
                              size : 15,),
                            onPressed: () async{
                              var collect = FirebaseFirestore.instance.collection("board");
                              await collect.doc(documentId).delete();
                               print(documentId);
                            }
                        ) ,
                      ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
