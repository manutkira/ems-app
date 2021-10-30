import 'package:ems/screens/login_screen.dart';
import 'package:ems/screens/your%20profile/your_profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key? key,
  }) : super(key: key);

  void logout() {
    // logout here
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    "User Name",
                    style: kHeadingThree,
                  ),
                  const Text(
                    "Admin",
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
                  onTap: () {
                    logout();
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
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
