import 'package:flutter/material.dart';
import 'package:gymadminapp/Screens/addUserPage.dart';
import 'package:gymadminapp/Screens/homepage.dart';
import 'package:gymadminapp/Screens/manageuserpage.dart';
import 'package:gymadminapp/Screens/updatePlan.dart';
import 'package:gymadminapp/constants.dart';

Dialog adminPasswordDialog(BuildContext context, int value) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: SizedBox(
        height: 350,
        width: 400,
        child: Column(
          children: [
            showHeader(context),
            passwordTextbox(context, value),
          ],
        ),
      ),
    );

Widget passwordTextbox(BuildContext context, int value) {
  final formKey = GlobalKey<FormState>();
  String password = "";
  return Container(
    margin: const EdgeInsets.all(20),
    child: Form(
      key: formKey,
      child: Column(
        children: [
          Text(
            "Enter Password",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.amber)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red))),
              cursorColor: Colors.black,
              onSaved: (newValue) {
                password = newValue!;
              },
              validator: (value) {
                const HomePage().getAdminPassword();
                if (value!.isEmpty) {
                  return "Please Enter Password";
                } else if (HomePage.adminPassword == null) {
                  return "Network error... Please try again later";
                } else if (value != HomePage.adminPassword) {
                  return "Password Incorrect";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.indigo[700], onPrimary: Colors.white),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                if (password == HomePage.adminPassword) {
                  switch (value) {
                    case UPDATE_PLAN:
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const UpdatePlan(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                      break;
                    case UPDATE_ADMIN_PASS:
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const AddUserPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                      break;
                    case MANAGE_USER:
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ManageUserPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                      break;
                  }
                }
              }
            },
            child: const Text('Submit'),
          )
        ],
      ),
    ),
  );
}

Widget showHeader(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(30),
    child: Text(
      "Admin Password",
      style: Theme.of(context).textTheme.headline1,
    ),
  );
}
