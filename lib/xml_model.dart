


import 'package:qr_code/xml_model.dart';
import 'package:xml/xml.dart';
void _XmlData() async {
  final Datalist = [];

  const xml = '''
<?xml version="1.0" encoding="UTF-8"?>
<PrintLetterBarcodeData uid="468308090468"
 name="Joya Kuriakose" gender="F" 
 yob="1995"
 co="D/O: Kuriakose K P" 
 house="Keerankuzhy House" 
 street="Puthenpally"
 loc="Vembilly P O" 
 vtc="Kunnathunad" 
 dist="Ernakulam" 
 state="Kerala" 
 pc="683565"
/
>
''';
}

class Xmlmodel {
  final String name;
  final String gender;
  final int yob;

  Xmlmodel(
    this.name,
    this.gender,
    this.yob,
  );

  factory Xmlmodel.fromxXmlElement(XmlElement xmlElement) => Xmlmodel(
        xmlElement.findElements('name').single.text,
        xmlElement.findElements('gender').single.text,
        int.parse(xmlElement.findElements('yob').single.text),
      );

  String toString() {
    return 'Xmlmodel{name: $name,'
        'gender: $gender,'
        'yob: $yob}';
  }
}

//void Main() {
  //final document = XmlDocument.parse(xml);
//  final listofXmlmodel = document
     // .findAllElements('Xmlmodel')
    //  .map((XmlElement) => Xmlmodel.fromxXmlElement(XmlElement)).toList();
 // listofXmlmodel.forEach(print);
//}
