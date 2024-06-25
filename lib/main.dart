// import 'package:advacalc/advan_screen.dart';
import 'package:advacalc/home_screen.dart';
// import 'package:advacalc/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), // Example design size
      builder: (context, child) {
        return MaterialApp(
          home: HomePage(),
        );
      },
    );
  }
}
