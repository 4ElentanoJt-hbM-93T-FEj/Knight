// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gladiators/pages/select_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  Future<void> changeScreen() async {
    Future.delayed(Duration(seconds: 4, microseconds: 500), () {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SelectPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Center(
            child: LottieBuilder.asset(
              'lib/assets/animation/loading.json',
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
            ),
          ),
        ),
      ),
    );
  }
}
