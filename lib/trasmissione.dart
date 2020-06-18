import 'dart:convert';
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
