import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void showSnackBar({
  required Widget content,
  SnackBarAction? action,
  Color? backgroundColor,
  Duration? duration = const Duration(seconds: 1),
  SnackBarBehavior? behavior = SnackBarBehavior.floating,
  DismissDirection dismissDirection = DismissDirection.down,
  bool showCloseIcon = false,
}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: content,
      action: action,
      backgroundColor: backgroundColor,
      duration: duration!,
      behavior: behavior,
      showCloseIcon: showCloseIcon,
      dismissDirection: dismissDirection,
    ),
  );
}

String checkDayMessage() {
  final hoursNow = DateTime.now().hour;
  var messageDay = "";

  if (hoursNow >= 05 && hoursNow <= 10) {
    messageDay = 'Pagi';
  } else if (hoursNow >= 11 && hoursNow <= 14) {
    messageDay = 'Siang';
  } else if (hoursNow >= 15 && hoursNow <= 17) {
    messageDay = 'Sore';
  } else {
    messageDay = 'Malam';
  }
  return messageDay;
}

String formatedDateToString({
  String? oldPattern,
  required String newPattern,
  required String? value,
}) {
  if (value == null) return '-';

  DateTime inputDate;

  if (oldPattern != null) {
    final inputFormat = DateFormat(oldPattern);
    inputDate = inputFormat.parse(value);
  } else {
    inputDate = DateTime.parse(value);
  }

  final outputFormat = DateFormat(newPattern, 'id_ID');
  return outputFormat.format(inputDate);
}

String generateRandomFileName() {
  var now = DateTime.now();
  var random = Random();
  var randomString = random.nextInt(10000).toString();
  return 'file_${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}_$randomString';
}