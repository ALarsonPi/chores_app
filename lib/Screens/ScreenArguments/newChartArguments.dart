import '../../Models/frozen/Chart.dart';

class CreateChartArguments {
  final int index;
  final bool isInEditMode;
  Chart chartData;
  CreateChartArguments(this.index, this.chartData, {this.isInEditMode = false});
}
