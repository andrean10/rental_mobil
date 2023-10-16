import 'package:flutter/material.dart';

class HomeAdminRentalWebView extends StatelessWidget {
  const HomeAdminRentalWebView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Halaman Awal Berisi Informasi',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
