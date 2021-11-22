import 'package:ems/models/user.dart';
import 'package:ems/providers/current_user.dart';
import 'package:ems/utils/services/auth_service.dart';
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
  String newPassword = "";
  String confirmNewPassword = "";
  String error = "";
  bool isLoading = false;

  late User _user;

  final UserService _userService = UserService.instance;
  final AuthService _authService = AuthService.instance;

  @override
  void initState() {
    super.initState();
    _user = ref.read(currentUserProvider).copyWith();
  }

  Future<bool> verifyPassword() async {
    try {
      return _authService.verifyPassword(
          id: _user.id as int, password: password);
    } catch (err) {
      return false;
    }
  }

  updatePassword() async {
    setState(() {
      error = "";
    });

    if (password.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
      setState(() {
        error = "Please all text inputs are required.";
      });
      return;
    }

    if (newPassword != confirmNewPassword) {
      setState(() {
        error = "Passwords must match.";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    /// verified password
    bool isVerified = await verifyPassword();
    if (isVerified == false) {
      setState(() {
        error = "Password verification failed.";
        isLoading = false;
      });
      return;
    }

    try {
      User user = await _userService.updateOne(
          user: _user.copyWith(password: newPassword));
      ref
          .read(currentUserProvider.notifier)
          .setUser(user.copyWith(password: _user.password));

      setState(() {
        isLoading = false;
      });
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
        appBar: _buildAppBar, body: isLoading ? _buildLoading : _buildForm);
  }

  /// app bar
  PreferredSizeWidget get _buildAppBar {
    return AppBar(
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
    );
  }

  /// form
  Widget get _buildForm {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: error.isNotEmpty,
            child: Column(
              children: [
                StatusError(
                  text: error,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
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
                newPassword = value;
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
                confirmNewPassword = value;
              });
            },
          ),
        ],
      ),
    );
  }

  /// loading widget
  Widget get _buildLoading {
    return Center(
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
    ));
  }
}
