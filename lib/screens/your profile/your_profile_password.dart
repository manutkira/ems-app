import 'package:ems/models/user.dart';
import 'package:ems/providers/current_user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class YourProfilePasswordScreen extends ConsumerStatefulWidget {
  const YourProfilePasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _YourProfilePasswordScreenState();
}

class _YourProfilePasswordScreenState
    extends ConsumerState<YourProfilePasswordScreen> {
  String password = "";
  String new_password = "";
  String confirm_new_password = "";
  String error = "";
  bool isLoading = false;

  late User _user;

  final UserService _userService = UserService().instance;

  @override
  void initState() {
    super.initState();
    _user = ref.read(currentUserProvider.notifier).state.copyWith();
  }

  updatePassword() async {
    setState(() {
      error = "";
    });

    String _oldPassword = _user.password.toString();

    if (password.isEmpty ||
        new_password.isEmpty ||
        confirm_new_password.isEmpty) {
      setState(() {
        error = "Please all text inputs are required.";
      });
      return;
    }

    if (password != _oldPassword) {
      setState(() {
        error = "Wrong old password.";
      });
      return;
    }

    if (new_password != confirm_new_password) {
      setState(() {
        error = "Passwords must match.";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      User user = await _userService.updateOne(
          user: _user.copyWith(password: new_password));
      ref
          .read(currentUserProvider.notifier)
          .setUser(user.copyWith(password: _user.password));
    } catch (err) {
      setState(() {
        error = err.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (!isLoading) {
                await updatePassword();
                if (error.isEmpty) {
                  Navigator.of(context).pop();
                }
              }
            },
            icon: const Icon(
              Icons.check,
              size: 30,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: kWhite,
                  strokeWidth: 4,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Changing your password...",
                  style: kParagraph,
                )
              ],
            ))
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: error.isNotEmpty,
                    child: StatusError(
                      text: error,
                    ),
                  ),
                  Visibility(
                    visible: error.isNotEmpty,
                    child: const SizedBox(
                      height: 20,
                    ),
                  ),
                  Text(
                    "Old Password",
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextBoxCustom(
                    isPassword: true,
                    textHint: 'Old Password',
                    getValue: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "New Password",
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextBoxCustom(
                    isPassword: true,
                    textHint: 'New Password',
                    getValue: (value) {
                      setState(() {
                        new_password = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Confirm New Password",
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextBoxCustom(
                    isPassword: true,
                    textHint: 'Confirm Password',
                    getValue: (value) {
                      setState(() {
                        confirm_new_password = value;
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
