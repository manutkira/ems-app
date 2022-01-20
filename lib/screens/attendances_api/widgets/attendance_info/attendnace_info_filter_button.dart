import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:ems/utils/utils.dart';

import '../../../../constants.dart';

class AttendanceInfoFilterButton extends StatefulWidget {
  final Function toggleFilter;
  final bool isFilterExpanded;
  var dropdownItems;
  String sortByValue;
  bool multipleDay;
  bool now;
  DateTime startDate;
  DateTime endDate;
  Function function;

  AttendanceInfoFilterButton({
    Key? key,
    required this.toggleFilter,
    required this.isFilterExpanded,
    required this.dropdownItems,
    required this.sortByValue,
    required this.multipleDay,
    required this.now,
    required this.startDate,
    required this.endDate,
    required this.function,
  }) : super(key: key);
  @override
  State<AttendanceInfoFilterButton> createState() =>
      _AttendanceInfoFilterButtonState();
}

class _AttendanceInfoFilterButtonState
    extends State<AttendanceInfoFilterButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.toggleFilter(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: kParagraph.copyWith(
                  fontSize: 20,
                ),
              ),
              Icon(
                widget.isFilterExpanded
                    ? MdiIcons.chevronUp
                    : MdiIcons.chevronDown,
                size: 22,
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.isFilterExpanded,
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// SORT FILTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      isDense: true,
                      value: widget.sortByValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: widget.dropdownItems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (widget.sortByValue == newValue) return;
                        setState(() {
                          widget.sortByValue = newValue as String;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              /// FROM FILTER
              Visibility(
                visible: widget.sortByValue != 'All Time',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.sortByValue == 'Day' ? "Date" : 'From',
                      style: kParagraph,
                    ),
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
                        final DateTime? picked = await buildDateTimePicker(
                          context: context,
                          date: widget.startDate,
                        );
                        if (picked != null && picked != widget.startDate) {
                          setState(() {
                            widget.startDate = picked;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getDateStringFromDateTime(widget.startDate),
                          ),
                          const SizedBox(width: 10),
                          const Icon(MdiIcons.calendar),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// TO FILTER
              Visibility(
                visible: widget.sortByValue == 'Multiple Days',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('To', style: kParagraph),
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
                        final DateTime? picked = await buildDateTimePicker(
                          context: context,
                          date: widget.endDate,
                        );
                        if (picked != null && picked != widget.endDate) {
                          setState(() {
                            widget.endDate = picked;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getDateStringFromDateTime(widget.endDate),
                          ),
                          const SizedBox(width: 10),
                          const Icon(MdiIcons.calendar),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// GO BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      primary: Colors.white,
                      textStyle: kParagraph,
                      backgroundColor: Colors.black38,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(kBorderRadius),
                      ),
                    ),
                    onPressed: () {
                      if (widget.sortByValue == 'Multiple Days') {
                        setState(() {
                          widget.multipleDay = true;
                          widget.now = false;
                        });
                        widget.function();
                      }
                      if (widget.sortByValue == 'All Time') {
                        setState(() {
                          widget.multipleDay = false;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          'Go',
                          style: kParagraph.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const Icon(MdiIcons.chevronRight)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
