import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smart_gloves_01/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Dopo 2 secondi va alla homepage
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Homepage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // colore sfondo
      body: Center(
        child: Image.asset("assets/logo.JPG", width: MediaQuery.of(context).size.width * 0.5),
      ),
    );
  }
}