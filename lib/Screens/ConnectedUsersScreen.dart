import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/TextSizeProvider.dart';
import 'ScreenArguments/connectedUserArguments.dart';

class ConnectedUsersScreen extends StatefulWidget {
  const ConnectedUsersScreen({super.key});
  static const routeName = "/connectedUsersExtraction";

  @override
  State<ConnectedUsersScreen> createState() => _ConnectedUsersScreenState();
}

class _ConnectedUsersScreenState extends State<ConnectedUsersScreen> {
  late final args =
      ModalRoute.of(context)!.settings.arguments as ConnectedUserArguments;

  @override
  void initState() {
    super.initState();

    // Create a listener pointing to this currentChart (ID sent in in args)
    // and listens to see if any changes are made to this chart
    // and if any of those changes affect any of these Lists
    // [pending, viewers, editors, owners] it will
    // setState and rebuild based on the new data

    // Changes would be made in ChartDao? or here?
    // Or maybe just Listen to the Provider?
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Padding buildTitleText(String titleText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          titleText,
          style: TextStyle(
            fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize
                    as double) +
                Provider.of<TextSizeProvider>(context, listen: false)
                    .fontSizeToAdd,
          ),
        ),
      ),
    );
  }

  Widget buildDisplaySkeleton(
    String name,
    List<IconData> icons,
    List<Color> iconColors,
    Function iconOneFunction,
    Function iconTwoFunction,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4.0,
        bottom: 8.0,
      ),
      child: GridView.count(
        shrinkWrap: true,
        childAspectRatio: 4 / 1,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              name,
              style: TextStyle(
                fontSize: (Theme.of(context).textTheme.displaySmall?.fontSize
                        as double) +
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .fontSizeToAdd,
              ),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icons.first,
                      color: iconColors.first,
                      size: (Theme.of(context).iconTheme.size as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .iconSizeToAdd),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03),
                    child: Icon(icons.last,
                        color: iconColors.last,
                        size: (Theme.of(context).iconTheme.size as double) +
                            Provider.of<TextSizeProvider>(context,
                                    listen: false)
                                .iconSizeToAdd),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildPendingWidget(int index) {
    return buildDisplaySkeleton(
      "DUDE Guy",
      [
        Icons.clear,
        Icons.check,
      ],
      [
        Colors.red,
        Colors.green,
      ],
      () => {},
      () => {},
    );
  }

  Widget buildViewerWidget(int index) {
    return buildDisplaySkeleton(
      "BRO Man",
      [
        Icons.clear,
        Icons.edit,
      ],
      [
        Colors.red,
        Colors.orangeAccent,
      ],
      () => {},
      () => {},
    );
  }

  Widget buildEditorWidget(int index) {
    return buildDisplaySkeleton(
      "BROTHER Bear",
      [
        Icons.clear,
        Icons.edit,
      ],
      [
        Colors.red,
        Colors.orangeAccent,
      ],
      () => {},
      () => {},
    );
  }

  Widget buildOwnerWidget(int index) {
    return buildDisplaySkeleton(
      "OWNER Person",
      [
        Icons.clear,
        Icons.edit,
      ],
      [
        Colors.transparent,
        Colors.transparent,
      ],
      () => {},
      () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(args.chartData.chartTitle),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildTitleText("Pending:"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) =>
                            buildPendingWidget(index),
                        itemCount: 3,
                      ),
                      buildTitleText("Viewers:"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) =>
                            buildViewerWidget(index),
                        itemCount: 3,
                      ),
                      buildTitleText("Editors:"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) =>
                            buildEditorWidget(index),
                        itemCount: 3,
                      ),
                      buildTitleText("Owner:"),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) =>
                            buildOwnerWidget(index),
                        itemCount: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
