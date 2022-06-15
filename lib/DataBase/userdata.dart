import 'package:firedart/firedart.dart';
import 'package:gymadminapp/DataBase/plandata.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'package:gymadminapp/main.dart';

class UserData {
  final List<User> _userList = [
    //   User(1, "User1", "Address1", "9911900221", "1 Month", "Morning", 1000.0,
    //       DateTime(2022, 3, 7, 00, 00)),
    //   User(2, "User2", "Address2", "9911900222", "3 Month", "Evening", 3000.0,
    //       DateTime(2021, 9, 7, 00, 00)),
    //   User(3, "User3", "Address3", "9911900223", "1 Month", "Morning", 1000.0,
    //       DateTime(2022, 4, 1, 00, 00)),
    //   User(4, "User4", "Address4", "9911900224", "1 Year", "Evening", 10000.0,
    //       DateTime(2021, 9, 7, 00, 00)),
    //   User(5, "User5", "Address5", "9911900225", "3 Month", "Evening", 1000.0,
    //       DateTime(2021, 12, 7, 00, 00))
  ];

  Future<List<User>> get users async {
    var users = await Firestore(projectId).collection('users').get();
    _userList.clear();

    for (Document user in users) {
      _userList.add(User(
          int.parse(user.id),
          user['name'],
          user['phoneNo'],
          user['plan'],
          user['session'],
          double.parse(user['totalAmount']),
          user['startdate']));
    }

    return _userList;
  }

  Future<bool> save(User user) async {
    PlanData planData = PlanData();
    List<Plan> planList = await planData.planList;
    if (user.totalamount == null) {
      for (var plan in planList) {
        if (plan.planTitle == user.plan) {
          user.totalAmount = plan.totalPrice;
        }
      }
    }
    if (user.totalamount == null) {
      return false;
    }

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    user.startDate = date;

    await Firestore(projectId)
        .collection('users')
        .document(user.id.toString())
        .create({
      'name': user.name,
      'phoneNo': user.phoneno,
      'plan': user.plan,
      'session': user.session,
      'startdate': user.startdate,
      'totalAmount': user.totalamount.toString()
    });
    return true;
  }

  bool update(User user) {
    PlanData planData = PlanData();
    if (user.totalamount == null) {
      planData.planList.then((planList) {
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

    for (int i = 0; i < _userList.length; ++i) {
      if (_userList[i].id == user.id) {
        _userList[i].plan = user.plan;
        _userList[i].session = user.session;
      }
    }

    return true;
  }
}
