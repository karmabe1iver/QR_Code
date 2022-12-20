import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:qr_code/personal_details_form.dart';
import 'package:qr_code/qr_detalis.dart';
import 'package:qr_code/xml_model.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:xml/xml.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: QmodelF()));

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
                  // if (result != null)
                  //
                  //
                  //   GestureDetector(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(18.0),
                  //         child: Text(
                  //           'Click for Result...',
                  //           style: TextStyle(
                  //             fontSize: 10,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => ResultScreen(
                  //               result: result,
                  //             ), //ResultScreen(
                  //             //result: result,
                  //           ),
                  //         );
                  //       })
                  // //Text(
                  // //   'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}',)
                  // //maxLines: 10,
                  // //  style: TextStyle(fontSize: 20,
                  // // fontWeight: FontWeight.bold), )
                  //
                  // else
                  //   // const Text('Scan a code'),
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
        print(scanData.format);
        // if  () {
        //   sample = {scanData.code}.first;
        //
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => ResultScreen(
                      result: result,
                    )
        //
        //         //ResultScreen(
        //         //result: result,
                 ),
           );
        // } else {
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => QmodelF(result1: result)));
        //  }
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

  //get root =>XmlDocument.parse(sample).getElement('PrintLetterBarcodeData');

//class ResultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BigInt ef = BigInt.parse(
        "32959354749208614713165722398313032303234228140074494835776635890590417618768304970641972361429261733620329264375038074199715034703776952929503806386748507029172059517952956572763165978799485330858050548580340341032956668352173162787653028854078825779966123934627623219904544918876454049971921186846163639865406270745735773874487366014670279343050187437725092719293410656196227765599806259508685977934239108461696044657196500814564306981298986777729729525834849585061384082787172850030238650100573833509221651154168482021966787592482010194142888782803111596306094518827878857509341066581458267962846070907689389390471894847096116805418065534114811079818145882725745639000093416353741475900746521717700163097728867737030466371178660575131959371264485220628037773907763247831734339788025603844638516829628700311043090132762437430403551967086137377188971731665724598875271752012790936200194512001903239991803887524674234950168584515154012227371337558277654778117040835322777097000035035010857349684091267420103167657425071498044841724229853005478610746403982435012122807287187293259158182568209102580442763866912694369473060169583600953338154513763945538403017741897710151236965788862781795503208581614648791107865637433632363246598702520622736557218807328986081038605058500105509702867404665487832860121539708048463563567756650461945304730562229067697563586664701129921902408346014338871421942149004982385939098106966564406378540299955495902709991749732703809921605885347520255208300408362969006791093873772957917353284194110313654075473768941725041967946482905146921166054736067887402921452485190506631689902202683090581915150046132957829089310295467443438231881489052969220019942240907431154213664039139150197900872755933692504742406845903287611347120457324735163019370721228292460500744264495288456859620452640127007561076004761738338614733966790801941856705621731218754741288685784587517195539507063909461795438030926471813664599468724144018490254243729491144851408088284295758468252091233637448065633546573088060432208876235462646843113641013011077614248372449291941926288729586518890617107724044478491159018056797388011714749519869676327507362700059211943812394617618746874596611547970566655820437664662022279314815751093825272409558026568365274465250601378327901216766390035884817786626449249258078800426401665980204049703959133914990325077525355864118653962572505376499976906948692128850068738839832545972807770755887399706326660285936211139765496966439411804326124351550400065160738918975430733426227892069860805937983860347346892720834130444987441635248441353845939233941662967093124341274309176572134083302713530155765288331243355146777482777883090049858269227691715445357904738355249617024383560137430713162707381175860153633583289078776162723398995143633566773286247337812268782915577733360606346443588431858798687028725695537185754092776804910132876271718633110987390384903803482536375808229151011829836321457046656546390272075503139603781386280693486590177772503654236159475393078746388595994773831773383983490586503734273675306535608855922652542437780902928721685804854029563574828464368723966974907312313594676183118229687863897403623145278072487936");
    // if('qrcode'==describeEnum(result.format)) {
    //   sample = {result.code}.first;
    // }
    // else{
    //
    //   Navigator.of(context).push(
    //       MaterialPageRoute(
    //           builder: (context) => QmodelF( result1= result )));
    // }
    sample = {result.code}.first;
    var root = XmlDocument.parse(sample).getElement('PrintLetterBarcodeData');

    var rootGenres = root
        ?.findElements('PrintLetterBarcodeData')
        .map<PrintLetterBarcodeData>(
            (e) => PrintLetterBarcodeData.fromElement(e))
        .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // if (result==
          //     )
          //
          //             Container(
          //               child: SelectableText(
          // //'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code} '
          //
          //                 ' base to array: ${ef.toString()}, ' ,
          //                 maxLines: 10,
          //                 style: TextStyle(
          //                   fontSize: 15,
          //                 ),
          //               ),
          //             )
          //         else

          // Card(
          //     elevation: 8,
          //     child: Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           RichText(
          //               textScaleFactor: 1,
          //               text: TextSpan(
          //                   text: 'Entry ',
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       fontSize: 35,
          //                       color: Colors.black),
          //                   children: [
          //                     TextSpan(
          //                         text: 'Person Details',
          //                         style: TextStyle(
          //                             fontWeight: FontWeight.w100,
          //                             fontSize: 25,
          //                             color: Colors.grey))
          //                   ])),
          //           Form(
          //               child: Column(
          //             children: [
          //               Container(
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(30),
          //                   color: Colors.white70,
          //                 ),
          //                 child: TextFormField(
          //                   decoration: InputDecoration(
          //                       border: InputBorder.none,
          //                       hintText:
          //                           PrintLetterBarcodeData.fromElement(root!)
          //                               .name
          //                               .toString()),
          //                 ),
          //               ),
          //               // AgeCalculator(),
          //               Container(
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(30),
          //                   color: Colors.white70,
          //                 ),
          //                 child: TextFormField(
          //                   keyboardType: TextInputType.datetime,
          //                   decoration: InputDecoration(
          //                     border: InputBorder.none,
          //                     hintText:
          //                         PrintLetterBarcodeData.fromElement(root!)
          //                             .yob
          //                             .toString(),
          //                   ),
          //                 ),
          //               ),
          //               Container(
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(30),
          //                   color: Colors.white70,
          //                 ),
          //                 child: TextFormField(
          //                   decoration: InputDecoration(
          //                       border: InputBorder.none,
          //                       hintText:
          //                           PrintLetterBarcodeData.fromElement(root!)
          //                               .gender
          //                               .toString()),
          //                 ),
          //               ),
          //               Container(
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(30),
          //                   color: Colors.white70,
          //                 ),
          //                 child: TextFormField(
          //                   decoration: InputDecoration(
          //                       border: InputBorder.none,
          //                       hintText: 'Phone number'),
          //                 ),
          //               ),
          //               ElevatedButton(
          //                 onPressed: () {
          //                   print(describeEnum(result!.format));
          //                   DateTime dateTimeCreatedAt = DateTime.parse(
          //                       '${PrintLetterBarcodeData.fromElement(root!).yob.toString()}-01-01');
          //                   DateTime dateTimeNow = DateTime.now();
          //                   final differenceInDays = dateTimeNow
          //                       .difference(dateTimeCreatedAt)
          //                       .inDays;
          //                   if (differenceInDays > 22) {
          //                     Navigator.of(context).push(MaterialPageRoute(
          //                       builder: (context) => QrModel(),
          //                     ));
          //                     print(differenceInDays);
          //                     print(BarcodeFormat.qrcode);
          //                   } else {
          //                     Navigator.of(context).push(MaterialPageRoute(
          //                       builder: (context) => QmodelF(),
          //                     ));
          //                     print(differenceInDays);
          //                     print(BarcodeFormat.qrcode);
          //                   }
          //                 },
          //                 child: Text('Submit'),
          //               ),
          //             ],
          //           )),
          //           //Text(" Age :${DateTime.now().year- select.year}"),
          //           // Text(" Age :${DateTime.now().year-selectedDate.year}"),
          //
          //           // Text(" Age :${DateTime.now().year - _yearofborn.hashCode}")
          //         ],
          //       ),
          //     ))
          //
          // // else
            Container(
              child: SelectableText(
                //'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code} '

                ' base to array: ${ef.toRadixString(2)}, ',
                maxLines: 10,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
          )
        ]),
      ),
    );
  }
}
