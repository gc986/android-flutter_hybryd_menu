import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bases/base_state.dart';
import 'main.dart';

class CalculatorWidget extends StatefulWidget {

  @override
  CalculatorState createState() {

    return CalculatorState();
  }
}

class CalculatorState extends BaseState<CalculatorWidget> {

  var _outLine = _ZERO;
  String _action = null;
  String _tmpLine = null;

  static const String _ZERO = "0";

  void _clearState() {
    _tmpLine = null;
    _outLine = _ZERO;
    _action = null;
  }

  void _onChangeText(String addedText) {
    switch (addedText) {
      case "C":
        _clearState();
        break;
      case "+":
        _eqOperation();
        _action = "+";
        break;
      case "-":
        _eqOperation();
        _action = "-";
        break;
      case "*":
        _eqOperation();
        _action = "*";
        break;
      case "/":
        _eqOperation();
        _action = "/";
        break;
      case "=":
        _eqOperation();
        break;
      default:
        if (_action != null && _tmpLine == null) {
          _tmpLine = _outLine;
          _outLine = _ZERO;
        }

        if (_outLine == _ZERO) _outLine = "";
        _outLine += addedText;
    }

    setState(() {});
  }

  void _eqOperation() {
    if (_tmpLine == null || _action == null) return;

    switch (_action) {
      case "+":
        _outLine = (int.parse(_tmpLine) + int.parse(_outLine)).toString();
        break;
      case "-":
        _outLine = (int.parse(_tmpLine) - int.parse(_outLine)).toString();
        break;
      case "*":
        _outLine = (int.parse(_tmpLine) * int.parse(_outLine)).toString();
        break;
      case "/":
        _outLine = (double.parse(_tmpLine) / double.parse(_outLine)).toString();
        break;
    }
    _action = null;
    _tmpLine = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Калькулятор"),
      ),
      body: _keyboard(),
    );
  }

  Widget _keyboard() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            _outLine,
            style: TextStyle(fontSize: 30.0),
          ),
        ),
        Flexible(
          flex: 1,
          child: _theeButtons("1", "2", "3", "+", _onChangeText),
        ),
        Flexible(
          flex: 1,
          child: _theeButtons("1", "2", "3", "+", _onChangeText),
        ),
        Flexible(
            flex: 1, child: _theeButtons("4", "5", "6", "-", _onChangeText)),
        Flexible(
            flex: 1, child: _theeButtons("7", "8", "9", "*", _onChangeText)),
        Flexible(
            flex: 1, child: _theeButtons("/", "0", "C", "=", _onChangeText))
      ],
    );
  }

  Widget _theeButtons(String btText, String btText2, String btText3,
      String btFunctionText, Function onAction) {
    return Row(
      children: <Widget>[
        _makeFlex1Button(btText, onAction),
        _makeFlex1Button(btText2, onAction),
        _makeFlex1Button(btText3, onAction),
        _makeFlex1ButtonBold(btFunctionText, onAction)
      ],
    );
  }

  Widget _makeFlex1Button(String text, Function onAction) {
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

  Widget _makeFlex1ButtonBold(String text, Function onAction) {
    return Flexible(
      flex: 1,
      child: RaisedButton(
        onPressed: () {
          onAction(text);
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

}