import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text('Simple Messenger', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
      )
    );
  }
}