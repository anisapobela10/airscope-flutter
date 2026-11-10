import 'package:flutter/material.dart';
import 'features/air_quality/presentation/home_page.dart';

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
      home: const AirQualityHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}