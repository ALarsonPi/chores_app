import 'dart:async';

import 'package:badges/badges.dart';
import 'package:chore_app/ColorControl/AppColors.dart';
import 'package:chore_app/Models/frozen/Chart.dart';
import 'package:chore_app/Providers/ChartProvider.dart';
import 'package:chore_app/Providers/CurrUserProvider.dart';
import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Widgets/ChartDisplay/ChangeChart/ChangeTitle.dart';
import 'package:chore_app/Widgets/UserLoginLogout/LoginRegisterWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import '../Global.dart';
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
                child: const Icon(Icons.looks_one),
              )
            : const Icon(Icons.looks_one),
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
                child: const Icon(Icons.looks_two),
              )
            : const Icon(Icons.looks_two),
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
                child: const Icon(Icons.looks_3),
              )
            : const Icon(Icons.looks_3),
      ),
      const Tab(
        text: "Settings",
        icon: Icon(Icons.settings),
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

  @override
  Widget build(BuildContext context) {
    if (Provider.of<CurrUserProvider>(context, listen: false).currUser.id ==
        "ID") {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Global.currUserID = user.uid;
        Provider.of<CurrUserProvider>(context, listen: false)
            .getCurrUser(user.email!);
      }
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePageWidget();
        } else {
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

  endEdit() {
    setState(() {
      isEditingTitle = false;
    });
  }

  // ignore: non_constant_identifier_names
  Widget HomePageWidget() {
    // Don't show Chart Edit Menu if chart is empty or settings screen
    bool isCurrChartEmpty =
        (tabsController.index == tabsController.length - 1) ||
            (Provider.of<ChartProvider>(context)
                    .circleDataList[tabsController.index] ==
                Chart.emptyChart);
    String currChartTitle = (tabsController.index == tabsController.length - 1)
        ? "Settings"
        : Provider.of<ChartProvider>(context)
            .circleDataList[tabsController.index]
            .chartTitle;
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
                // bottom: PreferredSize(
                //   preferredSize: Size.zero,
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       bottom: 16.0,
                //     ),
                //     child: Text(
                //       "Title 2",
                //       style: TextStyle(
                //         color:
                //             Theme.of(context).textTheme.headlineMedium?.color,
                //       ),
                //     ),
                //   ),
                // ),
                // flexibleSpace: Container(
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [
                //         Theme.of(context).primaryColor,
                //         AppColors.getPrimaryColorSwatch().shade400,
                //         Theme.of(context).primaryColor,
                //       ],
                //       stops: const [0.0, 0.5, 1.0],
                //     ),
                //   ),
                // ),
                toolbarHeight: Global.toolbarHeight,
                centerTitle: true,
                title: (isEditingTitle)
                    ? Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.1025,
                        ),
                        child: ChangeTitleWidget(
                          key: Global.changeTitleWidgetKey,
                          oldTitle: Provider.of<ChartProvider>(context)
                              .circleDataList[tabsController.index]
                              .chartTitle,
                          currTabIndex: tabsController.index,
                          updateParent: endEdit,
                        ),
                      )
                    :
                    // Column(
                    //     children: [
                    Text(
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
                // Text(
                //   "Title 2",
                //   style: TextStyle(
                //     color: Theme.of(context)
                //         .textTheme
                //         .headlineMedium
                //         ?.color,
                //     fontSize: Theme.of(context)
                //         .textTheme
                //         .headlineSmall
                //         ?.fontSize,
                //   ),
                // ),
                // ],
                //),
                leading: (isCurrChartEmpty)
                    ? null
                    : PopupMenuButton<int>(
                        icon: const Icon(Icons.menu),
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
                              leading: const SizedBox(
                                height: double.infinity,
                                child: Icon(
                                  Icons.abc_outlined,
                                  color: Colors.amber,
                                ),
                              ),
                              title: Text(
                                'Edit Title',
                                style: TextStyle(
                                  fontSize: (Theme.of(context)
                                          .textTheme
                                          .displayMedium
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
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              title: Text(
                                'Edit Text',
                                style: TextStyle(
                                  fontSize: (Theme.of(context)
                                          .textTheme
                                          .displayMedium
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
                          PopupMenuItem<int>(
                            value: 2,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const SizedBox(
                                height: double.infinity,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              title: Text(
                                'Delete Chart',
                                style: TextStyle(
                                  fontSize: (Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.fontSize as double) +
                                      Provider.of<TextSizeProvider>(context,
                                              listen: false)
                                          .fontSizeToAdd,
                                ),
                              ),
                              onTap: () {
                                Provider.of<ChartProvider>(context,
                                        listen: false)
                                    .deleteChart(
                                        Provider.of<ChartProvider>(context,
                                                    listen: false)
                                                .circleDataList[
                                            tabsController.index],
                                        tabsController.index);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 3,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const SizedBox(
                                height: double.infinity,
                                child: Icon(
                                  Icons.add_alert,
                                  color: Colors.green,
                                ),
                              ),
                              title: Text(
                                'Connected Users',
                                style: TextStyle(
                                  fontSize: (Theme.of(context)
                                          .textTheme
                                          .displayMedium
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
