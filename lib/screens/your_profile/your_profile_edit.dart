import 'dart:io';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/your_profile/widgets/profile_avatar.dart';
import 'package:ems/utils/services/auth_service.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  String mainError = "";
  bool isUploadingProfile = false;
  bool isUploadingID = false;

  late User _user;
  final AuthService _authService = AuthService.instance;
  final UserService _userService = UserService.instance;

  /// fetch user data from currentUserProvider
  /// then put it in a local variable for edits
  void fetchUserData() {
    User _currentUser = ref.read(currentUserProvider).user;
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
    try {
      User user = await _userService.updateOne(
        user: _user.copyWith(),
      );
      ref.read(currentUserProvider).setUser(user: user.copyWith());
    } catch (err) {
      //
    }
  }

  /// go back to home screen
  void closePage() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<File?> cropImage(
      {required String filePath, required String field}) async {
    AppLocalizations? local = AppLocalizations.of(context);

    File? cropped = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxHeight: 500,
      maxWidth: 700,
      aspectRatio: field == UserImageType.id
          ? const CropAspectRatio(ratioX: 3.375, ratioY: 2.125)
          : const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: kBlue,
        toolbarTitle: "${local?.cropImage}",
        toolbarWidgetColor: kWhite,
        statusBarColor: kBlue,
        backgroundColor: kBlue,
        dimmedLayerColor: kBlack,
        activeControlsWidgetColor: kWhite,
      ),
    );
    if (cropped != null) {
      return cropped;
    }
  }

  void uploadPicture({required String field, required String type}) async {
    var img = await ImagePicker().pickImage(
      source: type == 'camera' ? ImageSource.camera : ImageSource.gallery,
    );

    if (img != null) {
      File? cropped = await cropImage(filePath: img.path, field: field);

      if (cropped != null) {
        User newUser = _user.copyWith();
        setState(() {
          error = '';
          if (field == UserImageType.profile) {
            isUploadingProfile = true;
          }
          if (field == UserImageType.id) {
            isUploadingID = true;
          }
        });
        try {
          newUser = await _userService.uploadImage(
              field: field, image: cropped, user: _user);
          ref.read(currentUserProvider).setUser(user: newUser.copyWith());
        } catch (err) {
          // write error handling here
          setState(() {
            mainError = err.toString();
          });
        }
      }
    }
    setState(() {
      isUploadingProfile = false;
      isUploadingID = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    AppLocalizations? local = AppLocalizations.of(context);
    bool isAdmin = _user.role?.toLowerCase() == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${local?.editProfile}",
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  error = '';
                });
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
              const Center(
                child: ProfileAvatar(
                  isDarkBackground: false,
                ),
              ),
              _buildSpacerHeight(),
              Center(
                child: isUploadingProfile
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: kWhite,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${local?.changing}",
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: kDarkestBlue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            onPressed: () async {
                              uploadPicture(
                                field: UserImageType.profile,
                                type: 'camera',
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  MdiIcons.cameraOutline,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${local?.camera}',
                                  style: kParagraph.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: kDarkestBlue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            onPressed: () async {
                              uploadPicture(
                                field: UserImageType.profile,
                                type: 'gallery',
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  MdiIcons.image,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${local?.gallery}',
                                  style: kParagraph.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: mainError.isNotEmpty,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: StatusError(
                        text: mainError,
                      ),
                    ),
                  ),
                  Text(
                    "${local?.basicInfo}",
                    style: kHeadingThree.copyWith(fontWeight: FontWeight.w400),
                  ),
                  _buildSpacerHeight(),
                  rowWithInput(
                    size: _size,
                    defaultText: _user.name,
                    label: "${local?.name}",
                    textHint: "${local?.name}",
                    getValue: (value) {
                      setState(() {
                        _user.name = "$value";
                      });
                    },
                  ),
                  _buildSpacerHeight(),
                  rowWithInput(
                    size: _size,
                    defaultText: _user.phone,
                    label: "${local?.phoneNumber}",
                    textHint: "${local?.phoneNumber}",
                    getValue: (value) {
                      setState(() {
                        _user.phone = "$value";
                      });
                    },
                  ),
                  _buildSpacerHeight(),
                  rowWithInput(
                    size: _size,
                    defaultText: _user.email,
                    label: "${local?.email}",
                    textHint: "${local?.email}",
                    getValue: (value) {
                      setState(() {
                        _user.email = "$value";
                      });
                    },
                  ),
                  _buildSpacerHeight(),
                  rowWithInput(
                    size: _size,
                    defaultText: _user.address,
                    label: "${local?.address}",
                    textHint: "${local?.address}",
                    getValue: (value) {
                      setState(() {
                        _user.address = "$value";
                      });
                    },
                  ),
                  _buildSpacerHeight(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${local?.nationalId}",
                          style: kParagraph.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: ValueListenableBuilder(
                            valueListenable: ref
                                .watch(currentUserProvider)
                                .currentUserListenable,
                            builder: (BuildContext context, Box<User> box,
                                Widget? child) {
                              User _user = box.values.toList()[0];
                              bool isImageIDNotEmpty = _user.imageId == null ||
                                      _user.imageId!.isEmpty ||
                                      _user.imageId.runtimeType != String
                                  ? false
                                  : true;

                              return isImageIDNotEmpty
                                  ? _buildDisplayID(_user)
                                  : isUploadingID
                                      ? _buildUploadID
                                      : _buildNoID;
                            }),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Visibility(
                visible: isAdmin,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${local?.employeeInfo}",
                      style:
                          kHeadingThree.copyWith(fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),
                    rowWithInput(
                      size: _size,
                      defaultText: _user.position,
                      label: "${local?.position}",
                      textHint: "${local?.position}",
                      getValue: (value) {
                        setState(() {
                          _user.position = "$value";
                        });
                      },
                    ),
                    _buildSpacerHeight(),
                    rowWithInput(
                      size: _size,
                      defaultText: _user.skill,
                      label: "${local?.skill}",
                      textHint: "${local?.design}...",
                      getValue: (value) {
                        setState(() {
                          _user.skill = "$value";
                        });
                      },
                    ),
                    _buildSpacerHeight(),
                    rowWithInput(
                      size: _size,
                      icon: MdiIcons.currencyUsd,
                      defaultText: _user.salary,
                      label: "${local?.salary}",
                      textHint: "${local?.salary}",
                      getValue: (value) {
                        setState(() {
                          _user.salary = "$value";
                        });
                      },
                    ),
                    _buildSpacerHeight(),
                    rowWithInput(
                      size: _size,
                      defaultText: _user.rate,
                      label: 'Rate',
                      textHint: 'Good',
                      getValue: (value) {
                        setState(() {
                          _user.rate = "$value";
                        });
                      },
                    ),
                    _buildSpacerHeight(),
                  ],
                ),
              ), // Employment Info
              Visibility(
                visible: isAdmin,
                child: const SizedBox(height: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpacerHeight() {
    return const SizedBox(height: 16);
  }

  /// generates a label + input
  Widget rowWithInput({
    required Size size,
    required String label,
    required String textHint,
    required String? defaultText,
    required Function getValue,
    IconData? icon,
  }) {
    AppLocalizations? local = AppLocalizations.of(context);
    String notAvailable = "${local?.notAvailable}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toString(),
          style: kParagraph.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Container(
          //
          constraints: BoxConstraints(maxWidth: size.width * 0.6),

          child: TextBoxCustom(
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: kWhite,
                  )
                : null,
            textHint: textHint,
            getValue: getValue,
            defaultText: defaultText ?? notAvailable,
          ),
        ),
      ],
    );
  }

  /// displays id, also handle error if the image is deleted or can't be fetched
  ///
  /// @Params User user => User object used to get user.imageId
  Widget _buildDisplayID(User user) {
    AppLocalizations? local = AppLocalizations.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 120),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network("${user.imageId}", fit: BoxFit.contain,
                errorBuilder: (BuildContext _, Object __, StackTrace? ___) {
              return Visibility(
                visible: !isUploadingID,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text('${local?.errorId}'),
                  ),
                ),
              );
            }),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: isUploadingID
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: kWhite,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    children: [
                      customIconButton(
                        onTap: () {
                          uploadPicture(
                            field: UserImageType.id,
                            type: 'camera',
                          );
                        },
                        icon: MdiIcons.cameraOutline,
                      ),
                      const SizedBox(width: 5),
                      customIconButton(
                        onTap: () {
                          uploadPicture(
                            field: UserImageType.id,
                            type: 'gallery',
                          );
                        },
                        icon: MdiIcons.image,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// generate a custom icon button for id upload display
  Widget customIconButton(
      {required VoidCallback onTap, required IconData icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kDarkestBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
        ),
      ),
    );
  }

  /// loading circle when national ID is uploading
  Widget get _buildUploadID {
    return const SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        color: kWhite,
        strokeWidth: 3,
      ),
    );
  }

  /// generate No ID with buttons to upload ID images
  Widget get _buildNoID {
    AppLocalizations? local = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${local?.noId}', style: kParagraph),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                uploadPicture(
                  field: UserImageType.id,
                  type: 'camera',
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kDarkestBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  MdiIcons.cameraOutline,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                uploadPicture(
                  field: UserImageType.id,
                  type: 'gallery',
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kDarkestBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  MdiIcons.image,
                  size: 24,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  /// confirm password dialog
  /// appears after clicking submit button
  Future<dynamic> _buildDialog(context, errorString) {
    AppLocalizations? local = AppLocalizations.of(context);
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
              title: Text("${local?.confirmation}"),
              content: SizedBox(
                width: _size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${local?.pleaseEnterPassword}"),
                    const SizedBox(height: 10),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${local?.confirm}',
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
                          error = "${local?.errorInputPassword}";
                        });
                      }
                      var isVerified = await confirmPassword();
                      if (isVerified) {
                        // update info here
                        await updateProfile();
                        // if success, close. else stay open
                        closePage();
                      } else {
                        setState(
                          () {
                            loading = false;
                            error = "${local?.errorWrongPassword}";
                          },
                        );
                      }
                    }
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: TextButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${local?.cancel}',
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
      },
    );
  }
}
