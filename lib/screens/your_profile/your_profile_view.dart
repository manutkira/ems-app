import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/your_profile/widgets/profile_avatar.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
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
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         CupertinoPageRoute(
        //           builder: (context) => const YourProfileEditScreen(),
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.edit_outlined),
        //   ),
        // ],
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
                  // basic info heading
                  Text(
                    "${local?.basicInfo}",
                    style: _sectionTitleStyle,
                  ),
                  _buildSpacer(context),
                  // name
                  BaselineRow(
                    children: [
                      Expanded(
                        child: Text(
                          "${local?.name}",
                          style: _labelStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _currentUser?.name ?? notAvailable,
                          style: kParagraph,
                        ),
                      ),
                    ],
                  ),
                  _buildSpacer(context),
                  // phone number
                  BaselineRow(
                    children: [
                      Expanded(
                        child: Text(
                          "${local?.phoneNumber}",
                          style: _labelStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _currentUser?.phone ?? notAvailable,
                          style: kParagraph,
                        ),
                      ),
                    ],
                  ),
                  _buildSpacer(context),
                  // email
                  BaselineRow(
                    children: [
                      Expanded(
                        child: Text(
                          "${local?.email}",
                          style: _labelStyle,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                              top: _currentUser!.email != null ? 4 : 0),
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            _currentUser.email ?? notAvailable,
                            style: kParagraph,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildSpacer(context),
                  // address
                  BaselineRow(
                    children: [
                      Expanded(
                        child: Text(
                          "${local?.address}",
                          style: _labelStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _currentUser.address ?? notAvailable,
                          style: kParagraph,
                        ),
                      ),
                    ],
                  ),
                  _buildSpacer(context),
                  // account type (role)
                  BaselineRow(
                    children: [
                      Expanded(
                        child: Text(
                          "${local?.accountType}",
                          style: _labelStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _currentUser.role ?? notAvailable,
                          style: kParagraph,
                        ),
                      ),
                    ],
                  ),
                  _buildSpacer(context),
                  // national id
                  Text(
                    "${local?.nationalId}",
                    style: _labelStyle,
                  ),
                  _buildSpacer(context),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "${_currentUser.imageId}",
                      width: MediaQuery.of(context).size.width,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Center(
                          child: Text('${local?.noId}', style: kParagraph),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // employee info heading
                  Text(
                    "${local?.employeeInfo}",
                    style: _sectionTitleStyle,
                  ),
                  _buildSpacer(context),
                  // salary
                  BaselineRow(
                    children: [
                      Expanded(
                        child: Text(
                          "${local?.salary}",
                          style: _labelStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "\$ ${_currentUser.salary ?? 0}",
                          // ?? notAvailable
                          style: kParagraph,
                        ),
                      ),
                    ],
                  ),
                  _buildSpacer(context),
                  // work background
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
                        _currentUser.background ?? notAvailable,
                        style: kParagraph,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isEnglish,
                    child: const SizedBox(height: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpacer(BuildContext context) {
    bool isEnglish = isInEnglish(context);
    return SizedBox(height: isEnglish ? 16 : 10);
  }
}
