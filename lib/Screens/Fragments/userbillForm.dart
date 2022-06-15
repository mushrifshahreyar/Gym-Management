import 'package:flutter/material.dart';
import 'package:gymadminapp/Model/user.dart';
import 'package:gymadminapp/Screens/homepage.dart';

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
