import 'dart:io';

import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/your_profile/widgets/profile_avatar.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

class UploadImage extends ConsumerStatefulWidget {
  const UploadImage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _UploadImageState();
}

class _UploadImageState extends ConsumerState<UploadImage> {
  final ImagePicker _picker = ImagePicker();
  final UserService _userService = UserService.instance;
  late User _user;
  late File _photo;

  void uploadPicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('jodjsklf');
    if (image != null) {
      setState(() {
        _photo = File(image.path);
      });

      print('hihihi');

      User newUser = await _userService.uploadImage(
        user: _user,
        image: File(image.path),
      );

      print(newUser.phone);

      ref.read(currentUserProvider).setUser(user: newUser.copyWith());
      print("11asdfas1df");
      ref.refresh(currentUserProvider);
    }
  }

  @override
  void initState() {
    super.initState();
    _user = ref.read(currentUserProvider).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Center(
              child: ProfileAvatar(
                source: _photo,
                isDarkBackground: false,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kDarkestBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                onPressed: uploadPicture,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Change',
                      style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
