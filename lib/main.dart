import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gladiators/pages/splash_screen.dart';

void main() {
  runApp(ProviderScope(child: MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // Маршруты приложения
      routes: {
        // Главный экран
        '/': (context) => SplashScreen(),
      },
    );
  }
}
