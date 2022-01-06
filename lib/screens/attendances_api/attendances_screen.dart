import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/screens/attendances_api/attendance_info.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/screens/attendances_api/tap_screen.dart';
import 'package:ems/screens/attendances_api/tap_screen_alltime.dart';
import 'package:ems/screens/attendances_api/tap_screen_month.dart';
import 'package:ems/screens/attendances_api/test.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

class AttendancesScreen extends StatefulWidget {
  @override
  State<AttendancesScreen> createState() => _AttendancesScreenState();
}

class _AttendancesScreenState extends State<AttendancesScreen> {
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  UserService _userService = UserService.instance;
  List<User> userDisplay = [];
  List<User> user = [];
  bool _isLoading = true;
  bool order = false;
  var _controller = TextEditingController();

  void clearText() {
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();

    try {
      _userService.findMany().then((usersFromServer) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            userDisplay.addAll(usersFromServer);
            user = userDisplay;
            if (order) {
            } else {
              userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
            }
          });
        }
      });
    } catch (err) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Attendance'),
          actions: [
            PopupMenuButton(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: const Color(0xff43c3c52),
                onSelected: (item) => onSelected(context, item as int),
                icon: const Icon(Icons.filter_list),
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          '${local?.byDay}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 0,
                      ),
                      PopupMenuItem(
                        child: Text(
                          '${local?.byAllTime}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text(
                          '${local?.byMonth}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: 2,
                      ),
                    ])
          ],
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [
                  color1,
                  color,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: _isLoading
              ? Container(
                  padding: const EdgeInsets.only(top: 320),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${local?.fetchData}'),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(
                          color: kWhite,
                        ),
                      ],
                    ),
                  ),
                )
              : userDisplay.isEmpty
                  ? Column(
                      children: [
                        _searchBar(),
                        Container(
                          padding: const EdgeInsets.only(top: 150),
                          child: Column(
                            children: [
                              Text(
                                '${local?.employeeNotFound}',
                                style: kHeadingTwo.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Image.asset(
                                'assets/images/notfound.png',
                                width: 220,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _searchBar(),
                        Expanded(
                          child: ListView.builder(
                              // reverse: order,
                              itemCount: userDisplay.length,
                              itemBuilder: (context, index) {
                                return _listItem(index);
                              }),
                        ),
                      ],
                    ),
        ));
  }

  _searchBar() {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: _controller.text.isEmpty
                    ? const Icon(
                        Icons.search,
                        color: Colors.white,
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            clearText();
                            userDisplay = user.where((user) {
                              var userName = user.name!.toLowerCase();
                              return userName.contains(_controller.text);
                            }).toList();
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        )),
                hintText: '${local?.search}...',
                errorStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (text) {
                text = _controller.text.toLowerCase();
                setState(() {
                  // fetchData(text);
                  userDisplay = user.where((user) {
                    var userName = user.name!.toLowerCase();
                    return userName.contains(text);
                  }).toList();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _listItem(index) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      child: Container(
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: userDisplay[index].image == null
                    ? Image.asset('assets/images/profile-icon-png-910.png')
                    : Image.network(
                        userDisplay[index].image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 75,
                      ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 240,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: isEnglish ? 0 : 3),
                            child: Text(
                              '${local?.name}: ',
                              style: TextStyle(
                                fontSize: isEnglish ? 15 : 15,
                              ),
                            ),
                          ),
                          Text(
                            userDisplay[index].name.toString(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: isEnglish ? 0 : 3),
                            child: Text(
                              '${local?.id}: ',
                              style: TextStyle(
                                fontSize: isEnglish ? 15 : 15,
                              ),
                            ),
                          ),
                          Text(userDisplay[index].id.toString()),
                        ],
                      )
                    ],
                  ),
                  PopupMenuButton(
                    color: kDarkestBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onSelected: (int selectedValue) {
                      if (selectedValue == 0) {
                        int id = userDisplay[index].id as int;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => AttendancesInfoScreen(id)));
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text('${local?.info}'),
                        value: 0,
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AttendanceByDayScreen(),
        ),
      );
      break;
    case 1:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AttendanceAllTimeScreen(),
        ),
      );
      break;
    case 2:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AttendancesByMonthScreen(),
        ),
      );
      break;
  }
}
