import 'package:ems/screens/home_screen.dart';
import 'package:ems/widgets/inputfield.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String password = "";
  String email = "";
  String error = "";

  void goToHomeScreen(BuildContext context) {
    //
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
                          email = value;
                        });
                      },
                      labelText: "Email",
                      textHint: "your email",
                      prefixIcon: const Icon(
                        Icons.email,
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
                onPressed: () {
                  setState(() {
                    error = "";
                  });
                  if (email.isEmpty | password.isEmpty) {
                    return setState(() {
                      error = "Please enter both email and password.";
                    });
                  }

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
