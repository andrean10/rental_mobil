import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatDateTime {
  static String dateToString({
    bool isIndonesian = false,
    String? oldPattern,
    required String newPattern,
    required String value,
  }) {
    DateTime inputDate;

    if (oldPattern != null) {
      String? locale;
      if (isIndonesian) {
        locale = 'id_ID';
      }

      final inputFormat = DateFormat(oldPattern, locale);
      inputDate = inputFormat.parse(value);
    } else {
      inputDate = DateTime.parse(value);
    }

    final outputFormat = DateFormat(newPattern, 'id_ID');
    return outputFormat.format(inputDate);
  }

  static DateTime dateToDateTime({
    required String pattern,
    required String value,
  }) {
    var inputFormat = DateFormat(pattern, 'id_ID');
    var inputDate = inputFormat.parse(value);
    return inputDate;
  }

  static String timeToString({
    required String newPattern,
    required TimeOfDay value,
  }) {
    var outputFormat = DateFormat(newPattern, 'id_ID');
    var outputTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      value.hour,
      value.minute,
    );
    return outputFormat.format(outputTime);
  }
}
