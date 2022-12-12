import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/age_calculator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:qr_code/xml_model.dart';
import 'package:qr_code_scanner/src/types/barcode.dart';
import 'package:xml/xml.dart';

class DetailsForm extends StatefulWidget {



  DetailsForm({Key? key, Barcode, result,})
      : super(key: key);

  @override
  State<DetailsForm> createState() => _DetailsFormState();
}

class _DetailsFormState extends State<DetailsForm> {



  @override
  Widget build(BuildContext context) {
    var result;
    var sample= {result.code}.first;
    var root = XmlDocument.parse(sample).getElement('PrintLetterBarcodeData');
    var rootGenres = root
        ?.findElements('PrintLetterBarcodeData')
        .map<PrintLetterBarcodeData>(
            (e) => PrintLetterBarcodeData.fromElement(e))
        .toList();
    var Formkey;

    return Scaffold(
      body: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                    textScaleFactor: 1,
                    text: TextSpan(
                        text: 'Entry ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.black),
                        children: [
                          TextSpan(
                              text: 'Person Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 25,
                                  color: Colors.grey))
                        ])),
                Form(
                    key: Formkey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white70,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    PrintLetterBarcodeData.fromElement(root!)
                                        .name
                                        .toString()),
                          ),
                        ),
                        // AgeCalculator(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white70,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  PrintLetterBarcodeData.fromElement(root!)
                                      .yob
                                      .toString(),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white70,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    PrintLetterBarcodeData.fromElement(root!)
                                        .gender
                                        .toString()),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white70,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone number'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Submit'),
                        ),
                      ],
                    )),
                //Text(" Age :${DateTime.now().year- select.year}"),
                // Text(" Age :${DateTime.now().year-selectedDate.year}"),

                // Text(" Age :${DateTime.now().year - _yearofborn.hashCode}")
              ],
            ),
          )),
    );
  }
}
