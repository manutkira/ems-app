import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';

class EmployeeConfirmScreen extends StatefulWidget {
  const EmployeeConfirmScreen(
      {Key? key, required this.name, required this.profile, required this.ok})
      : super(key: key);
  final String name;
  final String profile;
  final Function(String note) ok;

  @override
  State<EmployeeConfirmScreen> createState() => _EmployeeConfirmScreenState();
}

class _EmployeeConfirmScreenState extends State<EmployeeConfirmScreen> {
  List<String> reasons = [];
  bool isLate = false;

  String? selectedReason;
  String note = '';

  void _ok() {
    widget.ok(note);
    goBack(context);
  }

  void checkIfLate() {
    DateTime now = DateTime.now();
    bool isCheckInLateMorning = now.isAfter(
          DateTime(
            now.year,
            now.month,
            now.day,
            7,
            15,
          ),
        ) &&
        now.hour < 12;
    bool isCheckInLateAfternoon = now.isAfter(
      DateTime(
        now.year,
        now.month,
        now.day,
        13,
        15,
      ),
    );

    if (isCheckInLateMorning || isCheckInLateAfternoon) {
      setState(() {
        isLate = true;
      });
    }
  }

  void addReasons() {
    AppLocalizations? local = AppLocalizations.of(context);
    setState(() {
      reasons.addAll([
        "${local?.lateBlownTire}",
        "${local?.lateTrafficJam}",
        "${local?.lateOther}",
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
    // if (widget.type == AttendanceType.typeCheckIn) {
    checkIfLate();
    // }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    if (reasons.isEmpty) {
      addReasons();
    }
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              CustomCircleAvatar(
                imageUrl: widget.profile,
                size: 120,
              ),
              const SizedBox(height: 16),
              Text(
                widget.name,
                style: kParagraph.copyWith(color: kWhite, fontSize: 20),
              ),
              const SizedBox(height: 32),
              Visibility(
                visible: isLate,
                child: Column(
                  children: [
                    Text('${local?.lateChooseReason}'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        ...reasons.map(
                          (reason) {
                            bool isSelected = selectedReason == reason;
                            return ChoiceChip(
                              backgroundColor:
                                  isSelected ? kDarkestBlue : Colors.blueGrey,
                              selectedColor: kDarkestBlue,
                              labelStyle: const TextStyle(color: kWhite),
                              label: Text(reason),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedReason = null;
                                  } else {
                                    selectedReason = reason;
                                  }
                                  note = selectedReason.toString();
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: selectedReason == reasons.last,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Other reason:'),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextBoxCustom(
                              getValue: (String str) {
                                setState(() {
                                  note = str;
                                });
                              },
                              textHint: '',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Material(
                        color: kRedText,
                        child: IconButton(
                          splashRadius: 100,
                          onPressed: () => goBack(context),
                          color: kWhite,
                          splashColor: kWhite.withOpacity(0.5),
                          icon: const Icon(
                            Icons.close,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Material(
                        color: kDarkestBlue,
                        child: IconButton(
                          splashRadius: 100,
                          onPressed: _ok,
                          color: kWhite,
                          splashColor: kWhite.withOpacity(0.5),
                          icon: const Icon(
                            Icons.arrow_upward,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
