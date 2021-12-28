import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/utils/services/auth_service.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  late User _currentUser;

  final UserService _userService = UserService.instance;
  final AuthService _authService = AuthService.instance;

  @override
  void initState() {
    super.initState();
    _currentUser = ref.read(currentUserProvider).user.copyWith();
  }

  Future<bool> verifyPassword() async {
    try {
      bool isVerified = await _authService.verifyPassword(
        id: _currentUser.id as int,
        password: password,
      );
      return isVerified;
    } catch (err) {
      return false;
    }
  }

  updatePassword() async {
    AppLocalizations? local = AppLocalizations.of(context);
    setState(() {
      error = "";
    });

    if (password.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
      setState(() {
        error = "${local?.errorAllRequired}";
      });
      return;
    }

    if (newPassword != confirmNewPassword) {
      setState(() {
        error = "${local?.errorPasswordMustMatch}";
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
        error = "${local?.errorVerificationFailed}";
        isLoading = false;
      });
      return;
    }

    try {
      await _userService.updateOne(
          user: _currentUser.copyWith(password: newPassword));
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
    AppLocalizations? local = AppLocalizations.of(context);
    return AppBar(
      title: Text(
        "${local?.changePassword}",
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

  /// build form
  Widget get _buildForm {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: error.isNotEmpty,
            child: Column(
              children: [
                StatusError(
                  text: error,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Text(
            "${local?.oldPassword}",
            style: kParagraph,
          ),
          SizedBox(
            height: isEnglish ? 12 : 4,
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
            "${local?.newPassword}",
            style: kParagraph,
          ),
          SizedBox(
            height: isEnglish ? 12 : 4,
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
            "${local?.confirmNewPassword}",
            style: kParagraph,
          ),
          SizedBox(
            height: isEnglish ? 12 : 4,
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
    AppLocalizations? local = AppLocalizations.of(context);

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: kWhite,
          strokeWidth: 4,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "${local?.changingPassword}",
          style: kParagraph,
        )
      ],
    ));
  }
}
