import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import './pages/login.dart';
import './pages/home.dart';
import './pages/loading.dart';
import './pages/error.dart';

void main() {
  runApp(MyApp());
}

final storage = FlutterSecureStorage();

class MyApp extends StatelessWidget {
  static const int _mcgpalette0PrimaryValue = 0xFFE33039;
  static const MaterialColor mcgpalette0 =
      MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
    50: Color(0xFFFCE6E7),
    100: Color(0xFFF7C1C4),
    200: Color(0xFFF1989C),
    300: Color(0xFFEB6E74),
    400: Color(0xFFE74F57),
    500: Color(_mcgpalette0PrimaryValue),
    600: Color(0xFFE02B33),
    700: Color(0xFFDC242C),
    800: Color(0xFFD81E24),
    900: Color(0xFFD01317),
  });

  static const MaterialColor mcgpalette0Accent =
      MaterialColor(_mcgpalette0AccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_mcgpalette0AccentValue),
    400: Color(0xFFFF9A9B),
    700: Color(0xFFFF8082),
  });
  static const int _mcgpalette0AccentValue = 0xFFFFCDCE;

  Future<int> get _checkAuth async {
    try {
      String token = await storage.read(key: 'access_token');
      Uri uri = Uri.http('said.saysusolutions.site', 'api/auth/me');
      http.Response response = await http
          .post(uri, headers: {
        'Authorization': 'Bearer ${token ?? ''}',
        'Accept': 'application/json'
      });
      return response.statusCode;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation',
      theme: ThemeData(
        primarySwatch: mcgpalette0,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _checkAuth,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 200) return HomePage();
            return LoginPage();
          } else if (snapshot.hasError) {
            return Error();
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
