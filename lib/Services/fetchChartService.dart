import '../Daos/ChartDao.dart';
import '../Global.dart';
import '../Models/ChartDataHolder.dart';
import '../Models/frozen/Chart.dart';

class FetchChartService {
  static Future<List<ChartDataHolder>> fetchUsersCharts(
      String currUserID) async {
    List<ChartDataHolder> currChartData = await ChartDao.getCharts(currUserID);
    for (int i = 0; i < Global.TABS_ALLOWED; i++) {
      bool isFound = false;
      for (int j = 0; j < currChartData.length; j++) {
        if (currChartData.elementAt(j).index == i) {
          Global.chartHolderGlobal.add(currChartData.elementAt(j).actualChart);
          isFound = true;
          break;
        }
      }
      if (!isFound) Global.chartHolderGlobal.add(Chart.emptyChart);
    }

    return currChartData;
  }
}
