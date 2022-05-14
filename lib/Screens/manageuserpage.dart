import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'package:gymadminapp/Screens/Utils/popupmenu.dart';
import 'package:gymadminapp/Screens/homepage.dart';
import 'package:gymadminapp/Screens/updateuserpage.dart';
import 'package:intl/intl.dart';

class Filter {
  String? name;
  String? phoneno;
  String? status;
  String? session;
  String? plan;

  Filter({this.name, this.phoneno, this.plan, this.session, this.status});
}

class ManageUserPage extends StatelessWidget {
  const ManageUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Filter filter = Filter();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage User',
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [popupMenuButton(context)],
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 2,
            child: ShowFilters(
              formKey: formKey,
              filter: filter,
            ),
          ),
          Expanded(
            flex: 5,
            child: ShowTable(
              filter: filter,
            ),
          )
        ],
      )),
    );
  }
}

class ShowFilters extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Filter filter;
  const ShowFilters({Key? key, required this.formKey, required this.filter})
      : super(key: key);

  @override
  State<ShowFilters> createState() => _ShowFiltersState();
}

class _ShowFiltersState extends State<ShowFilters> {
  @override
  Widget build(BuildContext context) {
    bool isReset = false;
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: Text(
            "Set Filter",
            style: Theme.of(context).textTheme.headline6,
          )),
      Expanded(
        flex: 3,
        child: Form(
          key: widget.formKey,
          child: SingleChildScrollView(
            child: StaggeredGrid.count(crossAxisCount: 4, children: [
              field(context, "Name"),
              field(context, "Phone No"),
              fieldStatus(context),
              fieldSession(context),
              fieldPlan(context)
            ]),
          ),
        ),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () {
                    widget.formKey.currentState!.save();
                    HomePage.userBLoc.userEventSink
                        .add(UserEvent(UserAction.getUserList, null));
                  },
                  child: const Text(
                    "Go",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 0.6),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    widget.filter.name = null;
                    widget.filter.phoneno = null;
                    widget.filter.plan = null;
                    widget.filter.session = null;
                    widget.filter.status = null;
                    isReset = true;
                    // formKey.currentState!.save();
                    HomePage.userBLoc.userEventSink
                        .add(UserEvent(UserAction.getUserList, null));
                  },
                  child: const Text(
                    "Reset",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 0.6),
                  ),
                )
              ],
            )),
      )
    ]);
  }

  Widget fieldPlan(BuildContext context) {
    HomePage.userBLoc.userEventSink.add(UserEvent(UserAction.getPlan, null));
    return Container(
        margin: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: HomePage.userBLoc.getplanStream,
          builder: (context, AsyncSnapshot<List<Plan>> snapshot) {
            List<String> plans = [""];

            if (snapshot.hasData) {
              plans.clear();
              plans.add("");
              for (var data in snapshot.data!) {
                plans.add(data.planTitle);
              }
            }
            if (snapshot.hasError) {
              return const Text("No Data Found");
            }
            String dropdownval = plans[0];
            return DropdownButtonFormField(
                onSaved: (newValue) {
                  widget.filter.plan = newValue.toString();
                },
                alignment: Alignment.center,
                decoration: InputDecoration(
                    labelText: "Plan",
                    labelStyle: Theme.of(context).textTheme.headline5,
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.amber)),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.red))),
                items: plans.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: dropdownval,
                onChanged: (String? val) {
                  dropdownval = val!;
                });
          },
        ));
  }

  Widget fieldStatus(BuildContext context) {
    List<String> status = ["", "Expired", "Available"];
    String dropdownval = status[0];
    return Container(
        margin: const EdgeInsets.all(20),
        child: DropdownButtonFormField(
          onSaved: (newValue) {
            widget.filter.status = newValue.toString();
          },
          decoration: InputDecoration(
              labelText: "Status",
              labelStyle: Theme.of(context).textTheme.headline5,
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.amber)),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red))),
          items: status.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: dropdownval,
          onChanged: (String? val) {
            dropdownval = val!;
          },
        ));
  }

  Widget fieldSession(BuildContext context) {
    List<String> session = ["", "Morning", "Evening"];
    String dropdownval = session[0];

    return Container(
        margin: const EdgeInsets.all(20),
        child: DropdownButtonFormField(
          onSaved: (newValue) {
            widget.filter.session = newValue.toString();
          },
          decoration: InputDecoration(
              labelText: "Session",
              labelStyle: Theme.of(context).textTheme.headline5,
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.amber)),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red))),
          items: session.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: dropdownval,
          onChanged: (String? val) {
            dropdownval = val!;
          },
        ));
  }

  Widget field(BuildContext context, String title) {
    return Container(
        margin: const EdgeInsets.all(20),
        child: TextFormField(
          onSaved: ((newValue) {
            if (title == "Name") {
              widget.filter.name = newValue;
            } else if (title == "Phone No") {
              widget.filter.phoneno = newValue;
            }
          }),
          decoration: InputDecoration(
              labelText: title,
              labelStyle: Theme.of(context).textTheme.headline5,
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.amber)),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red))),
          cursorColor: Colors.black,
        ));
  }
}

