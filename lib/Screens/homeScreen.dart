import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:chore_app/Daos/ChartDao.dart';
import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:chore_app/Screens/ChartScreen.dart';
import 'package:chore_app/Screens/ConnectedUsersScreen.dart';
import 'package:chore_app/Screens/ScreenArguments/connectedUserArguments.dart';
import 'package:chore_app/Screens/ScreenArguments/newChartArguments.dart';
import 'package:chore_app/Services/ChartService.dart';
import 'package:chore_app/Services/ListenService.dart';
import 'package:chore_app/Widgets/ChartDisplay/ChangeChart/ChangeTitle.dart';
import 'package:chore_app/Widgets/UserLoginLogout/LoginRegisterWidget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:provider/provider.dart';

import '../Global.dart';
import '../Models/frozen/UserModel.dart';
import '../Providers/TextSizeProvider.dart';
import '../Widgets/ChartDisplay/TabContent.dart';

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
      ListenService.cancelListeningToCharts();
      // This isn't needed as firebase will just update user object
      // when wifi resumes, or when it does resume, home screen will fetch
      // the user anyway
      // ListenService.cancelListeningToUser();
      Global.dataTransferComplete = false;
      return Center(
        child: Image.asset("assets/images/dino_dark.png"),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (c, snapshot) {
        if (snapshot.hasData && snapshot.data?.uid != null) {
          return StreamProvider<List<UserModel>>(
            create: (BuildContext c) => UserDao().getUserDataViaStream(
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
    ChartDao().updateTitle(finalString, chartData.id);

    setState(() {
      isEditingTitle = false;
    });
  }

  List<bool> tabsSaveStatus = List.filled(Global.NUM_CHARTS, false);

  notifyParentOfChangedContent(bool shouldAllowSave, int tabNum) {
    setState(() {
      tabsSaveStatus[tabNum] = shouldAllowSave;
    });
  }

  UserModel emptyUserModel = UserModel(id: "ID");

  // ignore: non_constant_identifier_names
  Widget HomePageWidget(BuildContext c) {
    String currUserId = FirebaseAuth.instance.currentUser?.uid as String;

    // Initial Retrival of chart data happens only once
    // and listeners are also set here
    if (!Global.dataTransferComplete) {
      debugPrint("Adding listeners for Chart and User");
      UserDao()
          .getUserByID(FirebaseAuth.instance.currentUser?.uid as String)
          .then((userRetrieved) => {
                ListenService.initializeListeners(userRetrieved),
                Global.dataTransferComplete = true,
              });
      Global.dataTransferComplete = true;
    }

    int currTabNum = 0;

    return ValueListenableBuilder(
      valueListenable: ListenService.chartsNotifiers.elementAt(currTabNum),
      builder: (context, chartData, child) {
        // debugPrint(
        //     "IsEmptyChart: " + (chartData == Chart.emptyChart).toString());
        // debugPrint("IsEmptyChart: " + (chartData).toString());
        bool isOwner = chartData.ownerIDs.contains(currUserId);
        bool isEditor = chartData.editorIDs.contains(currUserId);
        bool isPending = chartData.pendingIDs.contains(currUserId);
        bool isViewer = chartData.viewerIDs.contains(currUserId);

        String role = "";
        if (chartData.ownerIDs.contains(currUserId)) {
          role = "Owner";
        } else if (chartData.editorIDs.contains(currUserId)) {
          role = "Editor";
        } else if (chartData.viewerIDs.contains(currUserId)) {
          role = "Viewer";
        } else if (chartData.pendingIDs.contains(currUserId)) {
          role = "Pending";
        } else {
          role = "Error";
          Future.delayed(
            const Duration(seconds: 0),
            () => ListenService.chartsNotifiers.elementAt(currTabNum).value =
                Chart.emptyChart,
          );
        }

        // Ensures lowest access level
        // is the only level seen
        if (isPending || isViewer) {
          isOwner = false;
          isEditor = false;
        }

        bool hasNewNotification =
            chartData.pendingIDs.isNotEmpty && (isOwner || isEditor);
        bool isCurrChartEmpty = (chartData == Chart.emptyChart);
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return Scaffold(
              // key: Global.scaffoldKey,
              body: TabContent(
                0,
                notifyParentOfChangedContent,
              ),
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(Global.toolbarHeight +
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .fontSizeToAdd),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: Global.toolbarHeight,
                  centerTitle: true,
                  actions: [
                    if (tabsSaveStatus[currTabNum])
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.save,
                            size: (Theme.of(context).iconTheme.size as double) +
                                Provider.of<TextSizeProvider>(context,
                                        listen: false)
                                    .iconSizeToAdd,
                          ),
                          onPressed: () {
                            ChartService.saveTabData(
                                currTabNum,
                                ListenService.chartsNotifiers
                                    .elementAt(currTabNum)
                                    .value
                                    .id);
                            setState(() {
                              tabsSaveStatus[currTabNum] = false;
                            });
                          },
                        ),
                      ),
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
                            oldTitle: chartData.chartTitle,
                            currTabIndex: 0,
                            updateParent: endEdit,
                            currChart: chartData,
                          ),
                        )
                      : Text(
                          chartData.chartTitle,
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
                                          currTabNum,
                                          chartData,
                                          isInEditMode: true,
                                        ));
                                  },
                                ),
                              ),
                            if (isOwner)
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
                                    ChartService().showDeleteChartConfirmDialog(
                                        context, chartData, currUserId);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            if (isOwner)
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
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12.0,
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
                                        chartData,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            // if (!isOwner)
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
                                  ChartService().leaveChart(
                                    context,
                                    currTabNum,
                                    currUserId,
                                    chartData.id,
                                    chartData,
                                  );
                                  ListenService.chartsNotifiers
                                      .elementAt(currTabNum)
                                      .value = Chart.emptyChart;
                                  Navigator.pushNamed(context, 'home');
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
