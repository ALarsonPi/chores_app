import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/constant/AppTheme.dart';
import '../Providers/ThemeProvider.dart';
import '../global.dart';

class ThemeSwitcher extends StatelessWidget {
  ThemeSwitcher(this.containerHeight, this.parentSetStateFunction, {Key? key})
      : super(key: key);
  double containerHeight;
  Function parentSetStateFunction;

  static List<AppTheme> appThemes = [
    AppTheme(
      mode: ThemeMode.light,
      title: 'Light',
      icon: Icons.brightness_5_rounded,
    ),
    AppTheme(
      mode: ThemeMode.dark,
      title: 'Dark',
      icon: Icons.brightness_2_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (c, themeProvider, _) => SizedBox(
        height: (Global.isPhone) ? containerHeight : containerHeight + 100,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          childAspectRatio: 1 / 0.4,
          shrinkWrap: true,
          crossAxisCount: appThemes.length,
          children: List.generate(
            appThemes.length,
            (i) {
              bool _isSelectedTheme =
                  appThemes[i].mode == themeProvider.selectedThemeMode;
              return GestureDetector(
                onTap: _isSelectedTheme
                    ? null
                    : () => {
                          themeProvider.setSelectedThemeMode(appThemes[i].mode),
                          // Global.writeDarkMode(),
                        },
                child: AnimatedContainer(
                  height: (Global.isPhone)
                      ? containerHeight + 25
                      : containerHeight + 50,
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _isSelectedTheme
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 2, color: Theme.of(context).primaryColor),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 7),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).cardColor.withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: (Global.isPhone)
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            appThemes[i].icon,
                            size: (Theme.of(context).iconTheme.size as double) +
                                Provider.of<TextSizeProvider>(context,
                                        listen: false)
                                    .iconSizeToAdd,
                          ),
                          Text(
                            appThemes[i].title,
                            style: (Global.isPhone)
                                ? TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        ?.color as Color,
                                    fontSize: (Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            ?.fontSize as double) +
                                        Provider.of<TextSizeProvider>(context,
                                                listen: true)
                                            .fontSizeToAdd,
                                  )
                                : TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.color as Color,
                                    fontSize: (Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.fontSize as double) +
                                        Provider.of<TextSizeProvider>(context,
                                                listen: true)
                                            .fontSizeToAdd,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
