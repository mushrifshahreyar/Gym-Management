import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/billbloc.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'package:gymadminapp/Screens/homepage.dart';

class ShowForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final User user;
  const ShowForm({Key? key, required this.formKey, required this.user})
      : super(key: key);

  @override
  State<ShowForm> createState() => _ShowFormState();
}

class _ShowFormState extends State<ShowForm> {
  final double width = 350;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        margin: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(),
                fieldID(),
                field("Name"),
                field("WhatsApp Phone No"),
                fieldPlan(),
                fieldSession()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.black, width: 3),
      )),
      child: Text(
        "Please Enter User Details:",
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  Widget fieldID() {
    HomePage.userBLoc.userEventSink.add(UserEvent(UserAction.getUserID, null));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          width: 100,
          child: Text(
            "ID",
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Container(
            width: 60,
            margin: const EdgeInsets.all(15),
            child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: StreamBuilder(
                    stream: HomePage.userBLoc.getuserIDStream,
                    builder: (context, snapshot) {
                      String _id;
                      if (snapshot.hasData) {
                        _id = snapshot.data.toString();
                        try {
                          widget.user.id = int.parse(snapshot.data.toString());
                        } catch (e) {
                          widget.user.id = -1;
                        }
                      } else {
                        _id = "?";
                        widget.user.id = -1;
                      }
                      return Center(
                        child: Text(_id),
                      );
                    },
                  ),
                )))
      ],
    );
  }

  Widget field(String title) {
    final TextEditingController textcontroller = TextEditingController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 100,
          margin: const EdgeInsets.all(30),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Container(
          width: width,
          margin: const EdgeInsets.all(15),
          child: TextFormField(
            controller: textcontroller,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.amber)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.red))),
            cursorColor: Colors.black,
            onChanged: (val) {
              if (title == 'Name') {
                widget.user.name = val;
                HomePage.billBloc.billEventSink
                    .add(BillEvent(BillAction.updateName, widget.user));
              } else if (title == "WhatsApp Phone No") {
                widget.user.phoneno = val;
                HomePage.billBloc.billEventSink
                    .add(BillEvent(BillAction.updatePhoneNo, widget.user));
              }
            },
            onSaved: (value) {
              if (title == 'Name') {
                widget.user.name = value;
              } else if (title == "WhatsApp Phone No") {
                widget.user.phoneno = value;
              }
            },
            validator: (value) {
              if (title == 'Name') {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
              } else if (title == "WhatsApp Phone No") {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone no';
                }
              } else {
                if (value == null || value.isEmpty) {
                  return 'invalid value';
                }
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget fieldSession() {
    List<String> session = ["Morning", "Evening"];
    String dropdownval = session[0];
    widget.user.session = dropdownval;
    HomePage.billBloc.billEventSink
        .add(BillEvent(BillAction.updateSession, widget.user));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          width: 100,
          child: Text(
            'Session',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Container(
            width: width,
            margin: const EdgeInsets.all(15),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.amber)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.red))),
              value: dropdownval,
              items: session.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? val) {
                dropdownval = val!;
                widget.user.session = dropdownval;
                HomePage.billBloc.billEventSink
                    .add(BillEvent(BillAction.updateSession, widget.user));
              },
            )),
      ],
    );
  }

  Widget fieldPlan() {
    HomePage.userBLoc.userEventSink.add(UserEvent(UserAction.getPlan, null));
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.all(30),
        width: 100,
        child: Text(
          "Plan",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
      Container(
          width: width,
          margin: const EdgeInsets.all(15),
          child: StreamBuilder(
            stream: HomePage.userBLoc.getplanStream,
            builder: (context, AsyncSnapshot<List<Plan>> snapshot) {
              List<String> plans = ["1 Month"];

              if (snapshot.hasData) {
                plans.clear();
                for (var data in snapshot.data!) {
                  plans.add(data.planTitle);
                }
              }
              if (snapshot.hasError) {
                return const Text("No Data Found");
              }
              String dropdownval = plans[0];
              widget.user.plan = dropdownval;
              HomePage.billBloc.billEventSink
                  .add(BillEvent(BillAction.updatePlan, widget.user));
              return DropdownButtonFormField(
                  value: dropdownval,
                  alignment: Alignment.center,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.amber)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red))),
                  items: plans.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    dropdownval = val!;
                    widget.user.plan = dropdownval;
                    HomePage.billBloc.billEventSink
                        .add(BillEvent(BillAction.updatePlan, widget.user));
                  });
            },
          )),
    ]);
  }
}
