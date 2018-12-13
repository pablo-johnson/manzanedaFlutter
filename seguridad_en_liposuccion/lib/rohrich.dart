import 'package:flutter/material.dart';
import 'main.dart';
import 'lang/sit_localizations.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class Rohrich extends StatefulWidget {
  @override
  _RohrichState createState() => _RohrichState();
}

class _RohrichState extends State<Rohrich> {
  final _inputKey = GlobalKey(debugLabel: 'safeArea');
  bool _isResultButtonEnabled = false;
  bool _isResultVisible = false;
  double ySize = 0.0;
  double _rohrich = 0.0;
  String _rohrichString = '';
  double _aspirate = 0.0;
  double _infiltrated = 0.0;
  double _endovenous = 0.0;

  FocusNode _nodeText1 = FocusNode();
  FocusNode _nodeText2 = FocusNode();
  FocusNode _nodeText3 = FocusNode();

  _onLayoutDone(_) {
    final RenderBox box = _inputKey.currentContext.findRenderObject();
    final currentY = box.localToGlobal(Offset.zero).dy + box.size.height;
    final totalSize = MediaQuery.of(context).size.height;
    double possibleSpacer = totalSize - currentY;
    if (Theme.of(context).platform == TargetPlatform.android) {
      possibleSpacer -= 36;
    }

    if (possibleSpacer > 0.0) {
      setState(() {
        ySize = possibleSpacer;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    super.initState();
  }

  _getRohrichResultMessage(double rohrich) {
    String _rohroh = rohrich.abs().toStringAsFixed(2);
    List<String> list = [_rohroh];
    if (rohrich > 0) {
      _rohrichString =
          sprintf(SitLocalizations.of(context).deficitMessage, list);
    } else if (rohrich < 0) {
      _rohrichString = sprintf(SitLocalizations.of(context).superMessage, list);
    } else {
      _rohrichString = SitLocalizations.of(context).correctBalance;
    }
  }

  double _calculateRohrich() {
    if (_aspirate > 0 && _infiltrated > 0 && _endovenous > 0) {
      double k = _aspirate <= 5000 ? 1.8 : 1.2;
      double x1 = _aspirate * k;
      double x2 = _infiltrated + _endovenous;
      double result = x1 - x2;
      if (result < 1 && result > -1) {
        result = 0;
      }
      _getRohrichResultMessage(result);
      return result;
    }
    return 0.0;
  }

  bool _checkIfEnableButton() {
    _isResultButtonEnabled =
        _aspirate > 0 && _infiltrated > 0 && _endovenous > 0;
    _rohrich = _calculateRohrich();
    if (!_isResultButtonEnabled) {
      _isResultVisible = false;
      // return false;
    }
    return true;
  }

  void _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _nextFocus(FocusNode newFocus) {
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    Widget endovenousLiquidWidget = TextField(
      focusNode: _nodeText3,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: SitLocalizations.of(context).intravenousFluidHint,
        border: InputBorder.none,
        suffixText: 'cc.',
        labelStyle: TextStyle(color: primarySwatch['accent']),
        suffixStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      maxLines: 1,
      onChanged: (text) {
        try {
          _endovenous = double.parse(text);
        } catch (e) {
          _endovenous = 0.0;
        }
        if (_checkIfEnableButton()) {
          setState(() {});
        }
      },
      onSubmitted: (text) {
        if (_rohrich != 0) {
          setState(() {
            _rohrich = _calculateRohrich();
            _isResultVisible = true;
            _hideKeyboard();
          });
        }
      },
    );

    Widget surgeonLiquidWidget = TextField(
      focusNode: _nodeText2,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: SitLocalizations.of(context).infiltratedLiquidHint,
        border: InputBorder.none,
        suffixText: 'cc.',
        labelStyle: TextStyle(color: primarySwatch['accent']),
        suffixStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      maxLines: 1,
      onChanged: (text) {
        try {
          _infiltrated = double.parse(text);
        } catch (e) {
          _infiltrated = 0.0;
        }
        if (_checkIfEnableButton()) {
          setState(() {});
        }
      },
      onSubmitted: (String value) {
        _nextFocus(_nodeText3);
      },
    );

    Widget aspirateWidget = TextField(
      focusNode: _nodeText1,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: SitLocalizations.of(context).aspiradoTotalHint,
        border: InputBorder.none,
        suffixText: 'cc.',
        labelStyle: TextStyle(color: primarySwatch['accent']),
        suffixStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(
        color: Colors.white,
      ),
      maxLines: 1,
      onChanged: (text) {
        try {
          _aspirate = double.parse(text);
        } catch (e) {
          _aspirate = 0.0;
        }
        if (_checkIfEnableButton()) {
          setState(() {});
        }
      },
      onSubmitted: (String value) {
        _nextFocus(_nodeText2);
      },
    );

    Widget formWidget = Form(
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
            aspirateWidget,
            surgeonLiquidWidget,
            endovenousLiquidWidget,
          ],
        ),
      ),
    );

    Widget resultButtonWidget = RaisedButton(
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
        SitLocalizations.of(context).rohrichButtonLabel.toUpperCase(),
      ),
      onPressed: _isResultButtonEnabled
          ? () {
              _hideKeyboard();
              setState(() {
                _rohrich = _calculateRohrich();
                _isResultVisible = true;
              });
            }
          : null,
    );

    Widget resultContainer = AnimatedOpacity(
      opacity: _isResultVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          border: new Border.all(
            width: 2.0,
            color: primarySwatch['primaryDark'],
          ),
          color: primarySwatch['containerBackground'],
        ),
        child: Center(
          child: Text(
            _rohrichString,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    Widget disclaimer = new Text(
      SitLocalizations.of(context).rohrichDisclaimerText,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontSize: 11.0,
        fontStyle: FontStyle.italic,
        color: Colors.black87,
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
                resultButtonWidget,
                resultContainer,
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

    Widget actionForm = FormKeyboardActions(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: primarySwatch["containerBackground"],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: _nodeText1,
          closeWidget: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _hideKeyboard();
            },
          ),
          displayCloseWidget: true,
        ),
        KeyboardAction(
          focusNode: _nodeText2,
          closeWidget: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _hideKeyboard();
            },
          ),
        ),
        KeyboardAction(
          focusNode: _nodeText3,
          closeWidget: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Text(
              SitLocalizations.of(context).done,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTapAction: () {
            if (_isResultButtonEnabled) {
              setState(() {
                _rohrich = _calculateRohrich();
                _isResultVisible = true;
                _hideKeyboard();
              });
            }
          },
        ),
      ],
      child: safeArea,
    );

    return actionForm;
  }
}
