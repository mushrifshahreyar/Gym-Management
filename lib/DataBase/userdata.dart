import 'package:gymadminapp/DataBase/plandata.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';

class UserData {
  static List<User> userList = [
    User(1, "User1", "Address1", "9911900221", "1 Month", "Morning", 1000.0,
        DateTime(2022, 3, 7, 00, 00)),
    User(2, "User2", "Address2", "9911900222", "3 Month", "Evening", 3000.0,
        DateTime(2021, 9, 7, 00, 00)),
    User(3, "User3", "Address3", "9911900223", "1 Month", "Morning", 1000.0,
        DateTime(2022, 4, 1, 00, 00)),
    User(4, "User4", "Address4", "9911900224", "1 Year", "Evening", 10000.0,
        DateTime(2021, 9, 7, 00, 00)),
    User(5, "User5", "Address5", "9911900225", "3 Month", "Evening", 1000.0,
        DateTime(2021, 12, 7, 00, 00))
  ];

  List<User> get users => userList;

  bool save(User user) {
    if (user.totalamount == null) {
      PlanData().planList.then((planList) {
        for (var plan in planList) {
          if (plan.planTitle == user.plan) {
            user.totalAmount = plan.totalPrice;
          }
        }
      });
    }
    if (user.totalamount == null) {
      return false;
    }

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    user.startDate = date;
    userList.add(user);
    return true;
  }

  bool update(User user) {
    if (user.totalamount == null) {
      PlanData().planList.then((planList) {
        for (var plan in planList) {
          if (plan.planTitle == user.plan) {
            user.totalAmount = plan.totalPrice;
          }
        }
      });
    }
    if (user.totalamount == null) {
      return false;
    }

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    user.startDate = date;

    for (int i = 0; i < userList.length; ++i) {
      if (userList[i].id == user.id) {
        userList[i].plan = user.plan;
        userList[i].session = user.session;
      }
    }

    return true;
  }
}
