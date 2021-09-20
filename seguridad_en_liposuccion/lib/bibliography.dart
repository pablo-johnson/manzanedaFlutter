import 'package:flutter/material.dart';
import 'package:seguridad_en_liposuccion/ppg.dart';
import 'lang/sit_localizations.dart';
import 'main.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';

class Bibliography extends StatefulWidget {
  @override
  _BibliographyState createState() => _BibliographyState();
}

class _BibliographyState extends State<Bibliography> {
  List<String> _bibliographies = <String>[];
  final _inputKey = GlobalKey(debugLabel: 'safeArea');

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _retrieveBibliography() async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/json/bibliography.json');
    _bibliographies =
        (JsonDecoder().convert(await json) as List<dynamic>).cast<String>();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_bibliographies.isEmpty) {
      await _retrieveBibliography();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget topLabelWidget = Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: new RichText(
        textAlign: TextAlign.justify,
        text: new TextSpan(
          text: SitLocalizations.of(context).researchWorkLabel,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
          children: [
            new TextSpan(
              text: 'Link PDF',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.red,
              ),
              recognizer: new TapGestureRecognizer()
                ..onTap = () => _launchURL(
                    PPG.PAPER_URL),
            ),
          ],
        ),
      ),
    );

    Widget bibliographyListWidget = ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        String bibliography = _bibliographies[index];
        return Material(
          color: primarySwatch['background'],
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            color: primarySwatch['containerBackground'],
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    bibliography,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: _bibliographies.length,
    );

    return SafeArea(
      key: _inputKey,
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
        // child: bibliographyListWidget,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            topLabelWidget,
            Expanded(
              child: bibliographyListWidget,
            )
          ],
        ),
      ),
    );
  }
}
