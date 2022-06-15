import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'package:gymadminapp/Screens/Fragments/useraddForm.dart';
import 'package:gymadminapp/Screens/Fragments/userbillForm.dart';
import 'package:gymadminapp/Screens/Utils/popupmenu.dart';
import 'package:gymadminapp/Screens/homepage.dart';
import 'package:gymadminapp/constants.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class AddUserPage extends StatelessWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = User.newInstance();
    final formKey = GlobalKey<FormState>();
    final totalAmountkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add User',
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [popupMenuButton(context)],
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        child: Row(children: [
          Expanded(
            flex: 5,
            child: ShowForm(formKey: formKey, user: user),
          ),
          Expanded(
            flex: 5,
            child: ShowBill(
              totalAmountkey: totalAmountkey,
              user: user,
            ),
          ),
        ]),
      ),
      floatingActionButton: button(formKey, totalAmountkey, context, user),
    );
  }

  Widget button(var formKey, var totalAmountkey, var context, User user) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.indigo[700], onPrimary: Colors.white),
        onPressed: () {
          if (totalAmountkey.currentState!.validate() &&
              formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
            formKey.currentState!.save();
            totalAmountkey.currentState!.save();
            HomePage.userBLoc.userEventSink
                .add(UserEvent(UserAction.addUser, user));
            HomePage.userBLoc.addUserStream.listen((event) async {
              if (event) {
                TwilioFlutter twilioFlutter = TwilioFlutter(
                    accountSid: 'ACf85beabae019534a63285b6af7f077f9',
                    authToken: 'ad61b87592f5802f49f648c2259e6909',
                    twilioNumber: '+19206587903');

                var res = await twilioFlutter.sendSMS(
                    toNumber: COUNTRY_CODE + user.phoneno.toString(),
                    messageBody:
                        'Thank you for Registering in Big Gym Lion. Please Login into https://mushrifshahreyar.github.io/BigGymLion/ and Complete the Process. Your ID: ${user.id.toString()}');
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                String message = "Successful";
                if (res == 201) {
                  message = "User added successfully and SMS Sent";
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('User not added. Please try again later')),
                );
              }
            });
          }
        },
        child: const Text('Submit'));
  }
}
