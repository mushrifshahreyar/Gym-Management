import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:gymadminapp/Model/plan.dart';
import 'package:gymadminapp/main.dart';

class PlanData {
  final List<Plan> _planList = [];

  Future<List<Plan>> get planList async {
    var plans = await Firestore(projectId).collection('plan').get();
    _planList.clear();
    for (Document plan in plans) {
      _planList.add(Plan(
          plan.id,
          plan['planTitle'],
          double.parse(plan['monthlyprice']),
          double.parse(plan['totalPrice']),
          plan['duration']));
    }

    return _planList;
  }

  Future<void> deletePlan(String planTitle) async {
    if (_planList.isEmpty) {
      planList.then((value) {
        for (var plan in _planList) {
          if (plan.planTitle == planTitle) {
            return Firestore(projectId)
                .collection('plan')
                .document(plan.id)
                .delete();
          }
        }
      });
    } else {
      for (var plan in _planList) {
        if (plan.planTitle == planTitle) {
          return Firestore(projectId)
              .collection('plan')
              .document(plan.id)
              .delete();
        }
      }
    }
  }
}
