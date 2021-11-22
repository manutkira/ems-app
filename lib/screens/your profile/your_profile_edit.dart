import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/providers/current_user.dart';
import 'package:ems/utils/services/auth_service.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class YourProfileEditScreen extends ConsumerStatefulWidget {
  const YourProfileEditScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _YourProfileEditScreenState();
}

class _YourProfileEditScreenState extends ConsumerState<YourProfileEditScreen> {
  String password = '';
  String oldPassword = '';
  String error = "";

  late User _user;
  final AuthService _authService = AuthService.instance;
  final UserService _userService = UserService.instance;

  /// fetch user data from currentUserProvider
  /// then put it in a local variable for edits
  void fetchUserData() {
    User _currentUser = ref.read(currentUserProvider);
    setState(() {
      _user = _currentUser.copyWith();
    });
  }

  /// confirm password using authservice
  /// returns boolean
  Future<bool> confirmPassword() async {
    if (oldPassword.isEmpty) {
      setState(() {
        error = "Please input password.";
      });
      return false;
    }

    try {
      bool isVerified = await _authService.verifyPassword(
          id: _user.id as int, password: oldPassword);
      return isVerified;
    } catch (err) {
      setState(() {
        error = err.toString();
      });
      return false;
    }
  }

  /// update the profile using user service
  /// then setting the current user state
  Future<void> updateProfile() async {
    String finalPassword = password.isEmpty ? "${_user.password}" : password;
    User user = User();

    try {
      await _userService.updateOne(
          user: _user.copyWith(password: finalPassword));
      ref
          .read(currentUserProvider.notifier)
          .setUser(user.copyWith(password: _user.password));
    } catch (err) {
      ///
    }
  }

  /// go back to home screen
  void closePage() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
        ),
        actions: [
          IconButton(
              onPressed: () {
                _buildDialog(context, error);
              },
              icon: const Icon(
                Icons.check,
                size: 30,
              ))
        ],
      ),
      body: SingleChildScrollView(
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
                    style: kHeadingThree.copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        //
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),

                        child: TextBoxCustom(
                          textHint: 'username',
                          getValue: (value) {
                            setState(() {
                              _user.name = "$value";
                            });
                          },
                          defaultText: "${_user.name ?? ""}",
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
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        //
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),

                        child: TextBoxCustom(
                          textHint: 'Phone Number',
                          getValue: (value) {
                            setState(() {
                              _user.phone = value;
                            });
                          },
                          defaultText: "${_user.phone ?? ""}",
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
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),
                        child: TextBoxCustom(
                          defaultText: "${_user.email ?? ""}",
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
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),
                        child: TextBoxCustom(
                          defaultText: "${_user.address ?? ""}",
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
                    style: kHeadingThree.copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Position",
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        //
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),

                        child: TextBoxCustom(
                          textHint: 'position',
                          getValue: (value) {
                            setState(() {
                              _user.position = value;
                            });
                          },
                          defaultText: "${_user.position ?? ""}",
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
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        //
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),

                        child: TextBoxCustom(
                          textHint: 'skill',
                          getValue: (value) {
                            setState(() {
                              _user.skill = value;
                            });
                          },
                          defaultText: "${_user.skill ?? ""}",
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
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),
                        child: TextBoxCustom(
                          prefixIcon: const Icon(
                            MdiIcons.currencyUsd,
                            color: kWhite,
                          ),
                          defaultText: "${_user.salary ?? ""}",
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
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),
                        child: TextBoxCustom(
                          defaultText: "${_user.status ?? ""}",
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
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: _size.width * 0.6),
                        child: TextBoxCustom(
                          defaultText: "${_user.rate ?? ""}",
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
                ],
              ), // Employment Info
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// confirm password dialog
  /// appears after clicking submit button
  Future<dynamic> _buildDialog(context, errorString) {
    Size _size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          var error = errorString;
          bool loading = false;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                // insetPadding: const EdgeInsets.all(10),
                title: const Text("Confirmation"),
                content: SizedBox(
                  width: _size.width * 0.8,
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
                          width: _size.width,
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
                            oldPassword = value;
                          });
                        },
                        defaultText: oldPassword,
                      ),
                    ],
                  ),
                ),

                actions: [
                  Visibility(
                    visible: loading,
                    child: const CircularProgressIndicator(
                      color: kWhite,
                      strokeWidth: 3,
                    ),
                  ),
                  TextButton(
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Confirm',
                        style: kParagraph,
                      ),
                    ),
                    onPressed: () async {
                      if (loading == false) {
                        setState(() {
                          loading = true;
                          error = "";
                        });
                        if (oldPassword.isEmpty) {
                          setState(() {
                            error = "Please input password.";
                          });
                        }
                        var isVerified = await confirmPassword();
                        if (isVerified) {
                          // update info here
                          await updateProfile();
                          // if success, close. else stay open
                          closePage();
                        } else {
                          setState(() {
                            loading = false;
                            error = "Wrong password";
                          });
                        }
                      }
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: TextButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Cancel',
                          style: kParagraph,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: kRedText,
                      ),
                      onPressed: () {
                        if (loading == false) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
