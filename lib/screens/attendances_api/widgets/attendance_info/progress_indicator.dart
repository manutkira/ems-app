import 'package:flutter/material.dart';

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.red,
      ),
    );
  }
}
