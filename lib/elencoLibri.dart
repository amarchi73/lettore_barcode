import 'package:flutter/material.dart';
import 'package:lettore_barcode/trasmissione.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Model {
  String firstName;
  String lastName;
  String email;
  String password;
  List<String> autori;
  Model({this.firstName, this.lastName, this.email, this.password, this.autori});
}

class ElencoLibri extends StatefulWidget {
  ElencoLibri({Key key}) : super(key: key);
  @override
  _ElencoLibriState createState() => new _ElencoLibriState();
}

class _ElencoLibriState extends State<ElencoLibri> {

  List<dynamic> libri = new List();
  List<dynamic> autori = new List();
  int inizz = 1;
  int cerca = 0;
  String testoInput="";
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  Model m = new Model(firstName: "adler", autori: new List());

  @override
  void initState(){
      super.initState();
      myController.addListener(ricercaDiretta);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void ricercaDiretta() async{
      final http.Response l = await chiamaServerLibri("/titolo", myController.text);
      var ll = jsonDecode(l.body);
      setState(() {
        libri.clear();
        libri.addAll(ll);
      });
      print(libri.length);
  }
  void ricercaAutori() async{
    final http.Response l = await chiamaServerLibri("/autore", m.autori.join(","));
    var ll = jsonDecode(l.body);
    setState(() {
      libri.clear();
      libri.addAll(ll);
    });
    print(libri.length);
  }
  void trovaLibri() async{
    this.inizz=0;
    final http.Response l = await chiamaServerLibri("","");
    var ll = jsonDecode(l.body);
    setState(() {
      libri.addAll(ll);
    });
    print(libri.length);
  }

  List<Widget> elencoAutori(List<dynamic> autori, Model orig){
    List<Widget> out = new List();
    List<dynamic> a = autori;
    for(int i=0; i<a.length; i++){
      print(a[i]);
      out.add(
        Container(
          height: 30,
          child: Row(
            children: [
              Text(a[i]),
              Spacer(
                  flex: 1,
              ),
              Checkbox(
                value: orig.autori.indexOf(a[i])>=0,
                onChanged: (bool valore){
                  setState(() {
                    if (valore)
                      orig.autori.add(a[i]);
                    else
                      orig.autori.remove(a[i]);
                  });
                  ricercaAutori();
                  print(orig.autori);
                },
              ),
            ],
          ),
        ),
      );
      out.add(
        Divider(
          thickness: 1,
        ),
      );
    }

    return out;
  }

  void elencoAutoriTrova() async {
    final http.Response l = await chiamaServerAutori();
    var ll = jsonDecode(l.body);
    setState(() {
      print(ll);
      autori.addAll(ll);
    });
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
      if(this.inizz==1) {
        this.trovaLibri();
        this.elencoAutoriTrova();
      }

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('App Name'+this.cerca.toString()),
          actions: [
            FlatButton(
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: ()=>{
                setState((){
                  this.cerca=(this.cerca-1).abs();
                })
              },
            )
          ],
        ),
        drawer: Drawer(

          child: ListView(
            scrollDirection: Axis.vertical,

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
                      Text("Autore"),
                      TextField(
                        controller: myController,
                        decoration: InputDecoration(labelText: "Ciao"),
                      ),
                      Container(
                        height: 500,
                        child: ListView(
                              children: elencoAutori(autori, m),
                        ),
                      ),
                    ],
                ),
              ),

            ],
          ),
        ),
        body:
        new ListView(
            children: [
              Text(""),
              Padding(
                padding: EdgeInsets.all(4),
                child: (this.cerca==1?TextField(
                  controller: myController,
                  decoration: InputDecoration(labelText: "Cerca titolo"),
                ):Spacer()),
              ),
              Padding(
                padding: EdgeInsets.all(4),
              ),
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

