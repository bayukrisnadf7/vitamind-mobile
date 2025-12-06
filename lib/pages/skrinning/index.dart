import 'package:flutter/material.dart';

class SkrinningPage extends StatefulWidget {
  const SkrinningPage({super.key});

  @override
  State<SkrinningPage> createState() => _SkrinningPageState();
}

class _SkrinningPageState extends State<SkrinningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Halaman Skrinning'),
      ),
    );
  }
}