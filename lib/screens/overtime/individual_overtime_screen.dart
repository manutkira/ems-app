import 'package:ems/constants.dart';
import 'package:ems/models/menu_options.dart';
import 'package:ems/screens/overtime/add_overtime.dart';
import 'package:ems/screens/overtime/delete_overtime.dart';
import 'package:ems/screens/overtime/edit_overtime.dart';
import 'package:ems/screens/overtime/view_overtime.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IndividualOvertimeScreen extends StatefulWidget {
  const IndividualOvertimeScreen({Key? key}) : super(key: key);

  @override
  State<IndividualOvertimeScreen> createState() =>
      _IndividualOvertimeScreenState();
}

class _IndividualOvertimeScreenState extends State<IndividualOvertimeScreen> {
  String dropdownValue = 'Day';
  var dropdownItems = [
    'Day',
    'Week',
    'Month',
    'Year',
    'All Time',
  ];

  List<int> listOfOvertime = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  // List<int> listOfOvertime = [];

  DateTime selectedDate = DateTime.now();

  var options = [
    MenuOptions.view,
    MenuOptions.edit,
    MenuOptions.delete,
  ];

  void addUser() async {
    await modalBottomSheetBuilder(
      context: context,
      maxHeight: 600,
      minHeight: 500,
      isDismissible: false,
      child: const AddOvertime(),
    );
    print("add add add");
  }

  void moreMenu(String value) async {
    switch (value) {
      case "View":
        {
          await modalBottomSheetBuilder(
            context: context,
            minHeight: 430,
            maxHeight: 430,
            child: const ViewOvertime(),
          );
          print("view view view");
        }
        break;
      case "Edit":
        {
          await modalBottomSheetBuilder(
            context: context,
            maxHeight: 620,
            minHeight: 520,
            isDismissible: false,
            child: const EditOvertime(),
          );
          print("edit edit edit");
        }
        break;
      case "Delete":
        {
          await modalBottomSheetBuilder(
            context: context,
            isDismissible: false,
            child: const DeleteOvertime(),
          );
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
          "Detailed Overtime",
        ),
        actions: [
          IconButton(
            onPressed: addUser,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text('Sort by', style: kParagraph),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kDarkestBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          borderRadius: const BorderRadius.all(kBorderRadius),
                          dropdownColor: kDarkestBlue,
                          underline: Container(),
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
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
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle: kParagraph,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
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
              Container(
                padding: kPaddingAll,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: kDarkestBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Name',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '[emp id]',
                                  style: kParagraph,
                                ),
                                Text(
                                  '[emp name]',
                                  style: kParagraph,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Text('6h30mn'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: listOfOvertime.isEmpty
                    ? _noRecord
                    : ListView.builder(
                        itemCount: listOfOvertime.length,
                        itemBuilder: (context, i) {
                          return _buildListItem(i);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _noRecord {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "🤷🏽‍",
            style: kHeadingOne.copyWith(fontSize: 100),
          ),
          const Text('No Record Found.', style: kParagraph),
        ],
      ),
    );
  }

  Widget _buildListItem(int i) {
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
            children: [
              const SizedBox(width: 20),
              Text(
                DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
                style: kSubtitle,
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
                  style: kSubtitle.copyWith(color: kGreenText),
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                elevation: 200,
                color: kDarkestBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                icon: const Icon(MdiIcons.dotsVertical),
                itemBuilder: (BuildContext context) => options.map((e) {
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
  }
}
