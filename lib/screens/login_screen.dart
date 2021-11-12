import 'package:ems/models/user.dart';
import 'package:ems/providers/current_user.dart';
import 'package:ems/screens/home_screen.dart';
import 'package:ems/utils/services/auth_service.dart';
import 'package:ems/widgets/inputfield.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String password = "";
  String phone = "";
  String error = "";

  AuthService _authService = AuthService().instance;

  void logUserIn() async {
    try {
      User _user = await _authService.login(phone: phone, password: password);
      ref.read(currentUserProvider.notifier).setUser(_user);
    } catch (err) {
      setState(() {
        error = err.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: kPadding,
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
                  'assets/images/graph.svg',
                  semanticsLabel: "graph illustration",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Internal EMS",
                style: kHeadingOne.copyWith(fontSize: 42),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: kPadding,
                child: error.isNotEmpty
                    ? StatusError(
                        text: error,
                      )
                    : null,
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: kPadding,
                child: Column(
                  children: [
                    InputField(
                      getValue: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      labelText: "Phone",
                      textHint: "your email",
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: kWhite,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InputField(
                      getValue: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      textInputAction: TextInputAction.done,
                      isPassword: true,
                      labelText: "Password",
                      textHint: "your password",
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: kWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: kPadding.copyWith(top: 10, bottom: 10),
                  primary: Colors.white,
                  textStyle: kParagraph,
                  backgroundColor: kDarkestBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(kBorderRadius),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    error = "";
                  });

                  logUserIn();

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login',
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
