import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  
  final Function onPressed;
  final Widget child;

  PrimaryButton({Key key, this.onPressed, this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: child,
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: onPressed,
    );
  }
}
