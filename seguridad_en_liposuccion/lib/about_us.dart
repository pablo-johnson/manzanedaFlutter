import 'package:flutter/material.dart';
import 'main.dart';
import 'lang/sit_localizations.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    Widget raulImage = new Container(
      alignment: Alignment.center,
      width: 80.0,
      height: 80.0,
      decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          image: new ExactAssetImage('assets/icons/raul.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(
          new Radius.circular(50.0),
        ),
        border: new Border.all(
          color: Colors.white30,
          width: 2.0,
        ),
      ),
    );

    TextStyle nameStyle = TextStyle(
      color: primarySwatch['accent'],
      fontSize: 23.0,
    );

    TextStyle bioStyle = TextStyle(
      color: Colors.white,
      fontSize: 17.0,
    );

    Widget raulNameText = Container(
      alignment: Alignment.centerLeft,
      child: Text(
        SitLocalizations.of(context).raulName,
        maxLines: 2,
        softWrap: true,
        style: nameStyle,
      ),
    );

    Widget raulBiographyText = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        SitLocalizations.of(context).biography1,
        softWrap: true,
        style: bioStyle,
      ),
    );

    Widget raulBioContainer = Expanded(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            raulNameText,
            raulBiographyText,
          ],
        ),
      ),
    );

    Widget raulContainer = Container(
      child: Row(
        children: <Widget>[
          raulImage,
          raulBioContainer,
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white24),
        ),
      ),
    );

    Widget fiorellaImage = new Container(
      alignment: Alignment.center,
      width: 80.0,
      height: 80.0,
      decoration: new BoxDecoration(
        color: const Color(0xff7c94b6),
        image: new DecorationImage(
          image: new ExactAssetImage('assets/icons/fiorella.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(
          new Radius.circular(50.0),
        ),
        border: new Border.all(
          color: Colors.white30,
          width: 2.0,
        ),
      ),
    );

    Widget fiorellaNameText = Container(
      alignment: Alignment.centerLeft,
      child: Text(
        SitLocalizations.of(context).fiorellaName,
        textAlign: TextAlign.start,
        maxLines: 2,
        softWrap: true,
        style: nameStyle,
      ),
    );

    Widget fiorellaBiographyText = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        SitLocalizations.of(context).biography3,
        softWrap: true,
        style: bioStyle,
      ),
    );

    Widget fiorellaBioContainer = Expanded(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            fiorellaNameText,
            fiorellaBiographyText,
          ],
        ),
      ),
    );

    Widget fiorellaContainer = Container(
      child: Row(
        children: <Widget>[
          fiorellaImage,
          fiorellaBioContainer,
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white24),
        ),
      ),
    );

    Widget noteWidget = Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Text(
        SitLocalizations.of(context).welcomeText,
        textAlign:TextAlign.justify,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
      ),
    );
    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          border: new Border.all(
            width: 2.0,
            color: primarySwatch['primaryDark'],
          ),
          color: primarySwatch['containerBackground'],
        ),
        child: ListView(
          children: <Widget>[
            raulContainer,
            fiorellaContainer,
            noteWidget,
          ],
        ));
  }
}
