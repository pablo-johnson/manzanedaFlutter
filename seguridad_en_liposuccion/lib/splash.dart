import 'package:flutter/material.dart';
import 'dart:async';
import 'tab_host.dart';
import 'lang/sit_localizations.dart';
import 'main.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _firstText = false;
  bool _secondText = false;

  _onLayoutDone(_) {
    setState(() {
      _firstText = true;
    });
    new Timer(const Duration(seconds: 1), () {
      setState(() {
        _secondText = true;
      });
    });
  }

  startTimeout() async {
    var duration = const Duration(seconds: 2);
    return new Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(
        builder: (BuildContext context) => TabHost(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    Widget splashImage = SizedBox(
      height: 370.0,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/icons/logo_app.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );

    Widget titleSplash = AnimatedOpacity(
      opacity: _firstText ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: new TextSpan(
            text: SitLocalizations.of(context).appNameLogo1,
            style: TextStyle(
              fontFamily: 'Massa',
              fontSize: 36.0,
              color: primarySwatch['primary'],
            ),
            children: [
              new TextSpan(
                text: SitLocalizations.of(context).appNameLogo2,
                style: TextStyle(
                  fontFamily: 'Massa',
                  fontSize: 36.0,
                  color: primarySwatch['accent'],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget subtitleSplash = AnimatedOpacity(
      opacity: _secondText ? 1.0 : 0.0,
      duration: Duration(seconds: 2),
      child: Center(
        child: Text(
          SitLocalizations.of(context).appSubtitleLogo,
          style: TextStyle(
            fontFamily: 'Massa',
            fontSize: 26.0,
            color: primarySwatch['subtitleSplash'],
          ),
        ),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        body: Container(
          // Add box decoration
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: RadialGradient(
              radius: 1,
              // Where the linear gradient begins and ends
              // Add one stop for each color. Stops should increase from 0 to 1
              // stops: [0.1, 0.5],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Color(0xFFFFFF),
                Color(0x00D7D8D9),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              splashImage,
              SizedBox(
                height: 50,
              ),
              titleSplash,
              SizedBox(
                height: 30,
              ),
              subtitleSplash,
            ],
          ),
        ),
      ),
    );
  }
}
