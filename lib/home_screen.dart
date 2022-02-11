import 'package:barcode_flutter/web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode web flutter'),
      ),
      body: kIsWeb
          ? const Web()
          : const Text('This feature is implmented only for web'),
    );
  }
}
