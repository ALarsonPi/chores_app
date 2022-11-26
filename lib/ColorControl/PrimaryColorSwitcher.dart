import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Global.dart';
import '../Providers/ThemeProvider.dart';
import 'AppColors.dart';

class PrimaryColorSwitcher extends StatelessWidget {
  PrimaryColorSwitcher(this.desiredHeight, {Key? key}) : super(key: key);
  double desiredHeight;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (c, themeProvider, _) => SizedBox(
        height: (Global.isPhone) ? desiredHeight : desiredHeight + 100,
        child: GridView.count(
          crossAxisCount: AppColors.primaryColorList.length,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          children: List.generate(
            AppColors.primaryColorList.length,
            (i) {
              bool isSelectedColor = AppColors.primaryColorList[i] ==
                  Global.themeProvider.selectedPrimaryColor;
              return GestureDetector(
                onTap: isSelectedColor
                    ? null
                    : () => {
                          themeProvider.setSelectedPrimaryColor(
                              AppColors.primaryColorList[i]),
                          Global.themeProvider.setSelectedPrimaryColor(
                              AppColors.primaryColorList[i]),
                          Global.currPrimaryColorIndex = i,
                          Global.currentTheme = AppColors.themeColorList[i],
                          // Global.writePrimaryColor(),
                        },
                child: Container(
                  height: desiredHeight / 3,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColorList[i],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSelectedColor ? 1 : 0,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                          ),
                          child: Icon(Icons.check,
                              size: (Global.isPhone) ? 20 : 36),
                        ),
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
