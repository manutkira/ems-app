import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:ems/screens/your_profile/your_profile_edit.dart';
import 'package:ems/screens/your_profile/your_profile_password.dart';
import 'package:ems/screens/your_profile/your_profile_view.dart';
import 'package:ems/utils/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class MenuDrawer extends ConsumerWidget {
  MenuDrawer({
    Key? key,
  }) : super(key: key);

  final AuthService _auth = AuthService.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size _size = MediaQuery.of(context).size;

    return Drawer(
      child: Container(
        color: kDarkestBlue,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: _size.width,
              height: _size.height,
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 60),

                      // Profile picture
                      ValueListenableBuilder(
                        valueListenable: ref
                            .watch(currentUserProvider)
                            .currentUserListenable,
                        builder: (BuildContext context, Box<User> box,
                            Widget? child) {
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
                                Image.asset(
                                  'assets/images/bigprofile.png',
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${currentUser?.name}",
                                  style: kHeadingThree,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${currentUser!.role ?? ""}",
                                  style: kSubtitle,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),

                      //Your Profile button
                      Material(
                        type: MaterialType.transparency,
                        child: ListTile(
                          leading: const Icon(MdiIcons.accountCircleOutline),
                          title: const Text('Your Profile'),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const YourProfileViewScreen(),
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
                          title: const Text('Edit Profile'),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const YourProfileEditScreen(),
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
                          title: const Text('Change Password'),
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
                          title: const Text('Logout'),
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

                  // Version
                  const Positioned(
                    bottom: 25,
                    right: 15,
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
        ),
      ),
    );
  }
}
