//

import 'package:animate_do/animate_do.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/home_screen.dart';
import 'package:ems/services/auth.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/inputfield.dart';
import 'package:ems/widgets/language_menu.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import 'home_screen_employee.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String password = "";
  String phone = "";
  String error = "";
  bool isLoading = false;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  final AuthService _authService = AuthService.instance;

  Future<void> logUserIn() async {
    // reset error, start loading
    setStateIfMounted(() {
      error = "";
      isLoading = true;
    });

    // call the api
    try {
      await _authService.login(phone: phone, password: password);
      if (!mounted) return;
    } catch (err) {
      setStateIfMounted(() {
        error = err.toString();
      });
    }

    // after finished the api call, stop loading.
    setStateIfMounted(() {
      isLoading = false;
    });

    // if there's an error, stop.
    if (error.isNotEmpty) {
      return;
    }

    // otherwise, move to home screen
    User user = ref.read(currentUserProvider).user;
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) {
          // if user is an admin, load the admin screen
          if (user.role!.toLowerCase() == 'admin') {
            return HomeScreenAdmin(isOnline: true);
          } else {
            // otherwise, load the employee screen
            return HomeScreenEmployee(isOnline: true);
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                FadeIn(
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    children: [
                      Container(
                        padding: kPadding,
                        width: MediaQuery.of(context).size.width,
                        child: SvgPicture.asset(
                          'assets/images/graph.svg',
                          semanticsLabel: "graph illustration",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Internal EMS",
                        style: kHeadingOne.copyWith(fontSize: 42),
                      ),
                    ],
                  ),
                ),
                FadeIn(
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: kPadding,
                    child: const LanguageMenu(),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: kPadding,
                  child: error.isNotEmpty
                      ? StatusError(
                          text: error,
                        )
                      : null,
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: kPadding,
                  child: Column(
                    children: [
                      FadeIn(
                        duration: const Duration(milliseconds: 250),
                        child: InputField(
                          getValue: (value) {
                            setStateIfMounted(() {
                              phone = value;
                            });
                          },
                          labelText: "${local?.phoneNumber}",
                          textHint: "${local?.phoneNumber}",
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: kWhite,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      FadeIn(
                        duration: const Duration(milliseconds: 250),
                        child: InputField(
                          getValue: (value) {
                            setStateIfMounted(() {
                              password = value;
                            });
                          },
                          textInputAction: TextInputAction.done,
                          isPassword: true,
                          labelText: "${local?.password}",
                          textHint: "${local?.password}",
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: kWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35.0,
                ),
                FadeIn(
                  duration: const Duration(milliseconds: 250),
                  child: isLoading
                      ? _buildLoading
                      : TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.only(
                              top: isEnglish ? 10 : 4,
                              bottom: isEnglish ? 10 : 2,
                              right: isEnglish ? 14 : 16,
                              left: isEnglish ? 14 : 16,
                            ),
                            primary: Colors.white,
                            textStyle: kParagraph,
                            backgroundColor: kDarkestBlue,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(kBorderRadius),
                            ),
                          ),
                          onPressed: () async {
                            await logUserIn();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${local?.login}',
                                style: kParagraph.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildLoading {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      // width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.only(
        top: isEnglish ? 10 : 4,
        bottom: isEnglish ? 10 : 2,
        right: isEnglish ? 14 : 16,
        left: isEnglish ? 14 : 16,
      ),
      decoration: const BoxDecoration(
        color: kDarkestBlue,
        borderRadius: BorderRadius.all(kBorderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: kWhite,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${local?.loggingIn}',
            style: kParagraph.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
