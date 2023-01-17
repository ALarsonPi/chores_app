import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/User.dart';

class CreateChartArguments {
  final int index;
  final bool isInEditMode;
  Chart chartData;
  User currUser;
  CreateChartArguments(this.index, this.chartData, this.currUser,
      {this.isInEditMode = false});
}
