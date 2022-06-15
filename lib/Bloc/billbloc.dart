import 'package:gymadminapp/DataBase/plandata.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/Model/user.dart';
import 'dart:async';

enum BillAction { updateName, updatePhoneNo, updatePlan, updateSession }

class BillEvent {
  BillAction billAction;
  User user;
  BillEvent(this.billAction, this.user);
}

class BillBloc {
  final PlanData _planData = PlanData();

  final _updateNameStreamController = StreamController<String?>.broadcast();
  StreamSink<String?> get _updateNameSink => _updateNameStreamController.sink;
  Stream<String?> get updateNameStream => _updateNameStreamController.stream;

  final _updatePhoneNoStreamController = StreamController<String?>.broadcast();
  StreamSink<String?> get _updatePhoneNoSink =>
      _updatePhoneNoStreamController.sink;
  Stream<String?> get updatePhoneNoStream =>
      _updatePhoneNoStreamController.stream;

  final _updatePlanStreamController = StreamController<String?>.broadcast();
  StreamSink<String?> get _updatePlanSink => _updatePlanStreamController.sink;
  Stream<String?> get updatePlanStream => _updatePlanStreamController.stream;

  final _updateSessionStreamController = StreamController<String?>.broadcast();
  StreamSink<String?> get _updateSessionSink =>
      _updateSessionStreamController.sink;
  Stream<String?> get updateSessionStream =>
      _updateSessionStreamController.stream;

  final _updatePaymentDetStreamController =
      StreamController<String?>.broadcast();
  StreamSink<String?> get _updatePaymentDetSink =>
      _updatePaymentDetStreamController.sink;
  Stream<String?> get updatePaymentDetStream =>
      _updatePaymentDetStreamController.stream;

  final _updateAmountStreamController = StreamController<String?>.broadcast();
  StreamSink<String?> get _updateAmountSink =>
      _updateAmountStreamController.sink;
  Stream<String?> get updateAmountStream =>
      _updateAmountStreamController.stream;

  //Event Management for user
  final _billEventStreamController = StreamController<BillEvent>.broadcast();
  StreamSink<BillEvent> get billEventSink => _billEventStreamController.sink;
  Stream<BillEvent> get _billEventStream => _billEventStreamController.stream;

  BillBloc() {
    _billEventStream.listen((event) {
      switch (event.billAction) {
        case BillAction.updateName:
          _updateName(event.user);
          break;

        case BillAction.updatePhoneNo:
          _updatePhoneNo(event.user);
          break;
        case BillAction.updatePlan:
          _updatePlan(event.user);
          break;
        case BillAction.updateSession:
          _updateSession(event.user);
          break;
      }
    });
  }

  void _updateName(User user) {
    _updateNameSink.add(user.name);
  }

  void _updatePhoneNo(User user) {
    _updatePhoneNoSink.add(user.phoneno);
  }

  void _updatePlan(User user) {
    _updatePlanSink.add(user.plan);
    _planData.planList.then((plans) {
      Plan userPlan = plans[0];
      for (var plan in plans) {
        if (plan.planTitle == user.plan) {
          userPlan = plan;
        }
      }
      double totalAmount = userPlan.totalPrice;

      String paymentDet =
          "${userPlan.monthlyprice} x ${userPlan.duration} Month";

      _updatePaymentDetSink.add(paymentDet);
      _updateAmountSink.add(totalAmount.toString());
    });
  }

  void _updateSession(User user) {
    _updateSessionSink.add(user.session);
  }
}
