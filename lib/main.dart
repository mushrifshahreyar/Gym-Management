import 'dart:io';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/billbloc.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Screens/homepage.dart';
import 'package:window_size/window_size.dart';

const apiKey = "AIzaSyBCdVTaYj3tFEXXkTrULakuo3-g7y5v4i4";
const projectId = "gymapp-2aecd";

void main() {
  runApp(const MyApp());
  Firestore.initialize(projectId);
  if (Platform.isLinux || Platform.isWindows) {
    setWindowTitle('Gym App');
    // setWindowMinSize(const Size(1080, 780));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gym App',
        theme: ThemeData(
            primarySwatch: Colors.yellow,
            textTheme: const TextTheme(
              headline1: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontSize: 22),
              headline2: TextStyle(
                  fontFamily: 'Arial',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 18,
                  letterSpacing: 0.6),
              headline3: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16),
              headline4: TextStyle(
                  fontFamily: 'IBM Plex Sans Arabic',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 0.6),
              headline5: TextStyle(
                  fontFamily: 'Arial',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16,
                  letterSpacing: 0.6),
              headline6: TextStyle(
                  fontFamily: 'Arial',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18,
                  letterSpacing: 0.6),
              bodyText1: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 18,
                  letterSpacing: 0.6),
              bodyText2: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 28,
                  letterSpacing: 0.6),
              labelMedium: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 18,
                  letterSpacing: 0.6),
            )),
        home: const HomePage());
    // home: HomePageInherited(
    //   billBloc: billBloc,
    //   userBloc: userBloc,
    //   child: const HomePage(),
    // ));
  }
}

class HomePageInherited extends InheritedWidget {
  const HomePageInherited(
      {required Widget child, required this.userBloc, required this.billBloc})
      : super(child: child);
  final UserBloc userBloc;
  final BillBloc billBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static HomePageInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomePageInherited>();
  }
}
