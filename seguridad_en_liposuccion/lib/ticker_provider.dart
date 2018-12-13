import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
export 'package:flutter/scheduler.dart' show TickerProvider;

/// Provides [Ticker] objects that are configured to only tick while the current
/// tree is enabled, as defined by [TickerMode].
///
/// To create an [AnimationController] in a class that uses this mixin, pass
/// `vsync: this` to the animation controller constructor whenever you
/// create a new animation controller.
///
/// If you only have a single [Ticker] (for example only a single
/// [AnimationController]) for the lifetime of your [State], then using a
/// [SingleTickerProviderStateMixin] is more efficient. This is the common case.
@optionalTypeArgs
abstract class TickerProviderStateMixin<T extends StatefulWidget> extends State<T> implements TickerProvider {
  // This class is intended to be used as a mixin, and should not be
  // extended directly.
  factory TickerProviderStateMixin._() => null;

  Set<Ticker> _tickers;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _tickers ??= Set<_WidgetTicker>();
    final _WidgetTicker result = _WidgetTicker(onTick, this, debugLabel: 'created by $this');
    _tickers.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers.contains(ticker));
    _tickers.remove(ticker);
  }

  @override
  void dispose() {
    assert(() {
      if (_tickers != null) {
        for (Ticker ticker in _tickers) {
          if (ticker.isActive) {
            throw FlutterError(
              '$this was disposed with an active Ticker.\n'
              '$runtimeType created a Ticker via its TickerProviderStateMixin, but at the time '
              'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
              'be disposed before calling super.dispose(). Tickers used by AnimationControllers '
              'should be disposed by calling dispose() on the AnimationController itself. '
              'Otherwise, the ticker will leak.\n'
              'The offending ticker was: ${ticker.toString(debugIncludeStack: true)}'
            );
          }
        }
      }
      return true;
    }());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final bool muted = !TickerMode.of(context);
    if (_tickers != null) {
      for (Ticker ticker in _tickers) {
        ticker.muted = muted;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Set<Ticker>>(
      'tickers',
      _tickers,
      description: _tickers != null ?
        'tracking ${_tickers.length} ticker${_tickers.length == 1 ? "" : "s"}' :
        null,
      defaultValue: null,
    ));
  }
}

// This class should really be called _DisposingTicker or some such, but this
// class name leaks into stack traces and error messages and that name would be
// confusing. Instead we use the less precise but more anodyne "_WidgetTicker",
// which attracts less attention.
class _WidgetTicker extends Ticker {
  _WidgetTicker(TickerCallback onTick, this._creator, { String debugLabel }) : super(onTick, debugLabel: debugLabel);

  final TickerProviderStateMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}