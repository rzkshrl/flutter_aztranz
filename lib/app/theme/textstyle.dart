import 'package:az_travel/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

var context = Get.context!;

getTextAlert(BuildContext context1) {
  return TextStyle(
      color: Theme.of(context).textTheme.titleMedium!.color, fontSize: 12.sp);
}

getTextAlertSub(BuildContext context1) {
  return TextStyle(
      color: Theme.of(context).textTheme.titleMedium!.color, fontSize: 8.sp);
}

getTextAlertBtn(BuildContext context1) {
  return TextStyle(
      color: Theme.of(context).textTheme.titleMedium!.color, fontSize: 10.sp);
}

getTextErrorFormLogin() {
  return TextStyle(
    fontSize: 10.sp,
    color: light,
    background: Paint()
      ..strokeWidth = 16
      ..color = errorBg
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round,
  );
}

getTextUnderBtn(BuildContext context1) {
  return TextStyle(
    color: Theme.of(context).textTheme.titleMedium!.color,
    fontSize: 8.sp,
  );
}
