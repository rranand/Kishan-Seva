import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class LangProvider extends ChangeNotifier {
  List<String> lang = ["en", "hi", "mr"];
  int ind = 0;

  String get whichLang => lang[ind];

  void toggleLang(int index) {
    ind = index;
    notifyListeners();
  }
}