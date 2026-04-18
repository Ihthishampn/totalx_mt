import 'dart:async';

import 'package:flutter/material.dart';

// for back 2 times if 1 time it no pop back alllowww
class DoubleBackPressWrapper extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration resetDuration;

  const DoubleBackPressWrapper({
    super.key,
    required this.child,
    this.message = 'Press back again to go back',
    this.resetDuration = const Duration(seconds: 2),
  });

  @override
  State<DoubleBackPressWrapper> createState() => _DoubleBackPressWrapperState();
}

class _DoubleBackPressWrapperState extends State<DoubleBackPressWrapper> {
  int _backPressCount = 0;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    _backPressCount++;

    if (_backPressCount == 1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.message),
            duration: widget.resetDuration,
          ),
        );
      }

      _resetTimer?.cancel();
      _resetTimer = Timer(widget.resetDuration, () {
        _backPressCount = 0;
      });

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop, child: widget.child);
  }
}
