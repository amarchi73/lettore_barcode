import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lettore_barcode/elencoLibri.dart';

String trasmetti(){
  return "ciaoxxxx00000";
}
// 'http://192.168.178.26:8080/iban',
Future<http.Response> mandaCodice(String codice) {
  return http.post(
    'http://192.168.178.26:8080/iban',
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

Future<http.Response> chiamaServerLibri(){
  return http.get('http://192.168.178.26:8080/libri');
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Image.network(
              libri[i]["Img"],
              fit: BoxFit.fill,
            ),
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
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  ),

                  new Text(
                    libri[i]["Autore"],
                    style: new TextStyle(fontSize: 12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )
                ]

            ),
          ),
          Expanded(
              flex: 2,
              child: new Icon(
                  Icons.create,
                  color: const Color(0xFF000000),
                  size: 48.0)
          ),
        ],
      ),
    );
  }

  return out;
}
