import 'package:flutter/material.dart';
import 'package:lettore_barcode/trasmissione.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Model {
  String firstName;
  String lastName;
  String email;
  String password;
  Model({this.firstName, this.lastName, this.email, this.password});
}

class ElencoLibri extends StatefulWidget {
  ElencoLibri({Key key}) : super(key: key);
  @override
  _ElencoLibriState createState() => new _ElencoLibriState();
}

class _ElencoLibriState extends State<ElencoLibri> {

  List<dynamic> libri = new List();
  int inizz = 1;
  String testoInput="...";
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  Model m = new Model(firstName: "adler");

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void trovaLibri() async{
    this.inizz=0;
    final http.Response l = await chiamaServerLibri();
    var ll = jsonDecode(l.body);
    setState(() {
      libri.addAll(ll);
    });
    print(libri.length);
  }

  void buttonPressed(){

    _formKey.currentState.save();
    print(m.firstName);
    setState(() {
      testoInput = m.firstName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(this.inizz==1) this.trovaLibri();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('App Name'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
          Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value){
                      m.firstName=value;
                  },
                ),
              ]
            ),
          ),
              Text("Autore"),
              TextField(
                  controller: myController,
                  decoration: InputDecoration(labelText: "Ciao"),
              ),

             RaisedButton(key:null,

                onPressed: buttonPressed,
                color: Colors.blueAccent,
                child: Text(
                  "BUTTON 1",
                  style: new TextStyle(
                      fontSize:12.0,
                      color: Colors.white,

                      fontFamily: "Roboto"),
                )
            ),
          ],
        ),
      ),
      body:
      new ListView(
          children: [
            Text(testoInput),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: elencoLibri(libri),
          )
      ]),

    );
  }
}
