import 'package:flutter/material.dart';
import 'navigation_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ppg.dart';
import 'rohrich.dart';
import 'bibliography.dart';
import 'about_us.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lang/sit_localizations.dart';
import 'main.dart';

class TabHost extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<TabHost> with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _mustShowAlert(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("firstTime") == null) {
      Future.delayed(Duration.zero, () => _showAlert(context));
    }
  }

  void _showAlert(BuildContext context) {
    TextStyle style = new TextStyle(
      fontSize: 18.0,
      color: Colors.white,
      inherit: true,
    );

    Widget alertText = new RichText(
      textAlign: TextAlign.justify,
      text: new TextSpan(
        text: SitLocalizations.of(context).disclaimerText1,
        style: style,
        children: [
          new TextSpan(
            text: '(PDF)',
            style: TextStyle(
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              color: primarySwatch['accent'],
            ),
            recognizer: new TapGestureRecognizer()
              ..onTap = () => _launchURL(PPG.PAPER_URL),
          ),
          new TextSpan(
            text: SitLocalizations.of(context).disclaimerText2,
            style: style,
          ),
        ],
      ),
    );

    Widget alertButton = new RaisedButton(
      shape: new RoundedRectangleBorder(
        side: BorderSide(
          width: 1.0,
          color: Colors.white,
        ),
        borderRadius: new BorderRadius.circular(10.0),
      ),
      color: primarySwatch['containerBackground'],
      disabledColor: primarySwatch['disabledButton'],
      textColor: Colors.white,
      disabledTextColor: Color(0x66ffffff),
      child: Text(
        SitLocalizations.of(context).disclaimerButtonLabel.toUpperCase(),
      ),
      onPressed: () {
        prefs.setBool("firstTime", true);
        Navigator.pop(context);
      },
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                margin: EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    alertText,
                    SizedBox(
                      height: 50.0,
                    ),
                    alertButton,
                  ],
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  border: new Border.all(
                    width: 2.0,
                    color: primarySwatch['primaryDark'],
                  ),
                  color: primarySwatch['containerBackground'],
                ),
              ),
            ],
          ),
    );
  }

  _createNavigationViews() {
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: new SvgPicture.asset('assets/icons/icon_ppg.svg'),
        title: SitLocalizations.of(context).ppgTabTitle,
        screenTitle: SitLocalizations.of(context).ppgTitle,
        color: primarySwatch['containerBackground'],
        vsync: this,
      ),
      NavigationIconView(
        icon: new SvgPicture.asset('assets/icons/icon_rohrich.svg'),
        title: SitLocalizations.of(context).rohrichTabTitle,
        screenTitle: SitLocalizations.of(context).rohrichScreenTitle,
        color: primarySwatch['containerBackground'],
        vsync: this,
      ),
      NavigationIconView(
        icon: new SvgPicture.asset('assets/icons/icon_bibliography.svg'),
        title: SitLocalizations.of(context).bibliographyTabTitle,
        screenTitle: SitLocalizations.of(context).bibliographyTitle,
        color: primarySwatch['containerBackground'],
        vsync: this,
      ),
      NavigationIconView(
        icon: new SvgPicture.asset('assets/icons/icon_about_us.svg'),
        title: SitLocalizations.of(context).aboutUsTabTitle,
        screenTitle: SitLocalizations.of(context).aboutUsTitle,
        color: primarySwatch['containerBackground'],
        vsync: this,
      ),
    ];

    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    transitions.add(_navigationViews[0].transition(context, PPG()));
    transitions.add(_navigationViews[1].transition(context, Rohrich()));
    transitions.add(_navigationViews[2].transition(context, Bibliography()));
    transitions.add(_navigationViews[3].transition(context, AboutUs()));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    _createNavigationViews();
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      fixedColor: Colors.red,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    _mustShowAlert(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(12.0),
          child: new Image.asset("assets/icons/icon_app_bar.png"),
        ),
        automaticallyImplyLeading: true,
        title: Text(
          _navigationViews[_currentIndex].screenTitle,
        ),
        backgroundColor: primarySwatch['containerBackground'],
      ),
      body: Container(
        child: Center(
          child: _buildTransitionsStack(),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2.0, color: primarySwatch['primaryDark']),
          ),
        ),
      ),
      bottomNavigationBar: botNavBar,
    );
  }
}
