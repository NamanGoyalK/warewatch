import 'package:flutter/material.dart';
import 'package:warewatch/common/widgets/atmospheric_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AtmosphericBackground(child: Text('Welcome to the Home Screen!')),
    );
  }
}
