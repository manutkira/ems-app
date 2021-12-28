import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/your_profile/widgets/profile_avatar.dart';
import 'package:ems/screens/your_profile/your_profile_edit.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class YourProfileViewScreen extends ConsumerWidget {
  const YourProfileViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    final _labelStyle = kParagraph.copyWith(fontWeight: FontWeight.w700);
    final _sectionTitleStyle = kHeadingThree.copyWith(
      fontWeight: FontWeight.w400,
    );

    String notAvailable = "${local?.notAvailable}";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${local?.myProfile}",
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
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ref.watch(currentUserProvider).currentUserListenable,
        builder: (BuildContext context, Box<User> box, Widget? child) {
          final listFromBox = box.values.toList();
          final _currentUser = listFromBox.isNotEmpty ? listFromBox[0] : null;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        const ProfileAvatar(
                          isDarkBackground: false,
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            width: 25,
                            height: 25,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: _currentUser?.status.toString() == "Active"
                                  ? kGreenBackground
                                  : _currentUser?.status.toString() ==
                                          "Inactive"
                                      ? kRedBackground
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(360),
                              boxShadow: [
                                BoxShadow(
                                  color: _currentUser?.status.toString() ==
                                          "Active"
                                      ? kGreenBackground
                                      : _currentUser?.status.toString() ==
                                              "Inactive"
                                          ? kRedBackground
                                          : Colors.grey,
                                  blurRadius: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // basic info
                  Text(
                    "${local?.basicInfo}",
                    style: _sectionTitleStyle,
                  ),
                  Visibility(
                    visible: isEnglish,
                    child: const SizedBox(height: 20),
                  ),
                  SizedBox(
                    height: 200,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                      children: [
                        Text(
                          "${local?.name}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.name ?? notAvailable,
                          style: kParagraph,
                        ),
                        Text(
                          "${local?.phoneNumber}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.phone ?? notAvailable,
                          style: kParagraph,
                        ),
                        Text(
                          "${local?.email}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.email ?? notAvailable,
                          style: kParagraph,
                        ),
                        Text(
                          "${local?.address}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.address ?? notAvailable,
                          style: kParagraph,
                        ),
                        Text(
                          "${local?.accountType}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.role ?? notAvailable,
                          style: kParagraph,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isEnglish ? 30 : 16),
                  // employee info
                  Text(
                    "${local?.employeeInfo}",
                    style: _sectionTitleStyle,
                  ),
                  Visibility(
                    visible: isEnglish,
                    child: const SizedBox(height: 20),
                  ),
                  SizedBox(
                    height: 160,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                      children: [
                        Text(
                          "${local?.position}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.position ?? notAvailable,
                          style: kParagraph,
                        ),
                        Text(
                          "${local?.skill}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.skill ?? notAvailable,
                          style: kParagraph,
                        ),
                        Text(
                          "${local?.salary}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.salary ?? notAvailable,
                          style: kParagraph,
                        ),
                        Text(
                          "${local?.rate}",
                          style: _labelStyle,
                        ),
                        Text(
                          _currentUser?.rate ?? notAvailable,
                          style: kParagraph,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isEnglish,
                    child: const SizedBox(height: 10),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${local?.background}",
                        style: _labelStyle,
                      ),
                      Visibility(
                        visible: isEnglish,
                        child: const SizedBox(
                          height: 15,
                        ),
                      ),
                      Text(
                        _currentUser?.background ?? notAvailable,
                        style: kParagraph,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
