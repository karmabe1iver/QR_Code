import 'dart:html';

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
        child: ListView.builder(
          itemCount: 1,
            itemBuilder: (context, index){
          return Column(
            children: [
              //Text(documents.toString())
            ],
          );
        }),
      ),
    );
  }
}
