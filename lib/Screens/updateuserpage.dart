import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/billbloc.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'package:gymadminapp/Screens/homepage.dart';

class UpdateUserPage extends StatelessWidget {
  final User user;
  const UpdateUserPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final totalAmountkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update User',
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            alignment: Alignment.center,
            child:
                Text('Hi Admin', style: Theme.of(context).textTheme.headline3),
          )
        ],
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        child: Row(children: [
          Expanded(
            flex: 6,
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
                .add(UserEvent(UserAction.updateUser, user));
            HomePage.userBLoc.updateUserStream.listen((event) {
              if (event) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successful')),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Plan not found')),
                );
              }
            });
          }
        },
        child: const Text('Submit'));
  }
}

class ShowBill extends StatefulWidget {
  final GlobalKey totalAmountkey;
  final User user;
  const ShowBill({Key? key, required this.totalAmountkey, required this.user})
      : super(key: key);

  @override
  State<ShowBill> createState() => _ShowBillState();
}

class _ShowBillState extends State<ShowBill> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Container(
          width: 500,
          height: 500,
          margin: const EdgeInsets.all(90),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.indigo[700],
              border: Border.all(color: Colors.indigo, width: 3)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                showField("Name"),
                showField("Phone No"),
                showField("Plan"),
                showField("Session"),
                showSubPayment(),
                showPayment()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showSubPayment() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.all(15),
            child: Text(
              "Payment Details:",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.all(15),
            child: StreamBuilder(
              stream: HomePage.billBloc.updatePaymentDetStream,
              initialData: "",
              builder: (context, snapshot) {
                return Text(
                  "${snapshot.data}",
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget showPayment() {
    bool isChanged = false;
    final TextEditingController _textcontroller = TextEditingController();
    _textcontroller.text = '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.all(15),
            child: Text(
              "Total Amount:",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
              margin: EdgeInsets.all(15),
              child: Row(children: [
                Text(
                  "₹",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 170,
                  child: StreamBuilder(
                    initialData: "",
                    stream: HomePage.billBloc.updateAmountStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _textcontroller.text = snapshot.data.toString();
                      }
                      return Form(
                        key: widget.totalAmountkey,
                        child: TextFormField(
                          controller: _textcontroller,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              border: InputBorder.none),
                          style: Theme.of(context).textTheme.headline4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter total amount';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            isChanged = true;
                          },
                          onSaved: (val) {
                            if (val != null && isChanged) {
                              widget.user.totalAmount = double.parse(val);
                            } else {
                              widget.user.totalAmount = null;
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ])),
        )
      ],
    );
  }

  Widget showField(String title) {
    Stream<String?> stream = HomePage.billBloc.updateNameStream;
    if (title == "Name") {
      stream = HomePage.billBloc.updateNameStream;
    } else if (title == "Phone No") {
      stream = HomePage.billBloc.updatePhoneNoStream;
    } else if (title == "Plan") {
      stream = HomePage.billBloc.updatePlanStream;
    } else if (title == "Session") {
      stream = HomePage.billBloc.updateSessionStream;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(15),
            child: StreamBuilder(
              stream: stream,
              initialData: "",
              builder: ((context, snapshot) {
                return Text(
                  "${snapshot.data}",
                  style: Theme.of(context).textTheme.headline4,
                );
              }),
            ),
          ),
        )
      ],
    );
  }
}

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
                field("Address"),
                field("Phone No"),
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
      width: 300,
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

  Widget button() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.indigo[700], onPrimary: Colors.white),
        onPressed: () {
          if (widget.formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
        },
        child: const Text('Submit'));
  }

  Widget fieldID() {
    HomePage.userBLoc.userEventSink.add(UserEvent(UserAction.getUserID, null));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
                      child: Center(
                        child: Text(widget.user.id.toString()),
                      ))))
        ],
      ),
    );
  }

  Widget field(String title) {
    final TextEditingController textcontroller = TextEditingController();
    if (title == 'Name') {
      textcontroller.text = widget.user.name.toString();
      HomePage.billBloc.billEventSink
          .add(BillEvent(BillAction.updateName, widget.user));
    } else if (title == "Phone No") {
      textcontroller.text = widget.user.phoneno.toString();
      HomePage.billBloc.billEventSink
          .add(BillEvent(BillAction.updatePhoneNo, widget.user));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          width: 100,
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
            style: Theme.of(context).textTheme.headline5,
            enabled: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }

  Widget fieldSession() {
    List<String> session = ["Morning", "Evening"];
    String dropdownval = widget.user.session.toString();
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
              List<String> plans = [];
              plans.add(widget.user.plan.toString());
              if (snapshot.hasData) {
                plans.clear();
                plans.add(widget.user.plan.toString());
                for (Plan data in snapshot.data!) {
                  if (data.planTitle == widget.user.plan) {
                    continue;
                  }
                  plans.add(data.planTitle);
                }
              }
              if (snapshot.hasError) {
                return const Text("No Data Found");
              }
              String dropdownval = widget.user.plan.toString();

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
