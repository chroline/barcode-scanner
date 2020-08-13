import 'package:flutter/material.dart';

import '../sheetManager.dart';
import 'home.dart';

class ConfirmPage extends StatefulWidget {
  ConfirmPage({Key key, this.barcode}) : super(key: key);

  final String barcode;

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  TextEditingController barcodeInputCtrl;
  FocusNode barcodeInputFocus;

  final confirmPageScaffoldKey = new GlobalKey<ScaffoldState>();

  bool isDisabled = false;

  @override
  void initState() {
    super.initState();

    barcodeInputFocus = FocusNode();
    barcodeInputCtrl = TextEditingController(text: widget.barcode);
  }

  updateSheet() {
    barcodeInputFocus.unfocus();

    if (barcodeInputCtrl.text.length < 12)
      return confirmPageScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Text('Barcode must be 12 digits'),
      )));

    try {
      int.parse(barcodeInputCtrl.text);
    } catch (e) {
      return confirmPageScaffoldKey.currentState.showSnackBar(SnackBar(
          content: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Text('Barcode must only contain numbers'),
      )));
    }

    setState(() => isDisabled = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Padding(padding: EdgeInsets.all(15)),
              Text("Updating database..."),
            ],
          ),
        ),
      ),
    );

    updateCode(barcodeInputCtrl.text).then((val) {
      Navigator.pop(context);
      Navigator.pop(context);

      homePageScaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.green.shade800,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text('Successfully updated database'),
          )));
    }).catchError((err) {
      Navigator.pop(context);
      setState(() => isDisabled = false);

      confirmPageScaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red.shade800,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text('An error occurred while updating the database'),
          )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isDisabled,
      child: Scaffold(
        key: confirmPageScaffoldKey,
        appBar: AppBar(
          title: Text("Edit barcode"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit and confirm your barcode.",
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    TextField(
                        focusNode: barcodeInputFocus,
                        controller: barcodeInputCtrl,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number)
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: updateSheet,
          label: Text('Confirm'),
          icon: Icon(Icons.check),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
