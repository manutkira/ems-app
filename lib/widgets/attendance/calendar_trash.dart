// Color checkColor(AttendanceById attendance) {
//   if (attendance.checkin1!.type == 'absent') {
//     return Colors.red;
//   }
//   if (attendance.checkin1!.type == 'permission') {
//     return Colors.blue;
//   }
//   if (attendance.checkin1!.type == 'checkout') {
//     return Colors.lightGreen;
//   }
//   if (attendance.checkin1!.date!.hour >= 7 &&
//       attendance.checkin1!.date!.minute >= 16 &&
//       attendance.checkin1!.code == 'cin1' &&
//       attendance.checkin1!.type == 'checkin') {
//     return Colors.yellow;
//   }
//   if (attendance.checkin1!.date!.hour >= 13 &&
//       attendance.checkin1!.date!.minute >= 16 &&
//       attendance.checkin1!.code == 'cin2' &&
//       attendance.checkin1!.type == 'checkin') {
//     return Colors.yellow;
//   }
//   if (attendance.checkin1!.date!.hour == 7 &&
//       attendance.checkin1!.date!.minute <= 15 &&
//       attendance.checkin1!.code == 'cin1' &&
//       attendance.checkin1!.type == 'checkin') {
//     return Colors.green;
//   }
//   if (attendance.checkin1!.code == 'cin3') {
//     return Color(0xffd4d2bc);
//   }
//   if (attendance.checkin1!.date!.hour == 13 &&
//       attendance.checkin1!.date!.minute <= 15 &&
//       attendance.checkin1!.code == 'cin2' &&
//       attendance.checkin1!.type == 'checkin') {
//     return Colors.green;
//   } else {
//     return Colors.red;
//   }
// }

//   // List<Appointment> getAppointments() {
//   //   List<Appointment> meetings = <Appointment>[];
//   //   DateTime? startTime;
//   //   DateTime? endTime;
//   //   _attendanceDisplay.asMap().forEach((key, value) {
//   //     Appointment newAppointment = Appointment(
//   //       startTime: value.checkin1?.date as DateTime,
//   //       endTime: value.checkout1?.date as DateTime,
//   //       color: checkColor(value),
//   //     );
//   //     meetings.add(newAppointment);
//   //   });
//   //   return meetings;
//   // }

//  Container(
//                             margin: const EdgeInsets.all(20),
//                             padding:
//                                 const EdgeInsets.only(top: 40, right: 10),
//                             child: SfCalendar(
//                               view: CalendarView.month,
//                               dataSource:
//                                   MeetingDataSource(getAppointments()),
//                               todayHighlightColor: Colors.grey,
//                               headerHeight: 25,
//                               scheduleViewSettings:
//                                   const ScheduleViewSettings(
//                                       appointmentTextStyle:
//                                           TextStyle(color: Colors.black)),
//                               cellBorderColor: Colors.grey,
//                               allowedViews: const [
//                                 CalendarView.month,
//                                 CalendarView.schedule,
//                               ],
//                             ),
//                           ),