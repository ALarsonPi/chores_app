import 'package:chore_app/Global.dart';
import 'package:chore_app/Services/ListenService.dart';

import '../Daos/ChartDao.dart';
import '../Daos/UserDao.dart';
import '../Models/frozen/Chart.dart';
import '../Models/frozen/UserModel.dart';

class ChartService {
  int? isChartAlreadyUsed(UserModel currUser, String? id) {
    if (currUser.chartIDs == null) return -1;
    for (int i = 0; i < (currUser.chartIDs as List<String>).length; i++) {
      if (currUser.chartIDs?.elementAt(i).contains(id as String) as bool) {
        return i;
      }
    }
    return -1;
  }

  void processChartJoinRequest(Chart chartToJoin, UserModel currUser) async {
    if (chartToJoin == Chart.emptyChart) {
      Global.makeSnackbar("ERROR: Unable to join chart");
      return;
    }

    int num = isChartAlreadyUsed(currUser, chartToJoin.id) as int;
    if (num != -1) {
      Global.makeSnackbar(
        "You are already a part of that chart\nIt is your Chart ${num + 1}",
      );
    } else {
      Chart currChart = await ChartDao.getChartFromSubstringID(chartToJoin.id);
      if (currChart == Chart.emptyChart) {
        Global.makeSnackbar("No Chart found with that code. Please make " +
            "sure you have the correct code and try again");
        return;
      }
      await ChartDao().addPendingRequest(currUser.id, chartToJoin.id);
      await UserDao().addChartIDForUser(currChart.id, currUser.id);
      ListenService.addChartListenerByFullID(0, currChart.id);
    }
  }
}
