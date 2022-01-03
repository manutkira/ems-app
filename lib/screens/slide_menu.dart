import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/persistence/setting.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:ems/screens/your_profile/widgets/profile_avatar.dart';
import 'package:ems/screens/your_profile/your_profile_edit.dart';
import 'package:ems/screens/your_profile/your_profile_password.dart';
import 'package:ems/screens/your_profile/your_profile_view.dart';
import 'package:ems/utils/services/auth_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class MenuDrawer extends ConsumerStatefulWidget {
  const MenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends ConsumerState<MenuDrawer> {
  final AuthService _auth = AuthService.instance;
  final List<Languages> supportedLanguages = Languages.supported;
  String defaultLanguage = '';

  void switchLanguage(String? language) async {
    // final languageBox = Hive.box<int>(languageBoxName);
    // // if (language.isEmpty) return;
    // if (language!.toLowerCase() == 'ខ្មែរ') {
    //   languageBox.put(
    //     languageBoxName,
    //     0,
    //   );
    // }
    // if (language.toLowerCase() == 'english') {
    //   languageBox.put(
    //     languageBoxName,
    //     1,
    //   );
    // }
    print(ref.read(settingsProvider).getLanguage());

    /// make this work

    ref.read(settingsProvider).switchLanguage("$language");
    setState(() {
      defaultLanguage = ref.read(settingsProvider).getLanguage();
    });
  }

  @override
  void initState() {
    super.initState();
    defaultLanguage = ref.read(settingsProvider).getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: kDarkestBlue,
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  // Profile picture
                  Center(
                    child: ValueListenableBuilder(
                      valueListenable:
                          ref.watch(currentUserProvider).currentUserListenable,
                      builder:
                          (BuildContext context, Box<User> box, Widget? child) {
                        final listFromBox = box.values.toList();
                        final currentUser =
                            listFromBox.isNotEmpty ? listFromBox[0] : null;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const YourProfileViewScreen(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const ProfileAvatar(isDarkBackground: true),
                              const SizedBox(height: 10),
                              Text(
                                "${currentUser?.name}",
                                style: kHeadingThree,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                currentUser?.role ?? "",
                                style: kSubtitle,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  //Your Profile button
                  Material(
                    type: MaterialType.transparency,
                    child: ListTile(
                      leading: const Icon(MdiIcons.accountCircleOutline),
                      title: Text(
                        "${local?.myProfile}",
                        style: TextStyle(fontSize: isEnglish ? 16 : 14),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const YourProfileViewScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  //Edit Profile button
                  Material(
                    type: MaterialType.transparency,
                    child: ListTile(
                      leading: const Icon(MdiIcons.pencil),
                      title: Text(
                        "${local?.editProfile}",
                        style: TextStyle(fontSize: isEnglish ? 16 : 14),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const YourProfileEditScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  //Change password button
                  Material(
                    type: MaterialType.transparency,
                    child: ListTile(
                      leading: const Icon(MdiIcons.key),
                      title: Text(
                        "${local?.changePassword}",
                        style: TextStyle(fontSize: isEnglish ? 16 : 14),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                const YourProfilePasswordScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  //Logout button
                  Material(
                    type: MaterialType.transparency,
                    child: ListTile(
                      leading: const Icon(MdiIcons.arrowLeftBottom),
                      title: Text(
                        "${local?.logout}",
                        style: TextStyle(fontSize: isEnglish ? 16 : 14),
                      ),
                      onTap: () async {
                        try {
                          await _auth.logout();
                          await ref.read(currentUserProvider).reset();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        } catch (err) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$err"),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 15,
                child: _buildLanguageMenu,
              ),
              const Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Text(
                    "version 1.0",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildLanguageMenu {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton(
        isDense: true,
        iconSize: 0,
        elevation: 4,
        itemHeight: 50,
        dropdownColor: kBlue,
        underline: Container(),
        borderRadius: BorderRadius.circular(6),
        value: defaultLanguage,
        items: [
          ...supportedLanguages.map(
            (e) {
              String flag = e.flag;
              String name = e.name;
              return DropdownMenuItem(
                value: name,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      flag,
                      width: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        onChanged: (String? language) => switchLanguage(language),
      ),
    );
  }
}

class Languages {
  String flag;
  String name;
  Languages({required this.flag, required this.name});

  static List<Languages> supported = [
    Languages(flag: 'assets/images/flag-cambodia.svg', name: 'ខ្មែរ'),
    Languages(flag: 'assets/images/flag-united-states.svg', name: 'English'),
  ];
}
