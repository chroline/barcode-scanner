import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scanner/pages/confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final homePageScaffoldKey = new GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {
  Future scan() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();

      if (barcode.rawContent.isNotEmpty)
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmPage(
                    barcode: barcode.rawContent,
                  )),
        );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        print("nope");
      }
    } on FormatException {
      print("bye");
    } catch (e) {
      print("??");
    }
  }

  void manualInput() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmPage(barcode: "")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageScaffoldKey,
      appBar: AppBar(
        title: Text(
          "Barcode Scanner",
          style: GoogleFonts.ibmPlexMono(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  width: 300.0,
                  child: FlatButton(
                    color: Colors.indigo,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: BeveledRectangleBorder(
                      // Despite referencing circles and radii, this means "make all corners 4.0".
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(20, 10),
                        topRight: Radius.elliptical(10, 20),
                        bottomLeft: Radius.elliptical(10, 20),
                        bottomRight: Radius.elliptical(20, 10),
                      ),
                    ),
                    child: new Text(
                      "SCAN BARCODE",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: scan,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                SizedBox(
                    width: 300.0,
                    child: FlatButton(
                      color: Colors.grey.shade700,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: BeveledRectangleBorder(
                        // Despite referencing circles and radii, this means "make all corners 4.0".
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(20, 10),
                          topRight: Radius.elliptical(10, 20),
                          bottomLeft: Radius.elliptical(10, 20),
                          bottomRight: Radius.elliptical(20, 10),
                        ),
                      ),
                      child: new Text(
                        "Enter manually",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      onPressed: manualInput,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
