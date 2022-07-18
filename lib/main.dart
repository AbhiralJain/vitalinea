import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalinea/pages/homepage.dart';
import 'package:vitalinea/pages/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const MaterialColor myColor = MaterialColor(
    _myColorPrimaryValue,
    <int, Color>{
      50: Color(0xfff7e9ea),
      100: Color(0xffeed2d5),
      200: Color(0xFFdea5ab),
      300: Color(0xFFcd7982),
      400: Color(0xFFbd4c58),
      500: Color(0xFFac1f2e),
      600: Color(0xFF8a1925),
      700: Color(0xFF67131c),
      800: Color(0xFF450c12),
      900: Color(0xFF220609),
    },
  );
  static const int _myColorPrimaryValue = 0xFFac1f2e;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vita Linea',
      theme: ThemeData(
        primarySwatch: myColor,
        iconTheme: IconThemeData(color: myColor.shade500),
        scaffoldBackgroundColor: myColor.shade50,
        cardColor: const Color(0xFFFFFFFF),
        canvasColor: myColor.shade100,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: myColor.shade700,
            fontSize: 40,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: myColor.shade700,
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: myColor.shade700,
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal,
          ),
          labelMedium: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          labelSmall: TextStyle(
            color: myColor.shade500,
            fontSize: 16,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  getfprefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('signed') != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Homepage(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SignInPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getfprefs();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
