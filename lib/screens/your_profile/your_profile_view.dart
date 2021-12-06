import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/your_profile/widgets/profile_avatar.dart';
import 'package:ems/screens/your_profile/your_profile_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class YourProfileViewScreen extends ConsumerWidget {
  const YourProfileViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _labelStyle = kParagraph.copyWith(fontWeight: FontWeight.w700);
    final _sectionTitleStyle =
        kHeadingThree.copyWith(fontWeight: FontWeight.w400);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Profile",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const YourProfileEditScreen(),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ref.watch(currentUserProvider).currentUserListenable,
        builder: (BuildContext context, Box<User> box, Widget? child) {
          final listFromBox = box.values.toList();
          final _currentUser = listFromBox.isNotEmpty ? listFromBox[0] : null;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        ProfileAvatar(
                          isDarkBackground: false,
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            width: 25,
                            height: 25,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: _currentUser?.status.toString() == "Active"
                                  ? kGreenBackground
                                  : _currentUser?.status.toString() ==
                                          "Inactive"
                                      ? kRedBackground
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(360),
                              boxShadow: [
                                BoxShadow(
                                  color: _currentUser?.status.toString() ==
                                          "Active"
                                      ? kGreenBackground
                                      : _currentUser?.status.toString() ==
                                              "Inactive"
                                          ? kRedBackground
                                          : Colors.grey,
                                  blurRadius: 15,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // basic info
                  Text(
                    "Basic Info",
                    style: _sectionTitleStyle,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                      children: [
                        Text(
                          "Name",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.name ?? "Not Available",
                          style: kParagraph,
                        ),
                        Text(
                          "Phone Number",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.phone ?? "Not Available",
                          style: kParagraph,
                        ),
                        Text(
                          "Email",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.email ?? "Not Available",
                          style: kParagraph,
                        ),
                        Text(
                          "Address",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.address ?? "Not Available",
                          style: kParagraph,
                        ),
                        Text(
                          "Account Type",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.role ?? "Not Available",
                          style: kParagraph,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // employee info
                  Text(
                    "Employee Info",
                    style: _sectionTitleStyle,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 160,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                      children: [
                        Text(
                          "Position",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.position ?? "Not Available",
                          style: kParagraph,
                        ),
                        Text(
                          "Skill",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.skill ?? "Not Available",
                          style: kParagraph,
                        ),
                        Text(
                          "Salary",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.salary ?? "Not Available",
                          style: kParagraph,
                        ),
                        Text(
                          "Rate",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.rate ?? "Not Available",
                          style: kParagraph,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Background",
                        style: _labelStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        _currentUser?.background ?? "Not Available",
                        style: kParagraph,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
