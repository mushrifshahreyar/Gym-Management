import 'package:gymadminapp/DataBase/plandata.dart';
import 'package:gymadminapp/DataBase/userdata.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'dart:async';

enum UserAction {
  addUser,
  getTotalUser,
  updateUser,
  getUserID,
  getPlan,
  deletePlan,
  getUserList,
  resetFilter
}

class UserEvent {
  // static const String addUser = "AddUser";
  // static const String getTotalUser = "GetTotalUser";
  // static const String updateUser = "UpdateUser";
  // static const String getUserID = "GetUserID";
  // static const String getPlan = "GetPlan";
  // static const String getuserList = "UserList";

  UserAction userEvent;
  User? user;

  UserEvent(this.userEvent, this.user);
}

class UserBloc {
  final UserData _userData = UserData();
  final PlanData _planData = PlanData();

  //State Management for user
  final _userListStreamController = StreamController<List<User>>.broadcast();
  StreamSink<List<User>> get _userListSink => _userListStreamController.sink;
  Stream<List<User>> get userListStream => _userListStreamController.stream;

  final _getTotalUserStreamController = StreamController<int>.broadcast();
  StreamSink<int> get _gettotaluserSink => _getTotalUserStreamController.sink;
  Stream<int> get gettotaluserStream => _getTotalUserStreamController.stream;

  final _getUserIDStreamController = StreamController<int>.broadcast();
  StreamSink<int> get _getuserIDSink => _getUserIDStreamController.sink;
  Stream<int> get getuserIDStream => _getUserIDStreamController.stream;

  final _getplanStreamController = StreamController<List<Plan>>.broadcast();
  StreamSink<List<Plan>> get _getplanSink => _getplanStreamController.sink;
  Stream<List<Plan>> get getplanStream => _getplanStreamController.stream;

  final _addUserStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get _addUserSink => _addUserStreamController.sink;
  Stream<bool> get addUserStream => _addUserStreamController.stream;

  final _updateUserStreamController = StreamController<bool>.broadcast();
  StreamSink<bool> get _updateUserSink => _updateUserStreamController.sink;
  Stream<bool> get updateUserStream => _updateUserStreamController.stream;

  //Event Management for user
  final _userEventStreamController = StreamController<UserEvent>();
  StreamSink<UserEvent> get userEventSink => _userEventStreamController.sink;
  Stream<UserEvent> get _userEventStream => _userEventStreamController.stream;

  UserBloc() {
    _userEventStream.listen((event) {
      switch (event.userEvent) {
        case UserAction.addUser:
          _addUser(event.user);
          break;
        case UserAction.getTotalUser:
          _getTotalUser();
          break;
        case UserAction.updateUser:
          _updateUser(event.user);
          break;
        case UserAction.getUserID:
          _getUserID();
          break;
        case UserAction.getPlan:
          _getPlans();
          break;
        case UserAction.deletePlan:
          _deletePlan(event.user!.plan);
          break;
        case UserAction.getUserList:
          _getUserList();
          break;
        case UserAction.resetFilter:
          _resetFilter();
          break;
        default:
      }
    });
  }

  void _resetFilter() {}

  void _updateUser(User? user) {
    // if (user != null) {
    //   if (UserData().update(user)) {
    //     users = UserData().users;
    //     userEventSink.add(UserEvent(UserAction.getUserList, null));
    //     _updateUserSink.add(true);
    //   }
    // }
  }

  void _getUserList() {
    _userData.users.then((users) => {_userListSink.add(users)});
  }

  void _deletePlan(String? planTitle) {
    if (planTitle != null) {
      _planData.deletePlan(planTitle).then((value) {
        _planData.planList.then((plans) {
          _getplanSink.add(plans);
        });
      });
    }
  }

  void _getPlans() {
    _planData.planList.then((plans) {
      _getplanSink.add(plans);
    });
  }

  void _getUserID() {
    _userData.users.then((users) {
      int length = users.length;
      _getuserIDSink.add(length + 1);
    });
  }

  void _addUser(User? user) {
    if (user != null) {
      print(user.id);
      print(user.phoneno);
      _userData.save(user).then((value) {
        if (value) {
          userEventSink.add(UserEvent(UserAction.getTotalUser, null));
          _addUserSink.add(true);
        } else {
          _addUserSink.add(false);
        }
      });
    }
  }

  void _getTotalUser() {
    _userData.users.then((users) {
      int length = users.length;
      _gettotaluserSink.add(length);
    });
  }

  void dispose() {
    _userListStreamController.close();
    _getTotalUserStreamController.close();
    _getUserIDStreamController.close();
    _addUserStreamController.close();
    _updateUserStreamController.close();
    _userEventStreamController.close();
    _getplanStreamController.close();
  }
}
