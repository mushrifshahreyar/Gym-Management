import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/billbloc.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'package:gymadminapp/Screens/Utils/popupmenu.dart';
import 'package:gymadminapp/Screens/homepage.dart';

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
            HomePage.userBLoc.addUserStream.listen((event) {
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
    var isSmall = false;
    if (MediaQuery.of(context).size.width < 1080) {
      isSmall = true;
    }
    return SizedBox(
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: isSmall ? 450 : 500,
              height: isSmall ? 450 : 500,
              margin: const EdgeInsets.all(90),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.indigo[700],
                  border: Border.all(color: Colors.indigo, width: 3)),
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
      ),
    );
  }

  Widget showSubPayment() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Text(
              "Payment Details:",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(15),
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
            margin: const EdgeInsets.all(15),
            child: Text(
              "Total Amount:",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
              margin: const EdgeInsets.all(15),
              child: Row(children: [
                Text(
                  "₹",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150,
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
              } else if (title == "Phone No") {
                widget.user.phoneno = val;
                HomePage.billBloc.billEventSink
                    .add(BillEvent(BillAction.updatePhoneNo, widget.user));
              }
            },
            onSaved: (value) {
              if (title == 'Name') {
                widget.user.name = value;
              } else if (title == "Phone No") {
                widget.user.phoneno = value;
              } else if (title == "Address") {
                widget.user.address = value;
              }
            },
            validator: (value) {
              if (title == 'Name') {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
              } else if (title == "Phone No") {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone no';
                }
              } else if (title == "Address") {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
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
