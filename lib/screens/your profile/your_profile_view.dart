import 'package:ems/constants.dart';
import 'package:ems/providers/current_user.dart';
import 'package:ems/screens/your%20profile/your_profile_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourProfileViewScreen extends ConsumerWidget {
  const YourProfileViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _currentUser = ref.watch(currentUserProvider.notifier).state;

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
      body: SingleChildScrollView(
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
                                color:
                                    _currentUser.status.toString() == "Active"
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Phone Number",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Email",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Address",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Account Type",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Position",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Skill",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Salary",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Rate",
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentUser.name.toString(),
                          style: kParagraph,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _currentUser.phone.toString(),
                          style: kParagraph,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _currentUser.email.toString(),
                          style: kParagraph,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _currentUser.address.toString(),
                          style: kParagraph,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Administrator",
                          style: kParagraph,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _currentUser.position.toString(),
                          style: kParagraph,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _currentUser.skill.toString(),
                          style: kParagraph,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "\$${_currentUser.salary.toString()}",
                          style: kParagraph,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          _currentUser.rate.toString(),
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
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
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
      ),
    );
    // body: FutureBuilder<User>(
    //     future: UserService().getUser(1),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         return SingleChildScrollView(
    //           child: Padding(
    //             padding: const EdgeInsets.all(20),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Center(
    //                   child: Stack(
    //                     children: [
    //                       CircleAvatar(
    //                         backgroundColor: kDarkestBlue,
    //                         radius: 75,
    //                         child: Image.asset(
    //                           'assets/images/bigprofile.png',
    //                           fit: BoxFit.cover,
    //                         ),
    //                       ),
    //                       Positioned(
    //                         bottom: 0,
    //                         right: 10,
    //                         child: Container(
    //                           width: 25,
    //                           height: 25,
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 15, vertical: 5),
    //                           decoration: BoxDecoration(
    //                             color: snapshot.data!.status.toString() ==
    //                                     "Active"
    //                                 ? kGreenBackground
    //                                 : snapshot.data!.status.toString() ==
    //                                         "Inactive"
    //                                     ? kRedBackground
    //                                     : Colors.grey,
    //                             borderRadius: BorderRadius.circular(360),
    //                             boxShadow: [
    //                               BoxShadow(
    //                                   color: snapshot.data!.status
    //                                               .toString() ==
    //                                           "Active"
    //                                       ? kGreenBackground
    //                                       : snapshot.data!.status
    //                                                   .toString() ==
    //                                               "Inactive"
    //                                           ? kRedBackground
    //                                           : Colors.grey,
    //                                   blurRadius: 15)
    //                             ],
    //                           ),
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   height: 40,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             "Name",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Phone Number",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Email",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Address",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Account Type",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Position",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Skill",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Salary",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Rate",
    //                             style: kParagraph.copyWith(
    //                                 fontWeight: FontWeight.w700),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             snapshot.data!.name.toString(),
    //                             style: kParagraph,
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             snapshot.data!.phone.toString(),
    //                             style: kParagraph,
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             snapshot.data!.email.toString(),
    //                             style: kParagraph,
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             snapshot.data!.address.toString(),
    //                             style: kParagraph,
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "Administrator",
    //                             style: kParagraph,
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             snapshot.data!.position.toString(),
    //                             style: kParagraph,
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             snapshot.data!.skill.toString(),
    //                             style: kParagraph,
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             "\$${snapshot.data!.salary.toString()}",
    //                             style: kParagraph,
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Text(
    //                             snapshot.data!.rate.toString(),
    //                             style: kParagraph,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       "Background",
    //                       style: kParagraph.copyWith(
    //                           fontWeight: FontWeight.w700),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Text(
    //                       snapshot.data!.background ?? "Not Available",
    //                       style: kParagraph,
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       } else if (snapshot.hasError) {
    //         print(snapshot.error);
    //         return const Text('Error fetching data.');
    //       } else {
    //         return Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: const [
    //               CircularProgressIndicator(
    //                 color: kWhite,
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Text("fetching data"),
    //             ],
    //           ),
    //         );
    //       }
    //
    //       // By default, show a loading spinner.
    //     } // body: SingleChildScrollView(
    //     //   child: Padding(
    //     //     padding: const EdgeInsets.all(20),
    //     //     child: Column(
    //     //       children: [
    //     //         Center(
    //     //           child: CircleAvatar(
    //     //             backgroundColor: kDarkestBlue,
    //     //             radius: 75,
    //     //             child: Image.asset(
    //     //               'assets/images/bigprofile.png',
    //     //               fit: BoxFit.cover,
    //     //             ),
    //     //           ),
    //     //         ),
    //     //         const const SizedBox(
    //     //           height: 40,
    //     //         ),
    //     //         Row(
    //     //           children: [
    //     //             Column(
    //     //               crossAxisAlignment: CrossAxisAlignment.start,
    //     //               children: [
    //     //                 Text(
    //     //                   "Name",
    //     //                   style: kParagraph.copyWith(fontWeight: FontWeight.w700),
    //     //                 ),
    //     //                 const SizedBox(
    //     //                   height: 20,
    //     //                 ),
    //     //                 Text(
    //     //                   "Email",
    //     //                   style: kParagraph.copyWith(fontWeight: FontWeight.w700),
    //     //                 ),
    //     //                 const SizedBox(
    //     //                   height: 20,
    //     //                 ),
    //     //                 Text(
    //     //                   "Account Type",
    //     //                   style: kParagraph.copyWith(fontWeight: FontWeight.w700),
    //     //                 ),
    //     //               ],
    //     //             ),
    //     //             const Spacer(),
    //     //             Column(
    //     //               crossAxisAlignment: CrossAxisAlignment.start,
    //     //               children: const [
    //     //                 Text(
    //     //                   "User Name",
    //     //                   style: kParagraph,
    //     //                 ),
    //     //                 SizedBox(
    //     //                   height: 20,
    //     //                 ),
    //     //                 Text(
    //     //                   "user@login.com",
    //     //                   style: kParagraph,
    //     //                 ),
    //     //                 SizedBox(
    //     //                   height: 20,
    //     //                 ),
    //     //                 Text(
    //     //                   "Administrator",
    //     //                   style: kParagraph,
    //     //                 ),
    //     //               ],
    //     //             ),
    //     //             const Spacer(),
    //     //             const Spacer(),
    //     //           ],
    //     //         ),
    //     //       ],
    //     //     ),
    //     //   ),
    //     // ),
    //     ));
  }
}
