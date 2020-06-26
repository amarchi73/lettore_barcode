import 'package:flutter/material.dart';

class Pagina2 extends StatefulWidget {
  final String saluto;

  Pagina2({Key key, @required this.saluto}) : super(key: key);

  @override
  _Pagina2State createState() => _Pagina2State();
}

class _Pagina2State extends State<Pagina2> {
  //Future<void> computeFuture = Future.value();
  //final String saluto;
  //Pagina2({Key key, @required this.saluto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.saluto),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
