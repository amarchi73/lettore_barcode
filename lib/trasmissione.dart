import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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
