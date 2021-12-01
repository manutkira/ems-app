import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class AddOvertime extends StatefulWidget {
  const AddOvertime({Key? key}) : super(key: key);

  @override
  _AddOvertimeState createState() => _AddOvertimeState();
}

class _AddOvertimeState extends State<AddOvertime> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay startedTime = TimeOfDay.now();
  TimeOfDay endedTime = TimeOfDay.now();
  final TextEditingController _noteController = TextEditingController();
  bool isLoading = false;
  String _error = "";

  void _closePanel() {
    if (!isLoading) {
      Navigator.of(context).pop();
    }
  }

  void _addOvertime() async {
    print(
        "${_noteController.text} ${selectedDate} ${startedTime} ${endedTime}");

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
        _closePanel();
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Overtime',
                    style: kHeadingTwo,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Please enter all information below.',
                    style: kSubtitle.copyWith(
                      color: kSubtitle.color?.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isLoading,
                child: CircularProgressIndicator(color: kWhite),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            height: 60,
            width: _size.width,
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
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
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Date",
                style: kParagraph,
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: kParagraph,
                  backgroundColor: kDarkestBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(kBorderRadius),
                  ),
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                    locale: const Locale('km'),
                    helpText: "Pick a date",
                    errorFormatText: 'Enter valid date',
                    errorInvalidText: 'Enter date in valid range',
                    fieldLabelText: 'Date',
                    fieldHintText: 'Date/Month/Year',
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    const SizedBox(width: 10),
                    const Icon(MdiIcons.calendar),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "From",
                style: kParagraph,
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: kParagraph,
                  backgroundColor: kDarkestBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(kBorderRadius),
                  ),
                ),
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: startedTime,
                    // hourLabelText: "mong",
                  );

                  if (picked != null && picked != startedTime) {
                    setState(() {
                      startedTime = picked;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${startedTime.hour.toString().padLeft(2, '0')}:${startedTime.minute.toString().padLeft(2, '0')}"),
                    const SizedBox(width: 10),
                    const Icon(MdiIcons.clockOutline),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                "To",
                style: kParagraph,
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: kParagraph,
                  backgroundColor: kDarkestBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(kBorderRadius),
                  ),
                ),
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: endedTime,
                    // hourLabelText: "mong",
                  );

                  if (picked != null && picked != endedTime) {
                    setState(() {
                      endedTime = picked;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${endedTime.hour.toString().padLeft(2, '0')}:${endedTime.minute.toString().padLeft(2, '0')}"),
                    const SizedBox(width: 10),
                    const Icon(MdiIcons.clockOutline),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Note', style: kParagraph),
          const SizedBox(height: 10),
          TextField(
            minLines: 5,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            controller: _noteController,
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: _error.isNotEmpty,
            child: Column(
              children: const [
                StatusError(text: "Error"),
                SizedBox(height: 20),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: kPadding.copyWith(top: 10, bottom: 10),
                  primary: Colors.white,
                  textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  backgroundColor: kBlack.withOpacity(0.3),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(kBorderRadius),
                  ),
                ),
                onPressed: _addOvertime,
                child: const Text('Confirm'),
              ),
              const SizedBox(width: 10),
              TextButton(
                style: TextButton.styleFrom(
                  padding: kPadding.copyWith(top: 10, bottom: 10),
                  primary: Colors.white,
                  textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
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
    );
  }
}
