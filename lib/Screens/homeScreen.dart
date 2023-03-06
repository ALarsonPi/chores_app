import 'dart:async';

import 'package:badges/badges.dart';
import 'package:chore_app/Daos/ChartDao.dart';
import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:chore_app/Screens/ConnectedUsersScreen.dart';
import 'package:chore_app/Screens/ScreenArguments/connectedUserArguments.dart';
import 'package:chore_app/Screens/ScreenArguments/newChartArguments.dart';
import 'package:chore_app/Screens/ChartScreen.dart';
import 'package:chore_app/Services/ChartManager.dart';
import 'package:chore_app/Services/UserManager.dart';
import 'package:chore_app/Widgets/ChartDisplay/ChangeChart/ChangeTitle.dart';
import 'package:chore_app/Widgets/UserLoginLogout/LoginRegisterWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:provider/provider.dart';
import '../Global.dart';
import '../Models/frozen/UserModel.dart';
import '../Providers/TextSizeProvider.dart';
import '../Widgets/ChartDisplay/TabContent.dart';
import 'package:badges/badges.dart' as badges;

/// @nodoc
class HomeScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen>
    with TickerProviderStateMixin, GetItStateMixin {
  bool isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    Global.dataTransferComplete = false;
  }

  final Color badgeColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    // WIFI CHECKING
    ConnectivityResult network =
        Provider.of<ConnectivityResult>(context, listen: true);
    if (network != ConnectivityResult.wifi) {
      ChartDao.endListeningToCharts();
      Global.getIt.get<UserManager>().endListening();
      return Center(
        child: Image.asset("assets/images/dino_dark.png"),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (c, snapshot) {
        if (snapshot.hasData && snapshot.data?.uid != null) {
          return StreamProvider<List<UserModel>>(
            create: (BuildContext c) => UserDao.getUserDataViaStream(
                FirebaseAuth.instance.currentUser?.uid as String),
            initialData: const [],
            builder: (context, child) => HomePageWidget(context),
          );
        } else {
          Global.dataTransferComplete = false;
          return LoginSignUpWidget();
        }
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget LoginSignUpWidget() {
    return const Scaffold(
      body: LoginRegisterWidget(),
    );
  }

  endEdit(Chart chartData, String finalString) {
    Global.getIt.get<ChartList>().updateChartTitle(0, finalString);
    ChartDao.updateChart(chartData.copyWith(chartTitle: finalString));

    setState(() {
      isEditingTitle = false;
    });
  }

  UserModel emptyUserModel = UserModel(id: "ID");

  Future<void> getCharts(UserModel user) async {
    List<Chart> charts = await ChartDao.getChartsForUser(user);
    for (Chart chart in charts) {
      int? currIndex = user.chartIDs?.indexOf(chart.id);
      if (currIndex == null) {
        debugPrint("ERROR - CHART NOT FOUND");
      }
      int tabNum = user.associatedTabNums?.elementAt(currIndex as int) as int;

      Global.getIt.get<ChartList>().getCurrNotifierByIndex(tabNum).value =
          chart;
    }
  }

  // ignore: non_constant_identifier_names
  Widget HomePageWidget(BuildContext c) {
    UserModel currUser = Global.getIt.get<UserManager>().currUser.value;

    // Initial Retrival of chart data happens only once
    // and listeners are also set here
    if (!Global.dataTransferComplete) {
      UserModel userModel = UserModel.emptyUser;
      debugPrint("Adding listeners for Chart and User");

      GetIt.instance
          .get<UserManager>()
          .addListener((FirebaseAuth.instance.currentUser?.uid as String))
          .then(
            (value) => {
              userModel = value,
              GetIt.instance.get<UserManager>().currUser.value = userModel,
              // debugPrint(value.toString()),

              // Refresh when charts are retrieved
              getCharts(currUser).then(
                (value) => {
                  setState(() {}),
                  Global.getIt
                      .get<ChartList>()
                      .addListenersForChartsFromFirebase(userModel),
                },
              ),
              debugPrint("Did data Transfer"),
              Global.dataTransferComplete = true,
            },
          );
    }

    return ValueListenableBuilder(
      valueListenable: Global.getIt.get<ChartList>().getCurrNotifierByIndex(0),
      builder: (context, chartData, child) {
        // Don't show Chart Edit Menu if chart is empty or settings screen

        bool isOwner = (chartData as Chart).ownerIDs.contains(currUser.id);
        bool isEditor = chartData.editorIDs.contains(currUser.id);
        // bool isPending = chartData.pendingIDs.contains(currUser.id);
        // bool isViewer = chartData.viewerIDs.contains(currUser.id);

        bool hasNewNotification =
            chartData.pendingIDs.isNotEmpty && (isOwner || isEditor);
        // debugPrint(chartData.toString());
        // debugPrint("Changes: " + hasNewNotification.toString());
        bool isCurrChartEmpty = (chartData == Chart.emptyChart);
        String currChartTitle = chartData.chartTitle;
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return Scaffold(
              key: Global.scaffoldKey,
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(Global.toolbarHeight +
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .fontSizeToAdd),
                child: AppBar(
                  toolbarHeight: Global.toolbarHeight,
                  centerTitle: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          size: (Theme.of(context).iconTheme.size as double) +
                              Provider.of<TextSizeProvider>(context,
                                      listen: false)
                                  .iconSizeToAdd,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, 'settings');
                        },
                      ),
                    )
                  ],
                  title: (isEditingTitle)
                      ? Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.1025,
                          ),
                          child: ChangeTitleWidget(
                            key: Global.changeTitleWidgetKey,
                            oldTitle: currChartTitle,
                            currTabIndex: 0,
                            updateParent: endEdit,
                            currChart: chartData as Chart,
                          ),
                        )
                      : Text(
                          currChartTitle,
                          style: TextStyle(
                            fontSize: (Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.fontSize as double) +
                                Provider.of<TextSizeProvider>(context,
                                        listen: true)
                                    .fontSizeToAdd,
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.color,
                          ),
                        ),
                  leading: (isCurrChartEmpty)
                      ? null
                      : PopupMenuButton<int>(
                          icon: (hasNewNotification && (isEditor || isOwner))
                              ? badges.Badge(
                                  badgeContent: const Text(''),
                                  child: Icon(
                                    Icons.menu,
                                    size: (Theme.of(context).iconTheme.size
                                            as double) +
                                        Provider.of<TextSizeProvider>(context,
                                                listen: false)
                                            .iconSizeToAdd,
                                  ),
                                )
                              : Icon(
                                  Icons.menu,
                                  size: (Theme.of(context).iconTheme.size
                                          as double) +
                                      Provider.of<TextSizeProvider>(context,
                                              listen: false)
                                          .iconSizeToAdd,
                                ),
                          offset: Offset(
                              0.0,
                              Global.toolbarHeight -
                                  Provider.of<TextSizeProvider>(context,
                                          listen: false)
                                      .fontSizeToAdd -
                                  2),
                          itemBuilder: (context) => [
                            if (isEditor || isOwner)
                              PopupMenuItem<int>(
                                value: 0,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SizedBox(
                                    height: double.infinity,
                                    child: Icon(
                                      Icons.abc_outlined,
                                      size: (Theme.of(context).iconTheme.size
                                              as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .iconSizeToAdd,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  title: Text(
                                    'Edit Title',
                                    style: TextStyle(
                                      fontSize: (Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.fontSize as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .fontSizeToAdd,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      isEditingTitle = true;
                                    });
                                  },
                                ),
                              ),
                            if (isEditor || isOwner)
                              PopupMenuItem<int>(
                                value: 1,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SizedBox(
                                    height: double.infinity,
                                    child: Icon(
                                      Icons.edit,
                                      size: (Theme.of(context).iconTheme.size
                                              as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .iconSizeToAdd,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  title: Text(
                                    'Edit Content',
                                    style: TextStyle(
                                      fontSize: (Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.fontSize as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .fontSizeToAdd,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, ChartScreen.routeName,
                                        arguments: CreateChartArguments(
                                          0,
                                          chartData as Chart,
                                          isInEditMode: true,
                                        ));
                                  },
                                ),
                              ),
                            if (isEditor || isOwner)
                              PopupMenuItem<int>(
                                value: 2,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SizedBox(
                                    height: double.infinity,
                                    child: Icon(
                                      Icons.delete,
                                      size: (Theme.of(context).iconTheme.size
                                              as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .iconSizeToAdd,
                                      color: Colors.red,
                                    ),
                                  ),
                                  title: Text(
                                    'Delete Chart',
                                    style: TextStyle(
                                      fontSize: (Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.fontSize as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .fontSizeToAdd,
                                    ),
                                  ),
                                  onTap: () {
                                    ChartDao.removeListener(currUser.chartIDs
                                            ?.indexOf((chartData as Chart).id)
                                        as int);
                                    Global.getIt
                                        .get<UserManager>()
                                        .deleteChartIDForUser(
                                            (chartData as Chart).id, 0);
                                    ChartDao.deleteChart(chartData as Chart);
                                    Global.getIt
                                        .get<ChartList>()
                                        .getCurrNotifierByIndex(0)
                                        .value = Chart.emptyChart;
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            if (isEditor || isOwner)
                              PopupMenuItem<int>(
                                value: 3,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SizedBox(
                                    height: double.infinity,
                                    child: hasNewNotification &&
                                            (isEditor || isOwner)
                                        ? badges.Badge(
                                            badgeContent: const Text(''),
                                            position: BadgePosition.topEnd(
                                              top: 1,
                                              end: -1,
                                            ),
                                            child: Icon(
                                              Icons.add_alert,
                                              size: (Theme.of(context)
                                                      .iconTheme
                                                      .size as double) +
                                                  Provider.of<TextSizeProvider>(
                                                          context,
                                                          listen: false)
                                                      .iconSizeToAdd,
                                              color: Colors.green,
                                            ),
                                          )
                                        : Icon(
                                            Icons.add_alert,
                                            size: (Theme.of(context)
                                                    .iconTheme
                                                    .size as double) +
                                                Provider.of<TextSizeProvider>(
                                                        context,
                                                        listen: false)
                                                    .iconSizeToAdd,
                                            color: Colors.green,
                                          ),
                                  ),
                                  title: Text(
                                    'Connected Users',
                                    style: TextStyle(
                                      fontSize: (Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.fontSize as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .fontSizeToAdd,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      ConnectedUsersScreen.routeName,
                                      arguments: ConnectedUserArguments(
                                        0,
                                        chartData as Chart,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            if (!isOwner)
                              PopupMenuItem<int>(
                                value: 4,
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: SizedBox(
                                    height: double.infinity,
                                    child: Icon(
                                      Icons.group_remove,
                                      size: (Theme.of(context).iconTheme.size
                                              as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .iconSizeToAdd,
                                      color: const Color.fromARGB(
                                          255, 253, 108, 127),
                                      //Colors.orangeAccent,
                                    ),
                                  ),
                                  title: Text(
                                    'Leave Chart',
                                    style: TextStyle(
                                      fontSize: (Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.fontSize as double) +
                                          Provider.of<TextSizeProvider>(context,
                                                  listen: false)
                                              .fontSizeToAdd,
                                    ),
                                  ),
                                  onTap: () {
                                    ChartDao.removeListener(currUser.chartIDs
                                            ?.indexOf((chartData as Chart).id)
                                        as int);
                                    Global.getIt
                                        .get<UserManager>()
                                        .deleteChartIDForUser(
                                            (chartData as Chart).id, 0);

                                    chartData = (chartData as Chart)
                                        .removeUserFromChart(
                                      chartData as Chart,
                                      currUser.id,
                                    );
                                    ChartDao.updateChart(chartData as Chart);

                                    Global.getIt
                                        .get<ChartList>()
                                        .getCurrNotifierByIndex(0)
                                        .value = Chart.emptyChart;
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                          ],
                        ),
                ),
              ),
              body: TabContent(0),
            );
          },
        );
      },
    );
  }
}
