import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/UserModel.dart';

class CreateChartArguments {
  final int index;
  final bool isInEditMode;
  Chart chartData;
  UserModel currUser;
  CreateChartArguments(this.index, this.chartData, this.currUser,
      {this.isInEditMode = false});
}
