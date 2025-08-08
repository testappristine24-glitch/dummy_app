// ignore_for_file: unused_local_variable

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:delivoo/Components/bottom_bar.dart';
import 'package:delivoo/Locale/locales.dart';
import 'package:delivoo/Themes/colors.dart';
import 'package:delivoo/Themes/style.dart';
import 'package:delivoo/language_cubit.dart';
import 'package:delivoo/main.dart';
import 'package:delivoo/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Components/common_app_nav_bar.dart';
import '../../../../Components/common_home_nav_bar.dart';

class ThemeList {
  final String? title;
  final String? subtitle;

  ThemeList({this.title, this.subtitle});
}

class LanguageList {
  final String? title;

  LanguageList({this.title});
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late LanguageCubit _languageCubit;
  //late ThemeCubit _themeCubit;
  String? selectedLocal;
  String? selectedTheme =
      navigatorKey.currentState!.context.watch<ThemeNotifier>().getTheme() ==
              darkTheme
          ? 'Dark Mode'
          : 'Light Mode';
  late ThemeNotifier themeNotifier;

  final List<String> language = [
    'English',
    'عربى',
    'français',
    'bahasa Indonesia',
    'português',
    'Español',
    'italiano',
    'Türk',
    'Kiswahili'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _languageCubit = Provider.of<LanguageCubit>(context);
    //_themeCubit = Provider.of<ThemeNotifier>(context);
    themeNotifier = Provider.of<ThemeNotifier>(context);
    final List<ThemeList> themes = <ThemeList>[
      ThemeList(
        title: AppLocalizations.of(context)!.darkMode,
        subtitle: AppLocalizations.of(context)!.darkText,
      ),
      ThemeList(
        title: AppLocalizations.of(context)!.lightMode,
        subtitle: AppLocalizations.of(context)!.lightText,
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CommonAppNavBar(
        titleWidget: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(AppLocalizations.of(context)!.settings!,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
        ),
      ),
      body: FadedSlideAnimation(
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  height: 57.7,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  //color: kCardBackgroundColor,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.display!,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: kTextColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.08),
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: themes.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      activeColor: buttonColor,
                      value: themes[index].title!,
                      title: Text(
                        themes[index].title!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      // subtitle: Text(
                      //   themes[index].subtitle!,
                      //   style: Theme.of(context).textTheme.bodyMedium,
                      // ),
                      groupValue: selectedTheme,
                      onChanged: (dynamic value) {
                        setState(() {
                          selectedTheme = value;
                        });
                      },
                    );
                  },
                ),
                // Container(
                //   height: 58.0,
                //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       AppLocalizations.of(context)!.selectLanguage!,
                //       style: Theme.of(context).textTheme.bodySmall!.copyWith(
                //           color: kTextColor,
                //           fontWeight: FontWeight.w500,
                //           letterSpacing: 0.08),
                //     ),
                //   ),
                // ),
                // ListView.builder(
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: language.length,
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) {
                //     return RadioListTile(
                //       value: language[index],
                //       groupValue: selectedLocal,
                //       title: Text(
                //         language[index],
                //         style: Theme.of(context).textTheme.bodyLarge,
                //       ),
                //       onChanged: (dynamic value) {
                //         setState(() {
                //           selectedLocal = value;
                //         });
                //       },
                //     );
                //   },
                // ),
                SizedBox(
                  height: 100,
                ),
              ],
              physics: BouncingScrollPhysics(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomBar(
                  text: 'Save', //AppLocalizations.of(context)!.continueText,
                  onTap: () {
                    if (selectedLocal == 'English') {
                      _languageCubit.selectLanguage('en');
                    } else if (selectedLocal == 'عربى') {
                      _languageCubit.selectLanguage('ar');
                    } else if (selectedLocal == 'português') {
                      _languageCubit.selectLanguage('pt');
                    } else if (selectedLocal == 'français') {
                      _languageCubit.selectLanguage('fr');
                    } else if (selectedLocal == 'Español') {
                      _languageCubit.selectLanguage('es');
                    } else if (selectedLocal == 'bahasa Indonesia') {
                      _languageCubit.selectLanguage('id');
                    } else if (selectedLocal == 'italiano') {
                      _languageCubit.selectLanguage('it');
                    } else if (selectedLocal == 'Türk') {
                      _languageCubit.selectLanguage('tr');
                    } else if (selectedLocal == 'Kiswahili') {
                      _languageCubit.selectLanguage('sw');
                    }
                    if (selectedTheme == 'Dark Mode') {
                      themeNotifier.selectTheme(darkTheme);
                      onThemeChanged(true, themeNotifier);
                    } else {
                      themeNotifier.selectTheme(appTheme);
                      onThemeChanged(false, themeNotifier);
                    }
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, PageRoutes.loginNavigator);
                  }),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
  (value)
      ? themeNotifier.selectTheme(darkTheme)
      : themeNotifier.selectTheme(appTheme);
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool('Dark Mode', value);
  //var darkModeOn = prefs.getBool('darkMode') ?? true;
}
