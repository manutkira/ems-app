// import 'package:ems/screens/attendances_api/attendance_all_time.dart';
// import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
// import 'package:ems/screens/attendances_api/tap_screen_alltime.dart';
// import 'package:ems/screens/attendances_api/tap_screen_month.dart';
// import 'package:ems/utils/services/user_service.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../constants.dart';
// import '../../models/attendance.dart';
// import '../../utils/services/attendance_service.dart';

// class AttendanceByDayAfternoonScreen extends StatefulWidget {
//   @override
//   _AttendanceByDayScreenState createState() => _AttendanceByDayScreenState();
// }

// class _AttendanceByDayScreenState
//     extends State<AttendanceByDayAfternoonScreen> {
//   AttendanceService _attendanceService = AttendanceService.instance;
//   UserService _userService = UserService.instance;

//   List userDisplay = [];
//   List<Attendance> attendanceDisplay = [];
//   bool _isLoading = true;
//   final color = const Color(0xff05445E);
//   final color1 = const Color(0xff3982A0);
//   DateTime testdate = DateTime(10, 11, 2021);
//   bool noData = true;
//   List<Attendance> checkedDate = [];
//   List<Attendance> users = [];

//   var _controller = TextEditingController();

//   void clearText() {
//     _controller.clear();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _attendanceService.findMany().then((value) {
//       setState(() {
//         attendanceDisplay.addAll(value);
//         attendanceDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
//       });
//     });
//     _userService.findMany().then((value) {
//       userDisplay.addAll(value);
//     });
//   }

//   void checkDate(DateTime pick) {
//     var checkingDate = attendanceDisplay.where((element) =>
//         element.date!.day == pick.day &&
//         element.date!.month == pick.month &&
//         element.date!.year == pick.year &&
//         element.type != 'checkout' &&
//         element.code == 'cin2');
//     setState(() {
//       users = checkingDate.toList();
//       checkedDate = users;
//       checkedDate.sort((a, b) => a.userId!.compareTo(b.userId as int));
//     });
//   }

//   DateTime? _selectDate;

//   void _byDayDatePicker() {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1990),
//       lastDate: DateTime.now(),
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//     ).then((picked) {
//       if (picked == null) {
//         return;
//       }
//       checkDate(picked);
//       setState(() {
//         _selectDate = picked;

//         noData = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           title: Text('Attendance'),
//           actions: [
//             PopupMenuButton(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10))),
//                 color: Color(0xff43c3c52),
//                 onSelected: (item) => onSelected(context, item as int),
//                 icon: Icon(Icons.filter_list),
//                 itemBuilder: (_) => [
//                       PopupMenuItem(
//                         child: Text(
//                           'By Month',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         value: 0,
//                       ),
//                       PopupMenuItem(
//                         child: Text(
//                           'By All-Time',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         value: 1,
//                       ),
//                     ])
//           ],
//         ),
//         body: attendanceDisplay.isEmpty
//             ? Container(
//                 padding: EdgeInsets.only(top: 320),
//                 alignment: Alignment.center,
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text('Fetching Data'),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       const CircularProgressIndicator(
//                         color: kWhite,
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             : Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 15),
//                     child: Row(
//                       children: [
//                         Text(
//                           _selectDate == null
//                               ? 'Pick a Date'
//                               : 'Date: ${DateFormat.yMd().format(_selectDate as DateTime)}',
//                           style: kHeadingFour,
//                         ),
//                         FlatButton(
//                             onPressed: () {
//                               setState(() {
//                                 _byDayDatePicker();
//                               });
//                             },
//                             child: Text(
//                               'Choose Date',
//                               style: kParagraph,
//                             ))
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: noData
//                         ? Container(
//                             padding: EdgeInsets.only(top: 140),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   'Please pick a date!!',
//                                   style: kHeadingTwo.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 30,
//                                 ),
//                                 Image.asset(
//                                   'assets/images/calendar.jpeg',
//                                   width: 220,
//                                 ),
//                               ],
//                             ),
//                           )
//                         : Container(
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     color1,
//                                     color,
//                                   ],
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                 )),
//                             child: checkedDate.isEmpty
//                                 ? Column(
//                                     children: [
//                                       _searchBar(),
//                                       Container(
//                                         padding: EdgeInsets.only(top: 150),
//                                         child: Column(
//                                           children: [
//                                             Text(
//                                               'NO ATTENDANCE ADDED YET!!',
//                                               style: kHeadingThree.copyWith(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 30,
//                                             ),
//                                             Image.asset(
//                                               'assets/images/attendanceicon.png',
//                                               width: 220,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : Column(
//                                     children: [
//                                       _searchBar(),
//                                       Text('Morning'),
//                                       Expanded(
//                                         child: ListView.builder(
//                                           itemBuilder: (ctx, index) {
//                                             return _listItem(index);
//                                           },
//                                           itemCount: checkedDate.length,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                   ),
//                 ],
//               ));
//   }

