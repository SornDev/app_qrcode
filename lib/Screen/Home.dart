import 'package:app_qrcode/Screen/Generate_qr.dart';
import 'package:app_qrcode/Screen/Scane_qr.dart';
import 'package:flutter/material.dart';

import 'Scane_qr2.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const List _tabPages = [
    ScanQR(),
    // ScanQR2(),
    GenQR(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ແອ໊ບ QR Code')),
      body: Center(
        child: _tabPages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'ສະແກນ QR 01'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.qr_code_scanner), label: 'ສະແກນ QR 02'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'ສ້າງ QR'),
        ],
      ),
    );
  }
}
