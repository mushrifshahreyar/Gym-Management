import 'package:flutter/material.dart';

class TrainerSection extends StatelessWidget {
  const TrainerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: trainerTitle(context),
        ),
        Expanded(
          flex: 2,
          child: Row(children: [
            addTrainerTile(context, "Add Trainer"),
            addTrainerTile(context, "Manage Trainer"),
          ]),
        ),
      ],
    );
  }

  Widget trainerTitle(var context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 15, 0, 5),
      child: Text(
        'Trainer Section',
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  Widget addTrainerTile(BuildContext context, String title) {
    var isSmall = false;
    if (MediaQuery.of(context).size.width < 1080) {
      isSmall = true;
    }
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.black)),
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Text(
                  title,
                  style: isSmall
                      ? Theme.of(context).textTheme.headline5
                      : Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: title == "Add Trainer"
                  ? addTrainerTileBottom(context, isSmall)
                  : manageTrainerTileBottom(context, isSmall),
            )
          ],
        ),
      ),
    );
  }

  Widget addTrainerTileBottom(BuildContext context, bool isSmall) {
    return Row(children: [
      Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 0, 0),
        child: Icon(Icons.person_add, size: isSmall ? 30 : 40),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
        child: Text(
          "30",
          style: isSmall
              ? Theme.of(context).textTheme.bodyText1
              : Theme.of(context).textTheme.bodyText2,
        ),
      ),
    ]);
  }

  Widget manageTrainerTileBottom(BuildContext context, bool isSmall) {
    return Row(children: [
      Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 0, 0),
        child: Icon(Icons.manage_accounts, size: isSmall ? 30 : 40),
      )
    ]);
  }
}
