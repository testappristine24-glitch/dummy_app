import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale> with ChangeNotifier {
  LanguageCubit() : super(Locale('en'));

  void selectLanguage(String langCode) {
    emit(Locale(langCode));
    notifyListeners();
  }
}
