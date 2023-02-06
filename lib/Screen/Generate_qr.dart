import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenQR extends StatefulWidget {
  const GenQR({super.key});

  @override
  State<GenQR> createState() => _GenQRState();
}

class _GenQRState extends State<GenQR> {
  final qr_text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            QrImage(
              data: qr_text.text,
              size: 300,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: qr_text,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    setState(() {});
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
