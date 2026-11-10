import 'package:flutter/material.dart';

class AirScopeApp extends StatelessWidget {
  const AirScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirScope',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('AirScope App Initialized'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}