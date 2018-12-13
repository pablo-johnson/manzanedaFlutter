import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'lang/sit_localizations.dart';
import 'lang/sit_localizations_delegate.dart';
import 'splash.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        const SitLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('es', 'ES'), // Spanish
        // ... other locales the app supports
      ],
      onGenerateTitle: (context) => SitLocalizations.of(context).title,
      home: Splash(),
    );
  }
}

const primarySwatch = ColorSwatch(0xff16335C, {
  'primary': Color(0xff16335C),
  'primaryDark': Color(0xff021227),
  'primaryLight': Color(0xff2285C2),
  'accent': Color(0xff2285C2),
  'background': Color(0xff4A678E),
  'containerBackground': Color(0xff2B4A75),
  'disabledButton': Color(0xff6F87A8),
  'subtitleSplash': Color(0xff5D5F61),
});
