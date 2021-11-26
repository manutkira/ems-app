import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/your%20profile/your_profile_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class YourProfileViewScreen extends ConsumerWidget {
  const YourProfileViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var _currentUser = ref.watch(currentUserProvider).user;
    var _labelStyle = kParagraph.copyWith(fontWeight: FontWeight.w700);
    var _sectionTitleStyle =
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
              icon: const Icon(Icons.edit_outlined))
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ref.watch(currentUserProvider).currentUserListenable,
        builder: (BuildContext context, Box<User> box, Widget? child) {
          final _currentUser = box.values.toList()[0];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: kDarkestBlue,
                          radius: 75,
                          child: Image.asset(
                            'assets/images/bigprofile.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: Container(
                            width: 25,
                            height: 25,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: _currentUser.status.toString() == "Active"
                                  ? kGreenBackground
                                  : _currentUser.status.toString() == "Inactive"
                                      ? kRedBackground
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(360),
                              boxShadow: [
                                BoxShadow(
                                    color: _currentUser.status.toString() ==
                                            "Active"
                                        ? kGreenBackground
                                        : _currentUser.status.toString() ==
                                                "Inactive"
                                            ? kRedBackground
                                            : Colors.grey,
                                    blurRadius: 15)
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
                  Text(
                    "Basic Info",
                    style: _sectionTitleStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: _labelStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Phone Number",
                              style: _labelStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Email",
                              style: _labelStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Address",
                              style: _labelStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Account Type",
                              style: _labelStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentUser.name ?? "Not Available",
                              style: kParagraph,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              _currentUser.phone ?? "Not Available",
                              style: kParagraph,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              _currentUser.email ?? "Not Available",
                              style: kParagraph,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              _currentUser.address ?? "Not Available",
                              style: kParagraph,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              _currentUser.role ?? "Employee",
                              style: kParagraph,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Employee Info",
                    style: _sectionTitleStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Position",
                              style: _labelStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Skill",
                              style: _labelStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Salary",
                              style: _labelStyle,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Rate",
                              style: _labelStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentUser.position ?? "Not Available",
                              style: kParagraph,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              _currentUser.skill ?? "Not Available",
                              style: kParagraph,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "\$${_currentUser.salary ?? "Not Available"}",
                              style: kParagraph,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              _currentUser.rate ?? "Not Available",
                              style: kParagraph,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Background",
                        style: _labelStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _currentUser.background ?? "Not Available",
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
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(20),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Center(
      //           child: Stack(
      //             children: [
      //               CircleAvatar(
      //                 backgroundColor: kDarkestBlue,
      //                 radius: 75,
      //                 child: Image.asset(
      //                   'assets/images/bigprofile.png',
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //               Positioned(
      //                 bottom: 0,
      //                 right: 10,
      //                 child: Container(
      //                   width: 25,
      //                   height: 25,
      //                   padding: const EdgeInsets.symmetric(
      //                       horizontal: 15, vertical: 5),
      //                   decoration: BoxDecoration(
      //                     color: _currentUser.status.toString() == "Active"
      //                         ? kGreenBackground
      //                         : _currentUser.status.toString() == "Inactive"
      //                             ? kRedBackground
      //                             : Colors.grey,
      //                     borderRadius: BorderRadius.circular(360),
      //                     boxShadow: [
      //                       BoxShadow(
      //                           color:
      //                               _currentUser.status.toString() == "Active"
      //                                   ? kGreenBackground
      //                                   : _currentUser.status.toString() ==
      //                                           "Inactive"
      //                                       ? kRedBackground
      //                                       : Colors.grey,
      //                           blurRadius: 15)
      //                     ],
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //         const SizedBox(
      //           height: 40,
      //         ),
      //         Text(
      //           "Basic Info",
      //           style: _sectionTitleStyle,
      //         ),
      //         const SizedBox(
      //           height: 20,
      //         ),
      //         Row(
      //           children: [
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     "Name",
      //                     style: _labelStyle,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "Phone Number",
      //                     style: _labelStyle,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "Email",
      //                     style: _labelStyle,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "Address",
      //                     style: _labelStyle,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "Account Type",
      //                     style: _labelStyle,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     _currentUser.name ?? "Not Available",
      //                     style: kParagraph,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     _currentUser.phone ?? "Not Available",
      //                     style: kParagraph,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     _currentUser.email ?? "Not Available",
      //                     style: kParagraph,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     _currentUser.address ?? "Not Available",
      //                     style: kParagraph,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     _currentUser.role ?? "Employee",
      //                     style: kParagraph,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         const SizedBox(
      //           height: 40,
      //         ),
      //         Text(
      //           "Employee Info",
      //           style: _sectionTitleStyle,
      //         ),
      //         const SizedBox(
      //           height: 20,
      //         ),
      //         Row(
      //           children: [
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     "Position",
      //                     style: _labelStyle,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "Skill",
      //                     style: _labelStyle,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "Salary",
      //                     style: _labelStyle,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "Rate",
      //                     style: _labelStyle,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Expanded(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     _currentUser.position ?? "Not Available",
      //                     style: kParagraph,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     _currentUser.skill ?? "Not Available",
      //                     style: kParagraph,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     "\$${_currentUser.salary ?? "Not Available"}",
      //                     style: kParagraph,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Text(
      //                     _currentUser.rate ?? "Not Available",
      //                     style: kParagraph,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         const SizedBox(
      //           height: 20,
      //         ),
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               "Background",
      //               style: _labelStyle,
      //             ),
      //             const SizedBox(
      //               height: 10,
      //             ),
      //             Text(
      //               _currentUser.background ?? "Not Available",
      //               style: kParagraph,
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
