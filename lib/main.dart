import 'package:flutter/material.dart';
import 'package:flutter_berita/providers/berita_provider.dart';
import 'package:flutter_berita/providers/user_provider.dart';
import 'package:flutter_berita/utils/session.dart';
import 'package:flutter_berita/views/berita_add_page.dart';
import 'package:flutter_berita/views/home_page.dart';
import 'package:flutter_berita/views/login_page.dart';
import 'package:flutter_berita/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isLogin = await SessionManager.isLogin();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BeritaProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(isLogin: isLogin),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLogin;

  const MyApp({super.key, this.isLogin = false});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Berita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLogin ? const SplashScreen() : const LoginPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/addBerita': (context) => BeritaAddPage(),
      },
    );
  }
}
