import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/xml_model.dart';
import 'package:xml/xml.dart';

class QrModel extends StatelessWidget {
  const QrModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.green,
            child: Center(
      child: Text('Entry permitted',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
      ),),
    )));
  }
}

class QmodelF extends StatelessWidget {
  const QmodelF({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text('Not permitted',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,
        ),),
      ),
    );
  }
}
