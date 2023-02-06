import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:scan/scan.dart';
import 'package:images_picker/images_picker.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  // -- image upload
  ScanController controller_img = ScanController();
  String _platformVersion = 'ບໍ່ຮູ້ຈັກ...';
  String? RBarcode;
//----------
// ສ້າງ ຟັງຊັ່ນກວດຊອບ ແພັດຟອມ
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
  //--- end ---

  QRViewController? controller;
  Barcode? barcode;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // controller!.resumeCamera();
  }

  // ກວດຊອບ ເປີດກ້ອງ
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
          Positioned(
            bottom: 70,
            child: buildResult(),
          ),
          Positioned(
            top: 10,
            child: Text(
              'platform: ${_platformVersion}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            top: 30,
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Text('ເປີດ Flash: ${snapshot.data}');
                            },
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                    'ເປີດກ້ອງ: ${describeEnum(snapshot.data!)}');
                              } else {
                                return const Text('ກຳລັງໂຫຼດ...');
                              }
                            },
                          )),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Media>? res = await ImagesPicker.pick();
          if (res != null) {
            String? str = await Scan.parse(res[0].path);
            if (str != null) {
              setState(() {
                // barcode = str as Barcode?;
                RBarcode = str;
              });
            }
          }
        },
        child: Icon(Icons.image),
      ),
    );
  }

  // ສ້າງ Widget QR View
  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: qrViewCreate,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.redAccent,
          borderRadius: 10,
          borderLength: 40,
          borderWidth: 10,
        ),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );

  // ສ້າງ function ສະແກນ
  void qrViewCreate(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        RBarcode = barcode.code!;
        this.barcode = barcode;
      });
    });
  }

// ສະແດງ ສິດການເຂົ້າເຖິງກ້ອງ
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ທ່ານ ບໍ່ມີສິດ')),
      );
    }
  }

  // ສ້າງ widget ສະແດງຜົນລັບ
  Widget buildResult() => InkWell(
        onTap: () async {
          //ກົດເພື່ອເປີດກ້ອງ
          await controller?.resumeCamera();
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white24,
          ),
          child: Text(
            RBarcode != null ? '  Data: ${RBarcode}' : 'ກົດເພື່ອສະແກນ QR Code',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );

// ທຳກາເຄຼຍຂໍ້ມູນໂຕແປ

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
