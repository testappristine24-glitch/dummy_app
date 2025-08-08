// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(appTheme);

  void selectTheme(ThemeData theme) {
    emit(theme);
    //nbn
  }
} */

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  selectTheme(ThemeData themeData) async {
    _themeData = themeData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var darkModeOn = prefs.getBool('darkMode') ?? true;
    notifyListeners();
  }
}
