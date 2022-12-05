// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:chore_app/AppRouter.dart';
import 'package:chore_app/Global.dart';
import 'package:chore_app/Widgets/ConcentricChart/ConcentricChart.dart';
import 'package:chore_app/Widgets/ConcentricChart/RotatingPieChart/Objects/PieInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chore_app/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      //const AppRouter()
      MaterialApp(
        home: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(Global.toolbarHeight),
            child: AppBar(
              toolbarHeight: Global.toolbarHeight,
              centerTitle: true,
              title: const Text(
                "Chart 1",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          body: Stack(
            children: [
              ConcentricChart(
                numberOfRings: 3,
                width: 1080,
                spaceBetweenLines: 15,
                //Circle 1
                circleOneText: const ["hello", "hello2"],
                circleOneRadiusProportions: const [0.25, 0.35],
                circleOneColor: Global.currentTheme.primaryColor,
                circleOneFontColor: Colors.black,
                circleOneFontSize: 8.0,
                circleOneTextRadiusProportion: 0.6,
                //Circle 2
                circleTwoText: const ["chore1", "chore2"],
                circleTwoRadiusProportions: const [0.40, 0.75],
                circleTwoColor: Global.currentTheme.secondaryColor,
                circleTwoFontColor: Colors.white,
                //Circle 3
                circleTwoFontSize: 14.0,
                circleThreeText: const ["chore3", "chore4"],
                circleThreeRadiusProportion: 0.9,
                circleThreeColor: Global.currentTheme.tertiaryColor,
                circleThreeFontColor: Colors.white,
                circleThreeFontSize: 14.0,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('hello')), findsOneWidget);

    // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
