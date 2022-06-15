import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Screens/Utils/popupmenu.dart';
import 'package:gymadminapp/Screens/Utils/updateplandialog.dart';
import 'package:gymadminapp/Screens/homepage.dart';

class UpdatePlan extends StatelessWidget {
  const UpdatePlan({super.key});

  @override
  Widget build(BuildContext context) {
    HomePage.userBLoc.userEventSink.add(UserEvent(UserAction.getPlan, null));
    return Scaffold(
        floatingActionButton: button(context),
        appBar: AppBar(
          title: Text(
            'Update Plan',
            style: Theme.of(context).textTheme.headline1,
          ),
          actions: [popupMenuButton(context)],
        ),
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        body: SafeArea(
            child: Center(
          child: Container(
            width: 700,
            margin: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              boxShadow: const [
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
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.white24,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    "Plans",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(30),
                    child: StreamBuilder(
                        stream: HomePage.userBLoc.getplanStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Plan>> snapshot) {
                          List<Plan> plans = [];
                          if (snapshot.hasError) {
                            return const Text(
                                "No Data Found. Please Check Network Connection");
                          } else if (snapshot.hasData) {
                            for (Plan plan in snapshot.data!) {
                              plans.add(plan);
                            }
                          }
                          return buildPlanList(plans, context);
                        }),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Widget button(context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.indigo[700], onPrimary: Colors.white),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => updatePlanDialog(context, false, null));
          },
          child: const Text('Add Plan')),
    );
  }

  Widget buildPlanList(List<Plan> plans, context) {
    return ListView(
      children: List.generate(
          plans.length,
          (index) => Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(20, 35, 20, 0),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 1.0,
                      spreadRadius: 0.5,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white24,
                ),
                child: Center(
                  child: ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              updatePlanDialog(context, true, plans[index]));
                    },
                    leading: Text(
                      (index + 1).toString(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    title: Text(plans[index].planTitle,
                        style: Theme.of(context).textTheme.bodyText1),
                    subtitle: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(
                              fontFamily: 'Arial',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              fontSize: 16,
                              letterSpacing: 0.6),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "₹",
                          style: TextStyle(
                              fontFamily: 'Arial',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontSize: 16,
                              letterSpacing: 0.6),
                        ),
                        Text(
                          plans[index].totalPrice.toString(),
                          style: const TextStyle(
                              fontFamily: 'Arial',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontSize: 16,
                              letterSpacing: 0.6),
                        ),
                      ]),
                    ),
                  ),
                ),
              )),
    );
  }
}
