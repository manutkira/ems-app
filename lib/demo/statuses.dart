import 'package:ems/constants.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:ems/widgets/statuses/info.dart';
import 'package:ems/widgets/statuses/success.dart';
import 'package:ems/widgets/statuses/warning.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusDemo extends StatelessWidget {
  const StatusDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Demo'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: kPaddingAll,
            child: Column(
              children: const [
                StatusSuccess(),
                SizedBox(
                  height: 10,
                ),
                StatusInfo(),
                SizedBox(
                  height: 10,
                ),
                StatusWarning(),
                SizedBox(
                  height: 10,
                ),
                StatusError(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
