import 'package:flutter/material.dart';
import 'package:flutter_berita/providers/berita_provider.dart';
import 'package:flutter_berita/views/berita_add_page.dart';
import 'package:flutter_berita/views/home_page.dart';
import 'package:flutter_berita/views/login_page.dart';
import 'package:flutter_berita/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BeritaProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Berita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/addBerita': (context) => BeritaAddPage(),
      },
    );
  }
}
