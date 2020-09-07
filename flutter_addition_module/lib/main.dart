import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradditionmodule/settings_screen.dart';
import 'dart:async';

import 'bases/base_state.dart';
import 'calculator_screen.dart';
import 'di/PresenrorsDI.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => MyApp(context),
        "/settings": (BuildContext context) => SettingsScreen(),
        "/calculator": (BuildContext context) => CalculatorWidget(),
      },
    ));

class BaseNavigationContext {
  static int popCount = 0;
  static BuildContext context;
  static const platform = const MethodChannel('samples.flutter.dev/battery');

  static Future<void> transitionChannel() async {
    
    try {
      final String transition = await BaseNavigationContext.platform.invokeMethod('action');
      print("Переход на $transition");

      switch (transition) {
        case "back":
          bool status = await  Navigator.maybePop(BaseNavigationContext.context);
          if(!status) popCount++; else popCount = 0;

          print("popCount :: $popCount");

          if(popCount==1){
            print("Нажмите поворно 'Назад' для выхода");
          }
          if(popCount==2)
            Navigator.pop(BaseNavigationContext.context);

          break;
        default:
          Navigator.pushNamed(BaseNavigationContext.context, transition);
      }
    } on PlatformException catch (e) {
      print("Неизвестный переход ${e.message}");
    }
    transitionChannel();
  }
}

class MyApp extends StatelessWidget {

  MyApp(BuildContext context){
    RegPresenters();

    if(BaseNavigationContext.context == null) {
      BaseNavigationContext.context = context;
      BaseNavigationContext.transitionChannel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomePage',
      home: MyHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  MyHomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends BaseState<MyHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flatter: главное окно"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Выберите экран для переход',
              style: TextStyle(fontSize: 40.0),
            ),
            makeFlex1Button("/calculator",_openScreen),
            makeFlex1Button("/settings",_openScreen),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _openScreen(String screenName){
    print("screenName :: $screenName");
    Navigator.pushNamed(BaseNavigationContext.context, screenName);
  }

}
