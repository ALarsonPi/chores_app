import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/UserModel.dart';

class ConnectedUserArguments {
  final int index;
  Chart chartData;
  UserModel currUser;

  ConnectedUserArguments(this.index, this.chartData, this.currUser);
}
