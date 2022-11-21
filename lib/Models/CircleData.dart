class CircleData {
  CircleData({
    required this.chartTitle,
    required this.numberOfRings,
    required this.circleOneText,
    required this.circleTwoText,
    required this.circleThreeText,
  });

  String? circleID;
  String chartTitle;
  int numberOfRings;
  List<String> circleOneText;
  List<String> circleTwoText;
  List<String> circleThreeText;

  Map<String, dynamic> toJson() => _circleDataToJson(this);

  factory CircleData.fromJson(Map<String, dynamic> json) =>
      _circleDataFromJson(json);

  // factory CircleData.fromSnapshot(DocumentSnapshot snapshot) {
  //   final newCircleData =
  //       CircleData.fromJson(snapshot.data() as Map<String, dynamic>);
  //   newCircleData.circleID = snapshot.reference.id;
  //   return newCircleData;
  // }
}

CircleData _circleDataFromJson(Map<String, dynamic> json) {
  return CircleData(
    numberOfRings: json['numberOfRings'] as int,
    chartTitle: json['chartTitle'] as String,
    circleOneText: json['circleOneText'] as List<String>,
    circleTwoText: json['circleTwoText'] as List<String>,
    circleThreeText: json['circleThreeText'] as List<String>,
  );
}

Map<String, dynamic> _circleDataToJson(CircleData instance) =>
    <String, dynamic>{
      'numberOfRings': instance.numberOfRings,
      'chartTitle': instance.chartTitle,
      'circleOneText': instance.circleOneText,
      'circleTwoText': instance.circleTwoText,
      'circleThreeText': instance.circleThreeText,
    };
