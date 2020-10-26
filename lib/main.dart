import 'package:flutter/material.dart';
import 'package:insumos_covid19/view/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insumos contra a COVID-19',
      theme: ThemeData(
        primaryColor: Color(0xFF6200EE),
        accentColor: Color(0xFF6200EE),
        backgroundColor: Colors.white,
        primaryColorDark: Color(0xFF3700B3),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Insumos contra a COVID-19'),
    );
  }
}
