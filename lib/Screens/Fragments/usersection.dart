import 'package:flutter/material.dart';
import 'package:gymadminapp/Bloc/userbloc.dart';
import 'package:gymadminapp/Screens/Utils/adminpassworddialog.dart';
import 'package:gymadminapp/Screens/addUserPage.dart';
import 'package:gymadminapp/Screens/homepage.dart';
import 'package:gymadminapp/constants.dart';

class UserSection extends StatelessWidget {
  const UserSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSmall = false;
    if (MediaQuery.of(context).size.width < 1080) {
      isSmall = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: userTitle(context),
        ),
        Expanded(
          flex: 2,
          child: Row(children: [
            AddUserTile(isSmall: isSmall),
            ManageUserTile(isSmall: isSmall),
          ]),
        ),
      ],
    );
  }

  Widget userTitle(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 15, 0, 5),
      child: Text(
        'User Section',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}

class ManageUserTile extends StatefulWidget {
  final bool isSmall;
  const ManageUserTile({Key? key, required this.isSmall}) : super(key: key);

  @override
  State<ManageUserTile> createState() => _ManageUserTileState();
}

class _ManageUserTileState extends State<ManageUserTile> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.black)),
        margin: const EdgeInsets.all(15),
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) =>
                    adminPasswordDialog(context, MANAGE_USER));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Text(
                    "Manage User",
                    style: widget.isSmall
                        ? Theme.of(context).textTheme.headline5
                        : Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: manageUserTileBottom(context, widget.isSmall),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget manageUserTileBottom(BuildContext context, bool isSmall) {
    return Row(children: [
      Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
        child: Icon(Icons.manage_accounts, size: isSmall ? 30 : 40),
      )
    ]);
  }
}

class AddUserTile extends StatefulWidget {
  final bool isSmall;
  const AddUserTile({Key? key, required this.isSmall}) : super(key: key);

  @override
  State<AddUserTile> createState() => _AddUserTileState();
}

class _AddUserTileState extends State<AddUserTile> {
  int totalUsers = 0;
  @override
  void dispose() {
    HomePage.userBLoc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.black)),
        margin: const EdgeInsets.all(15),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AddUserPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Text(
                    "Add User",
                    style: widget.isSmall
                        ? Theme.of(context).textTheme.headline5
                        : Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: addUserTileBottom(context, widget.isSmall),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addUserTileBottom(BuildContext context, bool isSmall) {
    HomePage.userBLoc.userEventSink
        .add(UserEvent(UserAction.getTotalUser, null));
    // HomePageInherited.of(context)!
    //     .userBloc
    //     .userEventSink
    //     .add(UserEvent(UserEvent.getTotalUser, null));

    return Row(children: [
      Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 0, 0),
        child: Icon(Icons.person_add, size: isSmall ? 30 : 40),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
        child: StreamBuilder(
          stream: HomePage.userBLoc.gettotaluserStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                "${snapshot.data}",
                style: isSmall
                    ? Theme.of(context).textTheme.bodyText1
                    : Theme.of(context).textTheme.bodyText2,
              );
            } else {
              return Text(
                "?",
                style: isSmall
                    ? Theme.of(context).textTheme.bodyText1
                    : Theme.of(context).textTheme.bodyText2,
              );
            }
          },
        ),
      ),
    ]);
  }
}
