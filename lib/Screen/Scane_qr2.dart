import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:scan/scan.dart';
import 'package:images_picker/images_picker.dart';
// import 'scan.dart';

class ScanQR2 extends StatefulWidget {
  const ScanQR2({super.key});

  @override
  State<ScanQR2> createState() => _ScanQR2State();
}

class _ScanQR2State extends State<ScanQR2> {
  ScanController controller = ScanController();
  String _platformVersion = 'Unknown';

  String qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: ScanView(
            controller: controller,
            scanAreaScale: 0.7,
            scanLineColor: Colors.green,
            onCapture: (data) {
              setState(() {
                qrcode = data;
              });
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (BuildContext context) {
              //     return Scaffold(
              //       appBar: AppBar(
              //         title: Text('scan result'),
              //       ),
              //       body: Center(
              //         child: Text(data),
              //       ),
              //     );
              //   },
              // )).then((value) {
              //   controller.resume();
              // });
            },
          ),
        ),
        Positioned(
          bottom: 60,
          child: buildResult(),
        ),
        Positioned(
          bottom: 10,
          child: Row(
            children: [
              ElevatedButton(
                child: Text("ເລືອກຮູບ"),
                onPressed: () async {
                  List<Media>? res = await ImagesPicker.pick();
                  if (res != null) {
                    String? str = await Scan.parse(res[0].path);
                    if (str != null) {
                      setState(() {
                        qrcode = str;
                      });
                    }
                  }
                },
              ),
              ElevatedButton(
                child: Text("ເປີດ Flash"),
                onPressed: () {
                  controller.toggleTorchMode();
                },
              ),
              ElevatedButton(
                child: Text("pause"),
                onPressed: () {
                  controller.pause();
                },
              ),
              ElevatedButton(
                child: Text("resume"),
                onPressed: () {
                  controller.resume();
                },
              )
            ],
          ),
        ),
      ],
    ));
  }

  // ສ້າງ widget ສະແດງຜົນລັບ
  Widget buildResult() => InkWell(
        onTap: () {
          //ກົດເພື່ອເປີດກ້ອງ
          controller.resume();
          print('object');
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white24,
          ),
          child: Text(
            qrcode != null ? ' Data: ${qrcode}' : 'ກົດເພື່ອສະແກນ QR Code',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
}
