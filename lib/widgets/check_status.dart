import 'package:ems/models/attendance.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constants.dart';

class CheckStatus extends ConsumerStatefulWidget {
  const CheckStatus({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CheckStatusState();
}

class _CheckStatusState extends ConsumerState<CheckStatus> {
  bool isFetchingStatus = false;
  bool isMorningCheckIn = false;
  bool isMorningCheckOut = false;
  bool isAfternoonCheckIn = false;
  bool isAfternoonCheckOut = false;

  void getStatus() async {
    setState(() {
      isFetchingStatus = true;
    });
    AttendanceService attservice = AttendanceService.instance;
    int userId = ref.read(currentUserProvider).user.id as int;
    List<AttendanceWithDate> listofAttendance = [];
    listofAttendance = await attservice.findManyByUserId(
        userId: userId, start: DateTime.now(), end: DateTime.now());
    if (listofAttendance.isNotEmpty) {
      listofAttendance[0].list.map((e) {
        switch (e.code) {
          case 'cin1':
            {
              return setState(() {
                isMorningCheckIn = true;
              });
            }
          case 'cout1':
            {
              return setState(() {
                isMorningCheckOut = true;
              });
            }
          case 'cin2':
            {
              return setState(() {
                isAfternoonCheckIn = true;
              });
            }
          case 'cout2':
            {
              return setState(() {
                isAfternoonCheckIn = true;
              });
            }
        }
      }).toList();
    }
    setState(() {
      isFetchingStatus = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 100,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: const [
                    Expanded(
                        child: Text(
                      '',
                      style: TextStyle(
                        color: kBlack,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      'Check In',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kBlack,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      'Check Out',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kBlack,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Morning',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kBlack,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      isFetchingStatus
                          ? 'loading...'
                          : isMorningCheckIn
                              ? '✔'
                              : '--',
                      style: const TextStyle(
                        color: kBlack,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      isFetchingStatus
                          ? 'loading...'
                          : isMorningCheckOut
                              ? '✔'
                              : '--',
                      style: const TextStyle(
                        color: kBlack,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Afternoon',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kBlack,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      isFetchingStatus
                          ? 'loading...'
                          : isAfternoonCheckIn
                              ? '✔'
                              : '--',
                      style: const TextStyle(
                        color: kBlack,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      isFetchingStatus
                          ? 'loading...'
                          : isAfternoonCheckOut
                              ? '✔'
                              : '--',
                      style: const TextStyle(
                        color: kBlack,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: isFetchingStatus,
            child: const Positioned(
              bottom: 11,
              right: 11,
              child: SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  color: kBlue,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isFetchingStatus,
            child: Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: getStatus,
                child: const Icon(
                  MdiIcons.refresh,
                  color: kBlue,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}