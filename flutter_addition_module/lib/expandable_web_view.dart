import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutteradditionmodule/presenters/settings_screen_presenter.dart';
import 'package:kiwi/kiwi.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SettingsScreen> {
  KiwiContainer container = KiwiContainer();
  double minHeightWebViewContainer = 0;
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  GlobalKey keyWebView = GlobalKey();
  double webViewHeight = 0;
  double webViewHeightContent = 0;

  _MyAppState() {
    minHeightWebViewContainer =
        container.resolve<SettingsScreenPresenter>().webViewStandartHeigth;
    webViewHeight = minHeightWebViewContainer;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
            child: Column(children: <Widget>[

              Container(
                  padding: EdgeInsets.all(10.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container()),
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        height: webViewHeight,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: makeWebView(),
                      ),
                      RaisedButton( // Кнопка раскрытия/Закрытия
                          child: Center(
                            child: Text("Expand/Collapse"),
                          ),
                          onPressed: () {
                            // Перерисовываем экран
                            setState(() {
                              if (webViewHeight == minHeightWebViewContainer && // Выбираем новый размер для WebView
                                  webViewHeightContent != 0) {
                                webViewHeight = webViewHeightContent;
                              } else
                                webViewHeight = minHeightWebViewContainer;
                            });
                          }),
                    ],
                  ),
                ),
              ),
            ])),
      ),
    );
  }

  InAppWebView makeWebView() {
    return InAppWebView(
      key: keyWebView,
      initialUrl: "https://ya.ru/",
      initialHeaders: {},
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            debuggingEnabled: true,
          )),
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
      },
      onLoadStart: (InAppWebViewController controller, String url) {
        setState(() {
          this.url = url;
        });
      },
      onLoadStop: (InAppWebViewController controller, String url) async {
        controller.evaluateJavascript(
            source:
            '''(() => { return document.body.scrollHeight;})()''').then(
                (value) {
              if (value == null || value == '') {
                return;
              }
              webViewHeightContent = double.parse('$value');
              print(
                  "webHeight = $webViewHeightContent :: boxSize = ${_getHeight(keyWebView)}");
              setState(() {});
            });

        setState(() {
          this.url = url;
        });
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        setState(() {
          this.progress = progress / 100;
        });
      },
    );
  }

  double _getHeight(GlobalKey key) {
    final RenderBox renderBox = key.currentContext.findRenderObject();
    return renderBox.size.height;
  }
}
