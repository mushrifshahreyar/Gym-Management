import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'package:intl/intl.dart';

Dialog updatePlanDialog(BuildContext context, bool isUpdate, Plan plan) =>
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: SizedBox(
        height: 500,
        width: 450,
        child: Column(
          children: [
            showHeader(context, isUpdate),
            showField(context, isUpdate, plan)
          ],
        ),
      ),
    );

Widget showHeader(BuildContext context, bool isUpdate) {
  return Container(
    margin: const EdgeInsets.all(30),
    child: Text(
      isUpdate ? "Update Plan" : "Add Plan",
      style: Theme.of(context).textTheme.headline1,
    ),
  );
}

Widget showField(BuildContext context, bool isUpdate, Plan plan) {
  return Container(
    margin: const EdgeInsets.all(10),
    child: Form(
      child: Column(children: [
        field(context, "Plan Duration", isUpdate, plan.duration.toString()),
        field(context, "Plan Amount/ Month", isUpdate,
            plan.monthlyprice.toString()),
        field(context, "Plan Amount", isUpdate, plan.totalPrice.toString()),
        plan.planTitle == "1 Month"
            ? button(context, "Submit", plan)
            : showbutton(context, plan),
      ]),
    ),
  );
}

Widget showbutton(BuildContext context, Plan plan) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      button(context, "Submit", plan),
      button(context, "Delete", plan)
    ],
  );
}

Widget button(BuildContext context, String title, Plan plan) {
  return Container(
    margin: const EdgeInsets.all(30),
    height: 30,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: title == "Submit" ? Colors.indigo[700] : Colors.red[700],
            onPrimary: Colors.white),
        onPressed: () {
          if (title == "Delete") {
            showDialog(
                context: context,
                builder: (context) {
                  return confirmationDelete(context, plan);
                });
          }
        },
        child: title == "Submit" ? const Text("Submit") : const Text("Delete")),
  );
}

Widget confirmationDelete(BuildContext context, Plan plan) {
  return AlertDialog(
    title: const Text(
      'Please Confirm',
      style: TextStyle(
          fontFamily: 'Arial',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          fontSize: 16,
          letterSpacing: 0.6),
    ),
    content: const Text('Are you sure to remove the plan?'),
    actions: [
      TextButton(
          onPressed: () {
            User user = User.newInstance();
            user.plan = plan.planTitle;

            UserBloc()
                .userEventSink
                .add(UserEvent(UserAction.deletePlan, user));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Yes',
            style: TextStyle(
                fontFamily: 'Arial',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                fontSize: 16,
                letterSpacing: 0.6),
          )),
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'No',
            style: TextStyle(
                fontFamily: 'Arial',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: Colors.red,
                fontSize: 16,
                letterSpacing: 0.6),
          ))
    ],
  );
}

Widget field(BuildContext context, String title, bool isUpdate, String value) {
  final TextEditingController textcontroller = TextEditingController();
  if (isUpdate) {
    textcontroller.text = value.toString();
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(
        flex: 1,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
      Expanded(
        flex: 2,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: TextFormField(
            controller: textcontroller,
            style: Theme.of(context).textTheme.headline5,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.amber)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red))),
          ),
        ),
      ),
    ],
  );
}
