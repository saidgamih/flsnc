import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../components/buttons.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
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
                decoration: InputDecoration(
                  labelText: 'Code utilisateur',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
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
                child: PrimaryButton(
                  child: Text('Se connecter'),
                  onPressed: () => {
                    //
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
