import 'package:ems/persistence/setting.dart';

class Languages {
  String flag;
  String name;
  Languages({required this.flag, required this.name});

  static List<Languages> supported = [
    Languages(
      flag: 'assets/images/flag-cambodia.svg',
      name: SettingsStore.khmerLanguage,
    ),
    Languages(
      flag: 'assets/images/flag-united-states.svg',
      name: SettingsStore.englishLanguage,
    ),
  ];
}