//   _searchBar() {
//     return Padding(
//       padding: EdgeInsets.all(10),
//       child: Row(
//         children: [
//           Flexible(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 suffixIcon: _controller.text.isEmpty
//                     ? Icon(
//                         Icons.search,
//                         color: Colors.white,
//                       )
//                     : IconButton(
//                         onPressed: () {
//                           setState(() {
//                             clearText();
//                             checkedDate = users.where((user) {
//                               var userName = user.users!.name!.toLowerCase();
//                               print(userName);
//                               return userName.contains(_controller.text);
//                             }).toList();
//                           });
//                         },
//                         icon: Icon(
//                           Icons.clear,
//                           color: Colors.white,
//                         ),
//                       ),
//                 hintText: 'Search...',
//                 errorStyle: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               onChanged: (text) {
//                 text = text.toLowerCase();
//                 setState(() {
//                   checkedDate = users.where((user) {
//                     var userName = user.users!.name!.toLowerCase();
//                     return userName.contains(text);
//                   }).toList();
//                 });
//               },
//             ),
//           ),
//           PopupMenuButton(
//             color: kDarkestBlue,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             onSelected: (int selectedValue) {
//               if (selectedValue == 0) {
//                 setState(() {
//                   checkedDate.sort((a, b) => a.users!.name!
//                       .toLowerCase()
//                       .compareTo(b.users!.name!.toLowerCase()));
//                 });
//               }
//               if (selectedValue == 1) {
//                 setState(() {
//                   checkedDate.sort((b, a) => a.users!.name!
//                       .toLowerCase()
//                       .compareTo(b.users!.name!.toLowerCase()));
//                 });
//               }
//               if (selectedValue == 2) {
//                 setState(() {
//                   checkedDate
//                       .sort((a, b) => a.userId!.compareTo(b.userId as int));
//                 });
//               }
//             },
//             itemBuilder: (_) => [
//               PopupMenuItem(
//                 child: Text('From A-Z'),
//                 value: 0,
//               ),
//               PopupMenuItem(
//                 child: Text('From Z-A'),
//                 value: 1,
//               ),
//               PopupMenuItem(
//                 child: Text('by ID'),
//                 value: 2,
//               ),
//             ],
//             icon: Icon(Icons.sort),
//           ),
//         ],
//       ),
//     );
//   }

//   _listItem(index) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.only(bottom: 10),
//       margin: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.black, width: 2),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 75,
//                 height: 75,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(100)),
//                     border: Border.all(
//                       width: 1,
//                       color: Colors.white,
//                     )),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(150),
//                   child: checkedDate[index].users!.image == null
//                       ? Image.asset('assets/images/profile-icon-png-910.png')
//                       : Image.network(
//                           checkedDate[index].users!.image.toString(),
//                           fit: BoxFit.cover,
//                           height: 75,
//                         ),
//                 ),
//               ),
//               SizedBox(
//                 width: 20,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text('Name: '),
//                       Text(checkedDate[index].users!.name.toString()),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text('ID: '),
//                       Text(checkedDate[index].userId.toString()),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 60),
//             child: Container(
//               padding: EdgeInsets.all(3),
//               width: 80,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                   color: checkedDate[index].type == 'checkin' &&
//                           checkedDate[index].date!.hour < 8 &&
//                           checkedDate[index].date!.minute < 21
//                       ? Color(0xff9CE29B)
//                       : checkedDate[index].type == 'checkin' &&
//                               checkedDate[index].date!.hour > 7
//                           ? Color(0xffF3FDB6)
//                           : checkedDate[index].type == 'absent'
//                               ? Color(0xffFFCBCE)
//                               : Color(0xff77B1C9),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Text(
//                 checkedDate[index].type == 'checkin' &&
//                         checkedDate[index].date!.hour < 8 &&
//                         checkedDate[index].date!.minute < 21
//                     ? 'Present'
//                     : checkedDate[index].type == 'checkin' &&
//                             checkedDate[index].date!.hour > 7
//                         // checkedDate[index].date!.minute > 20
//                         ? 'Late'
//                         : checkedDate[index].type == 'absent'
//                             ? 'Absent'
//                             : checkedDate[index].type == 'permission'
//                                 ? 'Permission'
//                                 : '',
//                 style: TextStyle(
//                   color: checkedDate[index].type == 'checkin' &&
//                           checkedDate[index].date!.hour < 9
//                       ? Color(0xff334732)
//                       : checkedDate[index].type == 'checkin' &&
//                               checkedDate[index].date!.hour > 8
//                           ? Color(0xff5A5E45)
//                           : checkedDate[index].type == 'absent'
//                               ? Color(0xffA03E3E)
//                               : Color(0xff313B3F),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void onSelected(BuildContext context, int item) {
//     switch (item) {
//       case 0:
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => TapScreenMonth(),
//           ),
//         );
//         break;
//       case 1:
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => TapScreenAlltime(),
//           ),
//         );
//         break;
//     }
//   }
// }
