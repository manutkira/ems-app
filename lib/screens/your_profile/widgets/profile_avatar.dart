import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({
    Key? key,
    this.radius = 200,
    required this.isDarkBackground,
  }) : super(key: key);

  final double? radius;
  final bool isDarkBackground;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: ref.watch(currentUserProvider).currentUserListenable,
      builder: (BuildContext context, Box<User> box, Widget? child) {
        User? _user = box.get(currentUserBoxName);

        return Container(
          padding: const EdgeInsets.all(10),
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: isDarkBackground ? kBlue : kDarkestBlue,
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: Image.network(
              "${_user?.image}",
              fit: BoxFit.cover,
              errorBuilder: (BuildContext _, Object __, StackTrace? ___) {
                return Image.asset(
                  "assets/images/profile-sample.png",
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
