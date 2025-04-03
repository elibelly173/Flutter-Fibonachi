import 'package:flutter/material.dart';

/// A mixin that provides safe setState functionality for StatefulWidgets
mixin SafeState<T extends StatefulWidget> on State<T> {
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _mounted = true;
  }

  /// Safely calls setState only if the widget is still mounted
  void safeSetState(VoidCallback action) {
    if (_mounted && mounted) {
      setState(action);
    }
  }

  /// Cancels all animation controllers and timers in dispose
  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
