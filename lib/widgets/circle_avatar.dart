import 'package:ems/constants.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({Key? key, required this.imageUrl, this.size = 40})
      : super(key: key);
  final String imageUrl;
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          imageUrl,
          errorBuilder: (context, err, stk) {
            return Image.asset('assets/images/bigprofile.png');
          },
          loadingBuilder: (context, err, stk) {
            return const Center(
              child: CircularProgressIndicator(
                color: kWhite,
                strokeWidth: 2.5,
              ),
            );
          },
        ),
      ),
    );
  }
}
