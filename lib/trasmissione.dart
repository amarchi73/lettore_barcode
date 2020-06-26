import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:lettore_barcode/elencoLibri.dart';


String trasmetti(){
  return "ciaoxxxx00000";
}
// 'http://192.168.178.58:8080/iban',

String serverIP = "http://192.168.178.58:8080";


Future<http.Response> mandaCodice(String codice) {
  return http.post(
    serverIP+'/iban',
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'codice': codice,
    },
  );
}

Future<http.Response> trovaCodice(String codice) {
  return http.get(
    'https://www.googleapis.com/books/v1/volumes?q=isbn:'+codice,
  );
}

Future<http.Response> chiamaServerLibri(String cosa, String quali){
  return http.get(serverIP+'/libri'+cosa+"?quali="+quali);
}

Future<http.Response> chiamaServerAutori(){
  return http.get(serverIP+'/autori');
}


List<Container> popolaElenco(libriScansionati){
  List<Container> libri = new List();

  for(int i=0; i<libriScansionati.length; i++) {
    var l=libriScansionati[i];
    print(l);

    libri.add(
      Container(
        height: 150,
        child: Row(
          children: [
            Expanded(
              child: Image.network(l["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"]),
            ),
            Expanded(
              child: Text(
                l["items"][0]["volumeInfo"]["title"],
              ),
            ),
            Expanded(
              child: Text(
                l["items"][0]["volumeInfo"]["authors"].join(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  return libri;
}

List<Widget> elencoLibri(libri){
  List<Widget> out = new List();

  for(int i=0; i<libri.length; i++) {
    out.add(
      new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Image.network(
              libri[i]["Img"],
              fit: BoxFit.fill,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(10),
          ),
          Expanded(
            flex: 6,
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    libri[i]["Titolo"],
                    style: new TextStyle(fontSize: 14.0,
                        color: const Color(0xFF000000),
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                    ),
                  ),

                  new Text(
                    libri[i]["Autore"],
                    style: new TextStyle(fontSize: 12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w300,
                        fontFamily: "Roboto"),
                  ),
                  Text(
                    libri[i]["Desc"].toString().substring(0,200),
                    style: new TextStyle(fontSize: 12.0,
                        color: const Color(0xFF000000),
                        fontFamily: "Roboto"),
                  ),
                ]
            ),
          ),
          Expanded(
              flex: 2,
              child: new Icon(
                  Icons.create,
                  color: const Color(0xFF000000),
                  size: 24.0)
          ),
        ],
      ),
    );
    out.add(Padding(
        padding: EdgeInsets.all(10),
      )
    );
  }

  return out;
}

