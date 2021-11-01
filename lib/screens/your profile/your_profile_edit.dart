import 'package:ems/constants.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YourProfileEditScreen extends StatefulWidget {
  const YourProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<YourProfileEditScreen> createState() => _YourProfileEditScreenState();
}

class _YourProfileEditScreenState extends State<YourProfileEditScreen> {
  var name = 'loading...';
  var email = 'loading...';
  var password = '';
  var old_password = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() {
    // fetch the data here
    name = 'User Name';
    email = 'user@login.com';
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
    print("profile updated.");
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
                                      width: MediaQuery.of(context).size.width,
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                print("$name $email $password");
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Name",
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    //
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),

                    child: TextBoxCustom(
                      textHint: 'username',
                      getValue: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      defaultText: name,
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
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: TextBoxCustom(
                      defaultText: email,
                      textHint: 'email',
                      getValue: (value) {
                        setState(() {
                          email = value;
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
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
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
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
