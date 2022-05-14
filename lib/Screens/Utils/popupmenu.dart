import 'package:flutter/material.dart';
import 'package:gymadminapp/Screens/Utils/adminpassworddialog.dart';
import 'package:gymadminapp/constants.dart';

PopupMenuButton<int> popupMenuButton(BuildContext context) {
  return PopupMenuButton<int>(
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(
              2.0,
              2.0,
            ),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ), //BoxShadow
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ], borderRadius: BorderRadius.circular(10), color: Colors.indigo),
        margin: const EdgeInsets.fromLTRB(0, 7, 20, 7),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Text('Hi Admin', style: Theme.of(context).textTheme.headline4),
      ),
      onSelected: (value) {
        showDialog(
            context: context,
            builder: (context) => adminPasswordDialog(context, value));
      },
      itemBuilder: (context) => [
            PopupMenuItem(
                value: UPDATE_PLAN,
                child: Text("Plans",
                    style: Theme.of(context).textTheme.bodyText1)),
            const PopupMenuDivider(),
            PopupMenuItem(
                value: UPDATE_ADMIN_PASS,
                child: Text("Change Admin Password",
                    style: Theme.of(context).textTheme.bodyText1))
          ]);
}
