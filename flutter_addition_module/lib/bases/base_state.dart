import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  Widget makeFlex1Button(String text, Function onAction) {
    return Flexible(
      flex: 1,
      child: RaisedButton(
        onPressed: () {
          onAction(text);
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
