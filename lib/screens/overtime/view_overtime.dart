import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class Overtime {
  static get uid => 1;
  static get name => "Kim Song";
  static get date => DateTime.now();
  static get startedTime => TimeOfDay.now();
  static get endedTime => TimeOfDay.now();
  static get note => "finish the project";
}

class ViewOvertime extends StatefulWidget {
  const ViewOvertime({Key? key}) : super(key: key);

  @override
  _ViewOvertimeState createState() => _ViewOvertimeState();
}

class _ViewOvertimeState extends State<ViewOvertime> {
  void _closePanel() {
    Navigator.of(context).pop();
  }

  void _goToEdit() async {
//
  }
  void _deleteOvertime() async {
//
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      decoration: const BoxDecoration(
        color: kBlue,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 100,
              height: 6,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'View Overtime',
                      style: kHeadingTwo,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: kPadding.copyWith(top: 10, bottom: 10),
                        primary: Colors.white,
                        textStyle:
                            kParagraph.copyWith(fontWeight: FontWeight.w700),
                        backgroundColor: kBlack.withOpacity(0.3),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(kBorderRadius),
                        ),
                      ),
                      onPressed: _closePanel,
                      child: const Text('Close'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  height: 60,
                  width: _size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: kDarkestBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'ID',
                                style: kParagraph.copyWith(
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                '[emp id]',
                                style: kParagraph,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Name',
                                style: kParagraph.copyWith(
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(width: 5),
                              const SizedBox(
                                width: 200,
                                child: Text(
                                  '[emp name]dfasfdasfsdafdsaf asdfadsfhjasdkfhadsf',
                                  style: kParagraph,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      "Date",
                      style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(Overtime.date).toString(),
                      style: kParagraph,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "From",
                      style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${Overtime.startedTime.hour.toString().padLeft(2, '0')}:${Overtime.startedTime.minute.toString().padLeft(2, '0')}",
                      style: kParagraph,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "To",
                      style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${Overtime.endedTime.hour.toString().padLeft(2, '0')}:${Overtime.endedTime.minute.toString().padLeft(2, '0')}",
                      style: kParagraph,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Note',
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Text(Overtime.note, style: kParagraph),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: kPadding.copyWith(top: 10, bottom: 10),
                        primary: Colors.white,
                        textStyle:
                            kParagraph.copyWith(fontWeight: FontWeight.w700),
                        backgroundColor: kBlack.withOpacity(0.3),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(kBorderRadius),
                        ),
                      ),
                      onPressed: _goToEdit,
                      child: const Text('Edit'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: kPadding.copyWith(top: 10, bottom: 10),
                        primary: Colors.white,
                        textStyle:
                            kParagraph.copyWith(fontWeight: FontWeight.w700),
                        backgroundColor: kRedText,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(kBorderRadius),
                        ),
                      ),
                      onPressed: _closePanel,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
