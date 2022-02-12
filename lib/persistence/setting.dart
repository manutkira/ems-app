import 'package:ems/l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const languageBoxName = 'languageBox';

class SettingsStore {
  static String get khmerLanguage => "ខ្មែរ";
  static String get englishLanguage => "English";
  init() async {
    await Hive.initFlutter();
    await Hive.openBox<int>(languageBoxName);

    final languageBox = Hive.box<int>(languageBoxName);
    var language = languageBox.get(languageBoxName);
    if (language == null) {
      languageBox.put(
        languageBoxName,
        0,
      );
    }
  }

  String getLanguage() {
    final languageBox = Hive.box<int>(languageBoxName);
    var language = languageBox.get(languageBoxName);
    bool isInKhmer = L10n.all[language ?? 0] == L10n.all[0];
    if (isInKhmer) {
      return khmerLanguage;
    } else {
      return englishLanguage;
    }
  }

  Future<void> switchLanguage(String language) async {
    final languageBox = Hive.box<int>(languageBoxName);
    if (language.isEmpty) return;
    if (language.toLowerCase() == khmerLanguage.toLowerCase()) {
      await languageBox.put(languageBoxName, 0);
    }
    if (language.toLowerCase() == englishLanguage.toLowerCase()) {
      await languageBox.put(languageBoxName, 1);
    }
  }

  void toggleLanguage() {
    final languageBox = Hive.box<int>(languageBoxName);
    var language = languageBox.get(languageBoxName);
    bool isInKhmer = L10n.all[language ?? 0] == L10n.all[0];
    if (isInKhmer) {
      languageBox.put(languageBoxName, 1);
    } else {
      languageBox.put(languageBoxName, 0);
    }
  }

  int get locale {
    final box = Hive.box<int>(languageBoxName);
    final listFromBox = box.values.toList();
    return listFromBox[0];
  }

  /// to be used with ValueListenableBuilder
  ValueListenable<Box<int>> get settingsListenable =>
      Hive.box<int>(languageBoxName).listenable();
}

final settingsProvider = Provider<SettingsStore>(
  (ref) => throw UnimplementedError(),
);

// final connectionStatusProvider = StateProvider<bool>((ref) {
//   bool isOnline = false;
//   InternetConnectionChecker().onStatusChange.listen((status) {
//     isOnline = status == InternetConnectionStatus.connected;
//     print('from provider $isOnline');
//   });
//   return isOnline;
// });
