import 'dart:developer';

import 'package:flutter/material.dart';

class KeypadButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  const KeypadButton({Key? key, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: onPressed,
          onTapUp: (details) => true,
          onTapDown: (details) => false,
          child: child!,
        ),
      ),
    );
  }
}