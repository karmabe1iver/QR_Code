

import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';

var sample ='''describeEnum(result!.format)  {result!.code} '''; //'''
//<?xml version="1.0" encoding="UTF-8"?>
//<PrintLetterBarcodeData uid="468308090468" name="Joya Kuriakose" gender="F" yob="1995" co="D/O: Kuriakose K P"
 //house="Keerankuzhy House"
 //street="Puthenpally"
 //loc="Vembilly P O"
 //vtc="Kunnathunad"
 //dist="Ernakulam"
 //state="Kerala"
 //pc="683565"/>
//''';

class PrintLetterBarcodeData {
  PrintLetterBarcodeData( this.name, this.gender, this.yob, this.co, this.house, this.street,
      this.loc, this.vtc, this.dist, this.state, this.pc, this.subGenres);

  factory PrintLetterBarcodeData.fromElement(XmlElement genreElement) {
    return PrintLetterBarcodeData(
      genreElement.getAttribute('name'),
      genreElement.getAttribute('gender'),
      genreElement.getAttribute('yob'),
      genreElement.getAttribute('co'),
      genreElement.getAttribute('house'),
      genreElement.getAttribute('street'),
      genreElement.getAttribute('loc'),
      genreElement.getAttribute('vtc'),
      genreElement.getAttribute('dist'),
      genreElement.getAttribute('state'),
      genreElement.getAttribute('pc'),
      genreElement
          .findElements('PrintLetterBarcodeData')
          .map<PrintLetterBarcodeData>((e) => PrintLetterBarcodeData.fromElement(e))
          .toList(),
    );
  }

  String? name;
  String? gender;
  String? yob;
  String? co;
  String? house;
  String? street;
  String? loc;
  String? vtc;
  String? dist;
  String? state;
  String? pc;
  List<PrintLetterBarcodeData> subGenres;
}
