import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    // Remove the '#' if present
    String formattedHex = hexColor.replaceAll('#', '');

    // Add alpha channel if not present (assuming fully opaque)
    if (formattedHex.length == 6) {
      formattedHex = 'FF$formattedHex';
    }

    // Convert the hex string to an integer
    return int.parse(formattedHex, radix: 16);
  }
}
