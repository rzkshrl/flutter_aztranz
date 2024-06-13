import 'package:az_travel/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../theme/textstyle.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: light,
        body: Center(
          child:
              Lottie.asset('assets/lottie/loading_aztravel.json', height: 135),
        ),
      ),
    );
  }
}

Future<void> simulateDelay() async {
  await Future.delayed(const Duration(milliseconds: 1500));
}

Future<void> simulateDelayShorter() async {
  await Future.delayed(const Duration(milliseconds: 750));
}

Widget loadingProp() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: 25.h,
      ),
      Center(
        child: Lottie.asset('assets/lottie/loading_aztravel.json', height: 135),
      ),
    ],
  );
}

Widget dialogLoading(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: light,
    child: SizedBox(
      height: 30.h,
      width: 50.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 10.h,
            decoration: BoxDecoration(
                border: Border.all(color: blue_0C134F, width: 2.0),
                borderRadius: BorderRadius.circular(12)),
            child: Lottie.asset(
              'assets/lottie/loading_aztravel.json',
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Memuat...',
            textAlign: TextAlign.center,
            style: getTextAlert(),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    ),
  );
}
