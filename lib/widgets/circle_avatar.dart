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
        borderRadius: BorderRadius.circular(size),
        child: Image.network(
          imageUrl.toString(),
          fit: BoxFit.cover,
          errorBuilder: (context, err, stk) {
            return Image.asset('assets/images/bigprofile.png');
          },
          // loadingBuilder: (context, err, stk) {
          //   return const Center(
          //     child: CircularProgressIndicator(
          //       color: kWhite,
          //       strokeWidth: 2.5,
          //     ),
          //   );
          // },
        ),
      ),
    );
  }
}
