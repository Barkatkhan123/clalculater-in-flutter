import 'package:app/homescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          const Homescreen(), // Add const for consistency if Homescreen is immutable
      debugShowCheckedModeBanner: false, // Optional: Remove debug banner
    );
  }
}
