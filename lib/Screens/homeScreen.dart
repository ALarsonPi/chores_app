import 'dart:async';

import 'package:badges/badges.dart';
import 'package:chore_app/Daos/ChartDao.dart';
import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:chore_app/Providers/CurrUserProvider.dart';
import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Screens/ScreenArguments/newChartArguments.dart';
import 'package:chore_app/Screens/ChartScreen.dart';
import 'package:chore_app/Widgets/ChartDisplay/ChangeChart/ChangeTitle.dart';
import 'package:chore_app/Widgets/UserLoginLogout/LoginRegisterWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:chore_app/Models/frozen/User.dart' as UserModel;

import '../Global.dart';
import '../Providers/DisplayChartProvider.dart';
import '../Providers/TextSizeProvider.dart';
import '../Providers/ThemeProvider.dart';
import '../Widgets/Settings/SettingsContent.dart';
import '../Widgets/ChartDisplay/TabContent.dart';

/// @nodoc
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> with TickerProviderStateMixin {
  late List<Chart> circleDataList;
  late List<Tab> tabs;
  late List<Tab> tabsToUse;
  late TabController tabsController = TabController(length: 3, vsync: this);
  bool isEditingTitle = false;
  bool shouldChangeTab = false;

  @override
  void initState() {
    super.initState();
    tabsController.index = 0;
    Global.dataTransferComplete = false;
  }

  @override
  void dispose() {
    super.dispose();
    tabsController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    tabsController.addListener(() {
      setState(() {
        isEditingTitle = false;
      });
    });

    setTabs();

    int numTabs = Provider.of<TabNumberProvider>(context, listen: true).numTabs;
    tabsController = TabController(length: numTabs + 1, vsync: this);

    tabsToUse = List.empty(growable: true);
    for (int i = 0; i < numTabs; i++) {
      tabsToUse.add(tabs.elementAt(i));
    }
    // Settings Tab
    tabsToUse.add(tabs.last);
  }

  void setTabs() {
    String chartTitle1 = "Chart 1";
    String chartTitle2 = "Chart 2";
    String chartTitle3 = "Chart 3";
    int chart1Changes = 0;
    int chart2Changes = 0;
    int chart3Changes = 0;

    const Color badgeColor = Colors.red;
    //Theme.of(context).primaryColor,

    const String badgeText = ' ';
    const Color textColor = Colors.white;

    tabs = [
      Tab(
        text: chartTitle1,
        icon: (chart1Changes != 0)
            ? Badge(
                badgeColor: badgeColor,
                badgeContent: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: (Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.fontSize as double) +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .fontSizeToAdd,
                    color: textColor,
                  ),
                ),
                child: Icon(
                  Icons.looks_one,
                  size: (Theme.of(context).iconTheme.size as double) +
                      Provider.of<TextSizeProvider>(context, listen: true)
                          .iconSizeToAdd,
                ),
              )
            : Icon(
                Icons.looks_one,
                size: (Theme.of(context).iconTheme.size as double) +
                    Provider.of<TextSizeProvider>(context, listen: true)
                        .iconSizeToAdd,
              ),
      ),
      Tab(
        text: chartTitle2,
        icon: (chart2Changes != 0)
            ? Badge(
                badgeColor: badgeColor,
                badgeContent: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: (Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.fontSize as double) +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .fontSizeToAdd,
                    color: textColor,
                  ),
                ),
                child: Icon(
                  Icons.looks_two,
                  size: (Theme.of(context).iconTheme.size as double) +
                      Provider.of<TextSizeProvider>(context, listen: true)
                          .iconSizeToAdd,
                ),
              )
            : Icon(
                Icons.looks_two,
                size: (Theme.of(context).iconTheme.size as double) +
                    Provider.of<TextSizeProvider>(context, listen: true)
                        .iconSizeToAdd,
              ),
      ),
      Tab(
        text: chartTitle3,
        icon: (chart3Changes != 0)
            ? Badge(
                badgeColor: badgeColor,
                badgeContent: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: (Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.fontSize as double) +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .fontSizeToAdd,
                    color: textColor,
                  ),
                ),
                child: Icon(
                  Icons.looks_3,
                  size: (Theme.of(context).iconTheme.size as double) +
                      Provider.of<TextSizeProvider>(context, listen: true)
                          .iconSizeToAdd,
                ),
              )
            : Icon(
                Icons.looks_3,
                size: (Theme.of(context).iconTheme.size as double) +
                    Provider.of<TextSizeProvider>(context, listen: true)
                        .iconSizeToAdd,
              ),
      ),
      Tab(
        text: "Settings",
        icon: Icon(
          Icons.settings,
          size: (Theme.of(context).iconTheme.size as double) +
              Provider.of<TextSizeProvider>(context, listen: true)
                  .iconSizeToAdd,
        ),
      ),
    ];
  }

  Widget getBottomNavigationBar(BuildContext context) {
    tabsController.index =
        Provider.of<TabNumberProvider>(context, listen: true).currTab;
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
          ),
        ],
        color: Provider.of<ThemeProvider>(context, listen: true).isDarkMode
            ? Theme.of(context).backgroundColor
            : Theme.of(context).primaryColor,
      ),
      child: TabBar(
        controller: tabsController,
        onTap: (index) => {
          setState(() {
            Provider.of<TabNumberProvider>(context, listen: false)
                .changeCurrTabNum(index);
          }),
        },
        isScrollable: false,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(5.0),
        indicatorColor: Theme.of(context).primaryColor,
        tabs: tabsToUse,
      ),
    );
  }

  Future<UserModel.User> getCurrUserFromProvider() async {
    final user = FirebaseAuth.instance.currentUser;
    UserModel.User updatedUser = UserModel.User(id: "id");
    if (user != null) {
      Global.currUserID = user.uid;
      updatedUser = await Provider.of<CurrUserProvider>(context, listen: false)
          .getCurrUser(user.email!);
    }
    return updatedUser;
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<CurrUserProvider>(context, listen: false).currUser.id ==
        "ID") {
      getCurrUserFromProvider();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (c, snapshot) {
        if (snapshot.hasData) {
          return StreamProvider<List<UserModel.User>>(
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
    Provider.of<DisplayChartProvider>(context, listen: false).updateChartTitle(
      tabsController.index,
      finalString,
    );

    ChartDao.updateChart(chartData.copyWith(chartTitle: finalString));

    setState(() {
      isEditingTitle = false;
    });
  }

  String getCurrChartTitle(Chart currChart) {
    if (tabsController.index == tabsController.length - 1) {
      return "Settings";
    }
    return currChart.chartTitle;
  }

  // ignore: non_constant_identifier_names
  Widget HomePageWidget(BuildContext c) {
    List<UserModel.User> listOfUser =
        Provider.of<List<UserModel.User>>(c, listen: true);

    if (listOfUser.isNotEmpty && !Global.dataTransferComplete) {
      ChartDao.getAndListenToChartsForUser(listOfUser.elementAt(0), context);
      Global.dataTransferComplete = true;
    }

    Chart chartData = (!Provider.of<DisplayChartProvider>(context, listen: true)
            .usersCharts
            .keys
            .contains(tabsController.index))
        ? Chart.emptyChart
        : Provider.of<DisplayChartProvider>(context, listen: true)
            .usersCharts[tabsController.index] as Chart;

    // Don't show Chart Edit Menu if chart is empty or settings screen
    bool isCurrChartEmpty =
        (tabsController.index == tabsController.length - 1) ||
            (chartData == Chart.emptyChart);
    String currChartTitle = getCurrChartTitle(chartData);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return DefaultTabController(
          length: tabsToUse.length,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Global.toolbarHeight +
                  Provider.of<TextSizeProvider>(context, listen: false)
                      .fontSizeToAdd),
              child: AppBar(
                toolbarHeight: Global.toolbarHeight,
                centerTitle: true,
                title: (isEditingTitle)
                    ? Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.1025,
                        ),
                        child: ChangeTitleWidget(
                          key: Global.changeTitleWidgetKey,
                          oldTitle: currChartTitle,
                          currTabIndex: tabsController.index,
                          updateParent: endEdit,
                          currChart: chartData,
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
                          color:
                              Theme.of(context).textTheme.headlineMedium?.color,
                        ),
                      ),
                leading: (isCurrChartEmpty)
                    ? null
                    : PopupMenuButton<int>(
                        icon: Icon(
                          Icons.menu,
                          size: (Theme.of(context).iconTheme.size as double) +
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
                                      tabsController.index,
                                      chartData,
                                      listOfUser.elementAt(0),
                                      isInEditMode: true,
                                    ));
                              },
                            ),
                          ),
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
                                ChartDao.removeListener(listOfUser
                                    .elementAt(0)
                                    .chartIDs
                                    ?.indexOf(chartData.id) as int);
                                Provider.of<CurrUserProvider>(context,
                                        listen: false)
                                    .deleteChartIDForUser(
                                        chartData.id, tabsController.index);
                                Provider.of<DisplayChartProvider>(context,
                                        listen: false)
                                    .updateChart(
                                        tabsController.index, Chart.emptyChart);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 3,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: SizedBox(
                                height: double.infinity,
                                child: Icon(
                                  Icons.add_alert,
                                  size: (Theme.of(context).iconTheme.size
                                          as double) +
                                      Provider.of<TextSizeProvider>(context,
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
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            bottomNavigationBar: getBottomNavigationBar(context),
            body: TabBarView(
              controller: tabsController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (int i = 0; i < tabsToUse.length - 1; i++) TabContent(i),
                const SettingsContent(),
              ],
            ),
          ),
        );
      },
    );
  }
}
