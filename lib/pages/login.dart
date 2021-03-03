import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import './home.dart';
import '../components/buttons.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  Future<String> _attemptLogin(String email, String password) async {
    try {
      Uri uri = Uri.http('said.saysusolutions.site', 'api/auth/login');
      http.Response response =
          await http.post(uri, body: {'email': email, 'password': password});
      if (response.statusCode == 200)
        return response.body;
      else
        return null;
    } catch (e) {
      print(e);
    }
  }

  void _login(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    String email = widget._emailController.text;
    String password = widget._passwordController.text;
    var response = await _attemptLogin(email, password);
    if (response != null) {
      await storage.write(
          key: 'access_token', value: json.decode(response)['access_token']);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      displayDialog(context, "Erreur d'autentication",
          "code utilisateur ou mot de passe incorecte");
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(children: <Widget>[
              Image.asset(
                "images/logo_v.png",
                width: 130,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "SE CONNECTER",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Veuillez saisir le nom d'utilisateur et le mot de passe fournis par la SONACOS",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black38),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                autofocus: true,
                controller: widget._emailController,
                decoration: InputDecoration(
                  labelText: 'Code utilisateur',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: widget._passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child:  
                _loading ?
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  child: Center(child: LinearProgressIndicator())
                ) 
                :
                PrimaryButton(
                  child: Text('Se connecter'),
                  onPressed: () {
                    _login(context);
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
