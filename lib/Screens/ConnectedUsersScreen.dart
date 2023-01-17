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

  Widget buildPendingWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              "Name Name",
              style: TextStyle(
                fontSize: (Theme.of(context).textTheme.displaySmall?.fontSize
                        as double) +
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .fontSizeToAdd,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.clear,
                    color: Colors.red,
                    size: (Theme.of(context).iconTheme.size as double) +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .iconSizeToAdd),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: Icon(Icons.check,
                      color: Colors.green,
                      size: (Theme.of(context).iconTheme.size as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .iconSizeToAdd),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildViewerWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              "Name Name",
              style: TextStyle(
                fontSize: (Theme.of(context).textTheme.displaySmall?.fontSize
                        as double) +
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .fontSizeToAdd,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.clear,
                    color: Colors.red,
                    size: (Theme.of(context).iconTheme.size as double) +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .iconSizeToAdd),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: Icon(Icons.edit,
                      color: Theme.of(context).primaryColor,
                      size: (Theme.of(context).iconTheme.size as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .iconSizeToAdd),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildEditorWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              "Name Name",
              style: TextStyle(
                fontSize: (Theme.of(context).textTheme.displaySmall?.fontSize
                        as double) +
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .fontSizeToAdd,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.clear,
                    color: Colors.red,
                    size: (Theme.of(context).iconTheme.size as double) +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .iconSizeToAdd),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: Icon(Icons.edit,
                      color: Theme.of(context).primaryColor,
                      size: (Theme.of(context).iconTheme.size as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .iconSizeToAdd),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildOwnerWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              "Name Name",
              style: TextStyle(
                fontSize: (Theme.of(context).textTheme.displaySmall?.fontSize
                        as double) +
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .fontSizeToAdd,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.clear,
                    color: Colors.transparent,
                    size: (Theme.of(context).iconTheme.size as double) +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .iconSizeToAdd),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: Icon(Icons.edit,
                      color: Colors.transparent,
                      size: (Theme.of(context).iconTheme.size as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .iconSizeToAdd),
                ),
              ],
            ),
          )
        ],
      ),
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
