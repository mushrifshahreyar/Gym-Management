import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/billbloc.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Screens/Fragments/infosection.dart';
import 'package:gymadminapp/Screens/Fragments/trainersection.dart';
import 'package:gymadminapp/Screens/Fragments/usersection.dart';
import 'package:gymadminapp/Screens/Utils/popupmenu.dart';
import 'package:gymadminapp/main.dart';

class HomePage extends StatelessWidget {
  static UserBloc userBLoc = UserBloc();
  static BillBloc billBloc = BillBloc();
  static String? adminPassword;
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getAdminPassword();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Gym App',
            style: Theme.of(context).textTheme.headline1,
          ),
          actions: [popupMenuButton(context)],
        ),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, child: UserSection()),
              ),
              Expanded(
                flex: 2,
                child: TrainerSection(),
              ),
              Expanded(
                flex: 3,
                child: InfoSection(),
              ),
            ],
          ),
        ));
  }

  Future<void> getAdminPassword() async {
    if (adminPassword == null) {
      await Firestore(projectId)
          .collection("Admin")
          .document("adminPassword")
          .get()
          .then((value) {
        HomePage.adminPassword = value['pass'];
      });
    }
  }
}
