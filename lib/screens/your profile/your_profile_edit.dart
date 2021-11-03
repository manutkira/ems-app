import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/users.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YourProfileEditScreen extends StatefulWidget {
  const YourProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<YourProfileEditScreen> createState() => _YourProfileEditScreenState();
}

class _YourProfileEditScreenState extends State<YourProfileEditScreen> {
  var password = '';
  var old_password = '';

  bool loading = true;
  late User _user;

  @override
  void initState() {
    super.initState();
    // fetchUserData();
  }

  Future<User> fetchUserData() {
    var future = UserService().getUser(1);
    future.then((snapshot) {
      setState(() {
        _user = snapshot;
      });
    });
    return future;
  }

  Future<bool> confirmPassword() async {
    if (old_password.isNotEmpty) {
      // fetch verify password route here
      print('old password: $old_password');
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateProfile() async {
    // await fetch('/api/updateprofile');

    print("profile updated. ${_user.name}");
  }

  void popupDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2014),
            lastDate: DateTime.now())
        .then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        _user.createdAt = picked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit Profile",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        var error = "";
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              insetPadding: const EdgeInsets.all(10),
                              title: const Text("Confirmation"),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                        "Please enter your password to save the changes."),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: error.isNotEmpty
                                            ? Column(
                                                children: [
                                                  StatusError(
                                                    text: error,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              )
                                            : null),
                                    TextBoxCustom(
                                      isPassword: true,
                                      textHint: 'your password',
                                      getValue: (value) {
                                        setState(() {
                                          old_password = value;
                                        });
                                      },
                                      defaultText: old_password,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'Confirm',
                                      style: kParagraph,
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      error = "";
                                    });
                                    if (old_password.isEmpty) {
                                      setState(() {
                                        error = "Please input password.";
                                      });
                                    }
                                    var isVerified = await confirmPassword();
                                    if (isVerified) {
                                      // update info here
                                      await updateProfile();
                                      // if success, close. else stay open
                                      Navigator.of(context).pop();
                                    } else {
                                      setState(() {
                                        error = "Wrong password";
                                      });
                                    }
                                  },
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  child: TextButton(
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'Cancel',
                                        style: kParagraph,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: kRedText,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      });
                  // print("$name $email $password");
                },
                icon: const Icon(
                  Icons.check,
                  size: 30,
                ))
          ],
        ),
        body: FutureBuilder<User>(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundColor: kDarkestBlue,
                            radius: 75,
                            child: Image.asset(
                              'assets/images/bigprofile.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Basic Info",
                              style: kHeadingThree.copyWith(
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  //
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),

                                  child: TextBoxCustom(
                                    textHint: 'username',
                                    getValue: (value) {
                                      print(value);
                                      setState(() {
                                        _user.name = value;
                                      });
                                    },
                                    defaultText: "${snapshot.data!.name}",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Phone",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  //
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),

                                  child: TextBoxCustom(
                                    textHint: 'Phone Number',
                                    getValue: (value) {
                                      setState(() {
                                        _user.phone = value;
                                      });
                                    },
                                    defaultText: _user.phone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Email",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: TextBoxCustom(
                                    defaultText: _user.email as String,
                                    textHint: 'email',
                                    getValue: (value) {
                                      setState(() {
                                        _user.email = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Address",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: TextBoxCustom(
                                    defaultText: _user.address as String,
                                    textHint: 'address',
                                    getValue: (value) {
                                      setState(() {
                                        _user.address = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Password",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: TextBoxCustom(
                                    isPassword: true,
                                    textHint: 'password',
                                    getValue: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    },
                                    defaultText: password,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Employment Info",
                              style: kHeadingThree.copyWith(
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Position",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  //
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),

                                  child: TextBoxCustom(
                                    textHint: 'position',
                                    getValue: (value) {
                                      setState(() {
                                        _user.position = value;
                                      });
                                    },
                                    defaultText: "${_user.position}",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Skill",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  //
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),

                                  child: TextBoxCustom(
                                    textHint: 'skill',
                                    getValue: (value) {
                                      setState(() {
                                        _user.skill = value;
                                      });
                                    },
                                    defaultText: "${_user.skill}",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Salary",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: TextBoxCustom(
                                    defaultText: "${_user.salary}",
                                    textHint: 'salary',
                                    getValue: (value) {
                                      setState(() {
                                        _user.salary = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Status",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: TextBoxCustom(
                                    defaultText: "${_user.status}",
                                    textHint: 'status',
                                    getValue: (value) {
                                      setState(() {
                                        _user.status = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rate",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: TextBoxCustom(
                                    defaultText: "${_user.rate}",
                                    textHint: 'rate',
                                    getValue: (value) {
                                      setState(() {
                                        _user.rate = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Start",
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                // Container(
                                //   constraints: BoxConstraints(
                                //       maxWidth:
                                //           MediaQuery.of(context).size.width *
                                //               0.6),
                                //   child: TextBoxCustom(
                                //     defaultText: DateFormat('dd-MM-yyyy')
                                //         .format(_user.createdAt),
                                //     textHint: 'createdAt',
                                //     getValue: (value) {
                                //       setState(() {
                                //         _user.createdAt = value;
                                //       });
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                            Text(DateFormat('dd-MM-yyyy')
                                .format(_user.createdAt)),
                            GestureDetector(
                              onTap: popupDate,
                              child: Container(
                                height: 40,
                                width: 40,
                                color: kBlack,
                              ),
                            )
                          ],
                        ), // Employment Info
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return const Text('Error fetching data.');
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: kWhite,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("fetching data"),
                    ],
                  ),
                );
              }
            }
            // body: SingleChildScrollView(
            //   child: Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: Column(
            //       children: [
            //         Center(
            //           child: CircleAvatar(
            //             backgroundColor: kDarkestBlue,
            //             radius: 75,
            //             child: Image.asset(
            //               'assets/images/bigprofile.png',
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 40,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               "Name",
            //               style: kParagraph.copyWith(fontWeight: FontWeight.w700),
            //             ),
            //             Container(
            //               //
            //               constraints: BoxConstraints(
            //                   maxWidth: MediaQuery.of(context).size.width * 0.6),
            //
            //               child: TextBoxCustom(
            //                 textHint: 'username',
            //                 getValue: (value) {
            //                   setState(() {
            //                     _user.name = value;
            //                   });
            //                 },
            //                 defaultText: _user.name,
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               "Email",
            //               style: kParagraph.copyWith(fontWeight: FontWeight.w700),
            //             ),
            //             Container(
            //               constraints: BoxConstraints(
            //                   maxWidth: MediaQuery.of(context).size.width * 0.6),
            //               child: TextBoxCustom(
            //                 defaultText: _user.email as String,
            //                 textHint: 'email',
            //                 getValue: (value) {
            //                   setState(() {
            //                     _user.email = value;
            //                   });
            //                 },
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               "Password",
            //               style: kParagraph.copyWith(fontWeight: FontWeight.w700),
            //             ),
            //             Container(
            //               constraints: BoxConstraints(
            //                   maxWidth: MediaQuery.of(context).size.width * 0.6),
            //               child: TextBoxCustom(
            //                 isPassword: true,
            //                 textHint: 'password',
            //                 getValue: (value) {
            //                   setState(() {
            //                     password = value;
            //                   });
            //                 },
            //                 defaultText: password,
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // body: FutureBuilder<User>(
            //     future: _user,
            //     builder: (context, snapshot) {
            //       print(snapshot.data!.name);
            //       if (snapshot.hasData) {
            //         return SingleChildScrollView(
            //           child: Padding(
            //             padding: const EdgeInsets.all(20),
            //             child: Column(
            //               children: [
            //                 Center(
            //                   child: CircleAvatar(
            //                     backgroundColor: kDarkestBlue,
            //                     radius: 75,
            //                     child: Image.asset(
            //                       'assets/images/bigprofile.png',
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(
            //                   height: 40,
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       "Name",
            //                       style: kParagraph.copyWith(
            //                           fontWeight: FontWeight.w700),
            //                     ),
            //                     Container(
            //                       //
            //                       constraints: BoxConstraints(
            //                           maxWidth:
            //                               MediaQuery.of(context).size.width * 0.6),
            //
            //                       child: TextBoxCustom(
            //                         textHint: 'username',
            //                         getValue: (value) {
            //                           setState(() {
            //                             name = value;
            //                           });
            //                         },
            //                         defaultText: name,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 const SizedBox(
            //                   height: 20,
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       "Email",
            //                       style: kParagraph.copyWith(
            //                           fontWeight: FontWeight.w700),
            //                     ),
            //                     Container(
            //                       constraints: BoxConstraints(
            //                           maxWidth:
            //                               MediaQuery.of(context).size.width * 0.6),
            //                       child: TextBoxCustom(
            //                         defaultText: email,
            //                         textHint: 'email',
            //                         getValue: (value) {
            //                           setState(() {
            //                             email = value;
            //                           });
            //                         },
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 const SizedBox(
            //                   height: 20,
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       "Password",
            //                       style: kParagraph.copyWith(
            //                           fontWeight: FontWeight.w700),
            //                     ),
            //                     Container(
            //                       constraints: BoxConstraints(
            //                           maxWidth:
            //                               MediaQuery.of(context).size.width * 0.6),
            //                       child: TextBoxCustom(
            //                         isPassword: true,
            //                         textHint: 'password',
            //                         getValue: (value) {
            //                           setState(() {
            //                             password = value;
            //                           });
            //                         },
            //                         defaultText: password,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 const SizedBox(
            //                   height: 20,
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
            //     }),
            // body: SingleChildScrollView(
            //   child: Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: Column(
            //       children: [
            //         Center(
            //           child: CircleAvatar(
            //             backgroundColor: kDarkestBlue,
            //             radius: 75,
            //             child: Image.asset(
            //               'assets/images/bigprofile.png',
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 40,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               "Name",
            //               style: kParagraph.copyWith(fontWeight: FontWeight.w700),
            //             ),
            //             Container(
            //               //
            //               constraints: BoxConstraints(
            //                   maxWidth: MediaQuery.of(context).size.width * 0.6),
            //
            //               child: TextBoxCustom(
            //                 textHint: 'username',
            //                 getValue: (value) {
            //                   setState(() {
            //                     name = value;
            //                   });
            //                 },
            //                 defaultText: name,
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               "Email",
            //               style: kParagraph.copyWith(fontWeight: FontWeight.w700),
            //             ),
            //             Container(
            //               constraints: BoxConstraints(
            //                   maxWidth: MediaQuery.of(context).size.width * 0.6),
            //               child: TextBoxCustom(
            //                 defaultText: email,
            //                 textHint: 'email',
            //                 getValue: (value) {
            //                   setState(() {
            //                     email = value;
            //                   });
            //                 },
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               "Password",
            //               style: kParagraph.copyWith(fontWeight: FontWeight.w700),
            //             ),
            //             Container(
            //               constraints: BoxConstraints(
            //                   maxWidth: MediaQuery.of(context).size.width * 0.6),
            //               child: TextBoxCustom(
            //                 isPassword: true,
            //                 textHint: 'password',
            //                 getValue: (value) {
            //                   setState(() {
            //                     password = value;
            //                   });
            //                 },
            //                 defaultText: password,
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            ));
  }
}
