import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/User.dart';

class ConnectedUserArguments {
  final int index;
  Chart chartData;
  User currUser;

  ConnectedUserArguments(this.index, this.chartData, this.currUser);
}
