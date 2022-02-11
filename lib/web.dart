import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'utils.dart';

class Web extends StatefulWidget {
  const Web({Key? key}) : super(key: key);

  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<Web> {
  FlutterBarcodeSdk _barcodeReader = FlutterBarcodeSdk();
  String _barcodeResults = 'Not scanned';

  @override
  void initState() {
    super.initState();
    initBarcodeSDK();
  }

  Future<void> initBarcodeSDK() async {
    _barcodeReader = FlutterBarcodeSdk();
    await _barcodeReader.init();
    await _barcodeReader.setBarcodeFormats(BarcodeFormat.ALL);
    // Get all current parameters.
    // Refer to: https://www.dynamsoft.com/barcode-reader/parameters/reference/image-parameter/?ver=latest
    String params = await _barcodeReader.getParameters();
    // Convert parameters to a JSON object.
    dynamic obj = json.decode(json.decode(params));
    // Modify parameters.
    obj['ImageParameter']['DeblurLevel'] = 5;
    // Update the parameters.
    int ret = await _barcodeReader.setParameters(json.encode(obj));
    debugPrint('Parameter update: $ret');
  }

  void updateResults(List<BarcodeResult> results) {
    if (results.isNotEmpty) _barcodeReader.closeVideo();

    setState(() {
      _barcodeResults = getBarcodeResults(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Barcode result: $_barcodeResults ',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            MaterialButton(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Click here to scan Barcode',
                  style: Theme.of(context).textTheme.headline5,
                ),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async {
                  _barcodeReader
                      .decodeVideo((results) => {updateResults(results)});
                }),
          ]),
    );
  }
}
