import 'package:ems/models/user.dart';
import 'package:ems/providers/current_user.dart';
import 'package:ems/screens/login_screen.dart';
import 'package:ems/screens/your%20profile/your_profile_view.dart';
import 'package:ems/utils/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class MenuDrawer extends ConsumerWidget {
  MenuDrawer({
    Key? key,
  }) : super(key: key);

  AuthService _auth = AuthService().instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User _user = ref.watch(currentUserProvider.notifier).state;

    return Drawer(
      child: Container(
        color: kDarkestBlue,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(top: 60),
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/bigprofile.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${_user.name}",
                    style: kHeadingThree,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${_user.role}",
                    style: kSubtitle,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Material(
                type: MaterialType.transparency,
                child: ListTile(
                  leading: const Icon(MdiIcons.accountCircleOutline),
                  title: const Text('Your Profile'),
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => YourProfileViewScreen()));
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.45),
              Material(
                type: MaterialType.transparency,
                child: ListTile(
                  leading: const Icon(MdiIcons.arrowLeftBottom),
                  title: const Text('Logout'),
                  onTap: () async {
                    try {
                      await _auth.logout(currentUserId: _user.id as int);
                      ref.read(currentUserProvider.notifier).reset();
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
              const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  "version 1.0",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
