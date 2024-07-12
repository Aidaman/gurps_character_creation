import 'package:flutter/material.dart';

enum ButtonStyles { DEFAULT }

class ButtonStylesGetter {
  static final ButtonStyle _defaultButtonStyle = FilledButton.styleFrom(
    backgroundColor: Colors.red[800],
    foregroundColor: Colors.white,
  );

  static ButtonStyle getStyle(ButtonStyles buttonStyles) {
    switch (buttonStyles) {
      case ButtonStyles.DEFAULT:
        return _defaultButtonStyle;
    }
  }
}
