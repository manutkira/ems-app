import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Overtime {
  static get uid => 1;
  static get name => "Kim Song";
  static get date => DateTime.now();
  static get startedTime => TimeOfDay.now();
  static get endedTime => TimeOfDay.now();
  static get note => "finish the project";
}

class DeleteOvertime extends StatefulWidget {
  const DeleteOvertime({Key? key}) : super(key: key);

  @override
  _DeleteOvertimeState createState() => _DeleteOvertimeState();
}

class _DeleteOvertimeState extends State<DeleteOvertime> {
  bool isLoading = false;
  bool hasError = false;

  void _closePanel() {
    Navigator.of(context).pop();
  }

  void deleteOvertime() async {
    // might have to delete two
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
        // _closePanel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    deleteOvertime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // deleteOvertime();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deleting Overtime',
                style: kHeadingTwo,
              ),
              Visibility(
                visible: !isLoading,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: kPadding.copyWith(top: 10, bottom: 10),
                    primary: Colors.white,
                    textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    backgroundColor: kBlack.withOpacity(0.3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: _closePanel,
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Visibility(
              visible: !isLoading && !hasError,
              child: const StatusError(text: 'Error deleting record')),
          SizedBox(
            height: 250,
            child: Center(
              child: Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(color: kWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
