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


    return Scaffold(
      body: Container(
        child: Center(
          child: Text(''),
        ),
      )
    );
  }
}
