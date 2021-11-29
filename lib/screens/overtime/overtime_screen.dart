import 'package:ems/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../home_screen.dart';

class MenuOptions {
  String value;
  String label;
  MenuOptions({required this.value, required this.label});

  static get view => "View";
  static get edit => "Edit";
  static get delete => "Delete";
}

class OvertimeScreen extends StatefulWidget {
  OvertimeScreen({Key? key}) : super(key: key);

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  String dropdownValue = 'Day';
  var dropdownItems = [
    'Day',
    'Week',
    'Month',
    'Year',
    'All Time',
  ];

  DateTime selectedDate = DateTime.now();

  var options = [
    MenuOptions.view,
    MenuOptions.edit,
    MenuOptions.delete,
  ];

  void moreMenu(String value) {
    switch (value) {
      case "View":
        {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
          print("view view view");
        }
        break;
      case "Edit":
        {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         const HomeScreen(),
          //   ),
          // );
          print("edit edit edit");
        }
        break;
      case "Delete":
        {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         const HomeScreen(),
          //   ),
          // );
          print("delete delete delete");
        }
        break;
      default:
        {
          return;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Overtime",
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Sort by'),
                      const SizedBox(width: 5),
                      DropdownButton(
                        borderRadius: const BorderRadius.all(kBorderRadius),
                        dropdownColor: kDarkestBlue,
                        underline: Container(),
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                        isDense: true,
                        value: dropdownValue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: dropdownItems.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (dropdownValue == newValue) return;
                          setState(() {
                            dropdownValue = newValue as String;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 50,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      color: i % 2 == 0 ? kDarkestBlue : kBlue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              CircleAvatar(),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Employee Name',
                                style: kParagraph,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: kGreenBackground,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  '1h',
                                  style: kParagraph.copyWith(color: kGreenText),
                                ),
                              ),
                              const SizedBox(width: 10),
                              PopupMenuButton<String>(
                                color: kDarkestBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: const Icon(MdiIcons.dotsVertical),
                                itemBuilder: (BuildContext context) =>
                                    options.map((e) {
                                  return PopupMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                                onSelected: moreMenu,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
