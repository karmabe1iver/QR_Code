import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:qr_code/personal_details_form.dart';
import 'package:qr_code/xml_model.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:xml/xml.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QrCode Scanner'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QRViewExample(),
              ));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black)),
            child: const Text('qrView'),
          ),
        ),
      ),

      // Text(xml.getElement('Xmlmodel')!.firstElementChild!.getElement('name')!.text)
    );
  }
}

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'Click for Result...',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                result: result,
                              ), //ResultScreen(
                              //result: result,
                            ),
                          );
                        })
                  //Text(
                  //   'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',)
                  //maxLines: 10,
                  //  style: TextStyle(fontSize: 20,
                  // fontWeight: FontWeight.bold), )

                  else
                    // const Text('Scan a code'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                              // icon: Icon(Icons.flash_on),
                              //style: ButtonStyle(
                              // backgroundColor:
                              // MaterialStatePropertyAll(Colors.black)),
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              icon: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Icon(Icons.flash_on_outlined);

                                  // ('Flash: ${snapshot.data}');
                                },
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                              // style: ButtonStyle(
                              // backgroundColor:
                              // MaterialStatePropertyAll(Colors.black)),
                              onPressed: () async {
                                await controller?.flipCamera();
                                setState(() {});
                              },
                              icon: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Icon(Icons.camera_alt);
                                    //SnackBar(content :Text(
                                    //'Camera facing ${describeEnum(snapshot.data!)}'),

                                  } else {
                                    return SnackBar(content: Text('loading'));
                                  }
                                },
                              )),
                        ),
                        // ]
                        //  Row(
                        //    mainAxisAlignment: MainAxisAlignment.end,
                        //  crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                            icon: Icon(Icons.stop_rounded),

                            //   style: ButtonStyle(
                            //backgroundColor:
                            // MaterialStatePropertyAll(Colors.black)),
                            onPressed: () async {
                              await controller?.pauseCamera();
                            },
                            //child: const Text('pause',
                            //   style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: IconButton(
                            icon: Icon(Icons.play_arrow_outlined),
                            //style: ButtonStyle(
                            // backgroundColor:
                            //MaterialStatePropertyAll(Colors.black)),
                            onPressed: () async {
                              await controller?.resumeCamera();
                            },
                            //child: const Text('resume',
                            // style: TextStyle(fontSize: 20)),
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ResultScreen extends StatelessWidget {
  var Barcode;
  var result;

  ResultScreen({
    Key? key,
    @required this.Barcode,
    this.result,
  }) : super(key: key);

//class ResultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var sample = {result.code}.first;
    var root = XmlDocument.parse(sample).getElement('PrintLetterBarcodeData');
    var rootGenres = root
        ?.findElements('PrintLetterBarcodeData')
        .map<PrintLetterBarcodeData>(
            (e) => PrintLetterBarcodeData.fromElement(e))
        .toList();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(children: [
          // Container(
          // child: SelectableText(
          //'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',
          // maxLines: 10,
          // style: TextStyle(
          // fontSize: 15,
          //  ),
          // ),
          //  ),
          Card(
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
        ]),
      ),
    );
  }
}
