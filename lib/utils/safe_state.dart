import 'package:flutter/material.dart';

/// A mixin that provides safe setState functionality for StatefulWidgets
mixin SafeState<T extends StatefulWidget> on State<T> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
  }

  /// Safely calls setState only if the widget is still mounted
  void safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  /// Cancels all animation controllers and timers in dispose
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
