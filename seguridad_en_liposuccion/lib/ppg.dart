import 'package:flutter/material.dart';
import 'main.dart';
import 'lang/sit_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PPG extends StatefulWidget {

  static const String PAPER_URL = "https://drive.google.com/file/d/1ckswqWcVgOcvpE3meApcrhuDDNMo_z8_";
  // static const String PAPER_URL = "https://drive.google.com/file/d/1jv28RH_PO2uSZVnqtN4cqyzEfEULAkCT";

  @override
  _PPGState createState() => _PPGState();
}

class _PPGState extends State<PPG> {
  final _inputKey = GlobalKey(debugLabel: 'safeArea');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const double _formFontSize = 14.0;
  static const double _minHemoglobine = 10.0;
  double _pps = 0.0;
  double _ppg = 0.0;
  double _weight = 0.0;
  double _volume = 0.0;
  double _initialHemoglobine = 0.0;
  double _age = 0.0;
  bool _isPpgButtonEnabled = false;
  List<String> _allGenders;
  double ySize = 0.0;
  bool _isPpgVisible = false;

  FocusNode _nodeText1 = FocusNode();
  FocusNode _nodeText2 = FocusNode();
  FocusNode _nodeText3 = FocusNode();

  double _calculatePps() {
    if (_weight > 0 && _volume > 0 && _initialHemoglobine > 0) {
      return (_initialHemoglobine - _minHemoglobine) *
          _volume *
          _weight /
          _initialHemoglobine;
    } else {
      return 0.0;
    }
  }

  bool _checkIfEnableButton() {
    _pps = _calculatePps();
    _isPpgButtonEnabled =
        _weight > 0 && _volume > 0 && _initialHemoglobine > 0 && _age > 0;
    if (!_isPpgButtonEnabled) {
      _isPpgVisible = false;
    }
    if (_pps > 0) {
      _ppg = _calculatePpg();
      return true;
    } else if (_ppg > 0) {
      _ppg = 0;
      return true;
    } else {
      _ppg = 0;
      return false;
    }
  }

  double _calculatePpg() {
    if (_age == 0) {
      return 0;
    }
    return 383.725 + (3.406 * _pps) - (29.116 * _age);
  }

  _getAllGenders() {
    _allGenders = <String>[
      SitLocalizations.of(context).selectGenderLabel,
      SitLocalizations.of(context).maleGender,
      SitLocalizations.of(context).femaleGender,
    ];
  }

  _launchURL(String url) async {
    await launch(url);
  }

  _onLayoutDone(_) {
    final RenderBox box = _inputKey.currentContext.findRenderObject();
    final currentY = box.localToGlobal(Offset.zero).dy + box.size.height;
    final totalSize = MediaQuery.of(context).size.height;
    double possibleSpacer = totalSize - currentY;
    if (Theme.of(context).platform == TargetPlatform.android) {
      possibleSpacer -= 64;
    }

    if (possibleSpacer > 0.0) {
      setState(() {
        ySize = possibleSpacer;
      });
    }
  }

  _hideKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getAllGenders();
    String _gender = _allGenders[0];