class UserExtension {
  int id;
  bool status;
  String endDate;

  UserExtension(this.id, this.status, this.endDate);
}

class ShowTable extends StatelessWidget {
  final Filter filter;
  const ShowTable({Key? key, required this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<User> users = [];
    final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
    List<UserExtension> userExt = [];

    HomePage.userBLoc.userEventSink
        .add(UserEvent(UserAction.getUserList, null));

    return SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: StreamBuilder(
              stream: HomePage.userBLoc.userListStream,
              builder: (context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.hasData) {
                  users.clear();
                  userExt.clear();
                  for (var user in snapshot.data!) {
                    DateTime endDate = DateTime.now();
                    DateTime? date = user.startdate;

                    if (user.plan == "1 Month") {
                      endDate =
                          date?.add(const Duration(days: 30)) ?? DateTime.now();
                    } else if (user.plan == "3 Month") {
                      endDate =
                          date?.add(const Duration(days: 90)) ?? DateTime.now();
                    } else if (user.plan == "6 Month") {
                      endDate = date?.add(const Duration(days: 180)) ??
                          DateTime.now();
                    } else if (user.plan == "1 Year") {
                      endDate = date?.add(const Duration(days: 360)) ??
                          DateTime.now();
                    }

                    bool status = false;
                    if (endDate.compareTo(DateTime.now()) > 0) {
                      status = true;
                    }

                    //condition for checking in filter.
                    if (filter.name != "null" &&
                        filter.name != "" &&
                        filter.name != null) {
                      if (filter.name != user.name) {
                        continue;
                      }
                    }
                    if (filter.phoneno != "null" &&
                        filter.phoneno != "" &&
                        filter.phoneno != null) {
                      if (filter.phoneno != user.name) {
                        continue;
                      }
                    }
                    if (filter.plan != "null" &&
                        filter.plan != "" &&
                        filter.plan != null) {
                      if (filter.plan != user.plan) {
                        continue;
                      }
                    }
                    if (filter.session != "null" &&
                        filter.session != "" &&
                        filter.session != null) {
                      if (filter.session != user.session) {
                        continue;
                      }
                    }

                    if (filter.status != "null" &&
                        filter.status != "" &&
                        filter.status != null) {
                      if ((filter.status == "Expired" && status == true) ||
                          (filter.status == "Available" && status == false)) {
                        continue;
                      }
                    }
                    users.add(user);
                    userExt.add(UserExtension(user.id ?? -1, status,
                        formatter.format(endDate).toString()));
                  }
                }
                return Table(
                  border: TableBorder.all(),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(15),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                    4: FlexColumnWidth(),
                    5: FlexColumnWidth(),
                    6: FlexColumnWidth(),
                    7: FlexColumnWidth(),
                    8: FixedColumnWidth(40)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    headerRow(context),
                    for (int i = 0; i < users.length; ++i)
                      TableRow(children: <Widget>[
                        Container(
                            height: 35,
                            width: 10,
                            color: userExt[i].id == users[i].id &&
                                    userExt[i].status
                                ? Colors.green
                                : Colors.red),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "${users[i].id}",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "${users[i].name}",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "${users[i].phoneno}",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "${users[i].plan}",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            userExt[i].id == users[i].id && userExt[i].status
                                ? "Available"
                                : "Expired",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "${users[i].session}",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            userExt[i].id == users[i].id
                                ? userExt[i].endDate
                                : "",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          height: 35,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 20),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          UpdateUserPage(user: users[i]),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration:
                                          Duration.zero));
                            },
                          ),
                        )
                      ]),
                  ],
                );
              },
            )));
  }

  TableRow headerRow(BuildContext context) {
    return TableRow(
        decoration: const BoxDecoration(color: Colors.black12),
        children: <Widget>[
          const SizedBox(
            width: 10,
            height: 35,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              "ID",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              "Name",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              "Phone No.",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              "Plan",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              "Status",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              "Session",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              "Valid Upto",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          const SizedBox(
            width: 10,
            height: 35,
          )
        ]);
  }
}
