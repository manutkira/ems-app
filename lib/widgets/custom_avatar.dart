import 'package:ems/models/user.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, required this.user, this.radius = 60})
      : super(key: key);
  final User? user;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: user != null
          ? Image.network(
              "${user?.image}",
              fit: BoxFit.cover,
              errorBuilder: (ctx, e, stk) {
                return Image.asset('assets/images/bigprofile.png');
              },
            )
          : Image.asset('assets/images/bigprofile.png'),
    );
  }
}