    Widget weightField = TextField(
      keyboardType: TextInputType.number,
      focusNode: _nodeText1,
      decoration: InputDecoration(
        labelText: SitLocalizations.of(context).weightHint,
        border: InputBorder.none,
        suffixText: 'Kg.',
        labelStyle: TextStyle(color: primarySwatch['accent']),
        suffixStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      maxLines: 1,
      onChanged: (text) {
        try {
          _weight = double.parse(text);
        } catch (e) {
          _weight = 0.0;
        }
        if (_checkIfEnableButton()) {
          setState(() {});
        }
      },
    );

    Widget volumeFieldWidget = Text(
      SitLocalizations.of(context).volumeLabel,
      style: TextStyle(
        color: Colors.white,
        fontSize: _formFontSize,
      ),
    );

    Widget volumeWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        volumeFieldWidget,
        Spacer(),
        Theme(
          // This sets the color of the [DropdownMenuItem]
          data: Theme.of(context).copyWith(
            canvasColor: primarySwatch['accent'],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _gender,
              hint: Text(SitLocalizations.of(context).selectGenderLabel),
              onChanged: (String newValue) {
                setState(() {
                  _gender = newValue;
                  if (_gender == _allGenders[0]) {
                    _volume = 0.0;
                  } else if (_gender == _allGenders[1]) {
                    _volume = 75.0;
                  } else if (_gender == _allGenders[2]) {
                    _volume = 65.0;
                  }
                  _checkIfEnableButton();
                });
              },
              items: _allGenders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    width: 140.0,
                    alignment: Alignment.centerRight,
                    child: Text(
                      value,
                      softWrap: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _formFontSize,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );

    Widget minimumHemoglobineWidget = TextFormField(
      keyboardType: TextInputType.number,
      initialValue: "10",
      enabled: false,
      decoration: InputDecoration(
        //errorText: _showValidationError ? 'Invalid number entered' : null,
        labelText: SitLocalizations.of(context).minimumHemoglobin,
        border: InputBorder.none,
        suffixText: 'g/dL',
        labelStyle: TextStyle(color: primarySwatch['accent']),
        suffixStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      maxLines: 1,
    );

    Widget hemoglobineField = TextField(
      keyboardType: TextInputType.number,
      focusNode: _nodeText2,
      decoration: InputDecoration(
        labelText: SitLocalizations.of(context).initialHemoglobin,
        border: InputBorder.none,
        suffixText: 'g/dl',
        labelStyle: TextStyle(color: primarySwatch['accent']),
        suffixStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      maxLines: 1,
      onChanged: (text) {
        try {
          _initialHemoglobine = double.parse(text);
        } catch (e) {
          _initialHemoglobine = 0.0;
        }
        if (_checkIfEnableButton()) {
          setState(() {});
        }
      },
    );

    Widget ppsLabelWidget = Text(
      SitLocalizations.of(context).ppsLabel,
      style: TextStyle(
        color: Colors.white,
        fontSize: _formFontSize,
      ),
    );

    Widget ppsValueWidget = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5.0),
      constraints: BoxConstraints(
        minWidth: 20.0,
      ),
      decoration: BoxDecoration(
        color: primarySwatch['accent'],
        borderRadius: new BorderRadius.circular(7.0),
        border: Border.all(
          width: 2.0,
          color: primarySwatch['accent'],
        ),
      ),
      child: Text(
        _pps > 0 ? _pps.toStringAsFixed(2) : "?",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    Widget ppsWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ppsLabelWidget,
        Spacer(),
        ppsValueWidget,
      ],
    );

    Widget ageWidget = TextField(
      keyboardType: TextInputType.number,
      focusNode: _nodeText3,
      decoration: InputDecoration(
        labelText: SitLocalizations.of(context).ageHint,
        border: InputBorder.none,
        suffixText: SitLocalizations.of(context).ageUnit,
        labelStyle: TextStyle(color: primarySwatch['accent']),
        suffixStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      maxLines: 1,
      onChanged: (text) {
        try {
          _age = double.parse(text);
        } catch (e) {
          _age = 0.0;
        }
        if (_checkIfEnableButton()) {
          setState(() {});
        }
      },
    );

    Widget formWidget = Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          border: new Border.all(
            width: 2.0,
            color: primarySwatch['primaryDark'],
          ),
          color: primarySwatch['containerBackground'],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            weightField,
            volumeWidget,
            minimumHemoglobineWidget,
            hemoglobineField,
            ppsWidget,
            ageWidget,
          ],
        ),
      ),
    );

    Widget ppgButton = RaisedButton(
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
        SitLocalizations.of(context).ppgButtonLabel.toUpperCase(),
      ),
      onPressed: _isPpgButtonEnabled
          ? () {
              FocusScope.of(context).requestFocus(new FocusNode());
              setState(() {
                _ppg = _calculatePpg();
                _isPpgVisible = true;
              });
            }
          : null,
    );

    Widget ppgContainer = Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        border: new Border.all(
          width: 2.0,
          color: primarySwatch['primaryDark'],
        ),
        color: primarySwatch['containerBackground'],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text(
              SitLocalizations.of(context).pflMessage,
              style: TextStyle(
                color: primarySwatch['accent'],
                fontSize: 15.0,
              ),
            ),
          ),
          Center(
            child: Text(
              _ppg.toStringAsFixed(2) + " cc",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
          ),
        ],
      ),
    );

    TextStyle style = new TextStyle(
      fontSize: 11.0,
      fontStyle: FontStyle.italic,
      color: Colors.black87,
    );
    Widget disclaimer = new RichText(
      textAlign: TextAlign.justify,
      text: new TextSpan(
        text: SitLocalizations.of(context).disclaimerText1,
        style: style,
        children: [
          new TextSpan(
            text: '(PDF)',
            style: TextStyle(
              fontSize: 11.0,
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

    Widget safeArea = SafeArea(
      key: _inputKey,
      top: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 5.0,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                formWidget,
                ppgButton,
                AnimatedOpacity(
                  opacity: _isPpgVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 1000),
                  child: ppgContainer,
                ),
                SizedBox(
                  height: ySize,
                ),
                disclaimer,
              ],
            ),
          ),
        ),
      ),
    );

    Widget actionForm = KeyboardActions(
      config: KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        keyboardBarColor: primarySwatch["containerBackground"],
        nextFocus: true,
        actions: [
          KeyboardActionsItem(
            focusNode: _nodeText1,
            toolbarButtons: [
              (node) {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _hideKeyboard();
                  },
                );
              },
            ],
          ),
          KeyboardActionsItem(
            focusNode: _nodeText2,
            toolbarButtons: [
              (node) {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _hideKeyboard();
                  },
                );
              },
            ],
          ),
          KeyboardActionsItem(
            focusNode: _nodeText3,
            toolbarButtons: [
              (node) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Text(
                    SitLocalizations.of(context).done,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ],
            onTapAction: () {
              if (_isPpgButtonEnabled) {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(
                  () {
                    _ppg = _calculatePpg();
                    _isPpgVisible = true;
                  },
                );
              }
            },
          ),
        ],
      ),
      child: safeArea,
    );

    return actionForm;
  }
}
