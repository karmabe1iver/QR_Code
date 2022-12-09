

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:qr_code/xml_model.dart';
import 'package:xml/xml.dart';

class AgeCalculator extends StatefulWidget {
  const AgeCalculator({Key? key}) : super(key: key);

  @override
  State<AgeCalculator> createState() => _AgeCalculatorState();
}

class _AgeCalculatorState extends State<AgeCalculator> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
       children: [
          Container(
            child: DatePickerWidget(
              looping: false,
              firstDate: DateTime(1950),
              //DateTime(1960),
              lastDate: DateTime(2050),
              initialDate: DateTime.now(),// DateTime(1994),
              dateFormat:"dd/MMMM/yyyy",
              // "MM-dd(E)",
              locale: DatePicker.localeFromString('en'),
              onChange: (DateTime newDate, _) {
                setState(() {
                  //selectedDate = newDate;

                });
               //print(DateTime.now().year-selectedDate.year);
               // print(documents.toString());
              },
              pickerTheme: const DateTimePickerTheme(
                itemTextStyle:
                TextStyle( fontSize: 19),
                //dividerColor: Colors.black,
              ),
            ),
          ),


           // Container(child: Text("${DateTime.now().year-_selectedDate.year}")),
        //  ),

           Padding(
            padding: const EdgeInsets.all(28.0), //child: Text(" Age :${DateTime.now().year-selectedDate.year}"),
           ),


        ],
      ),
    );
  }
}

