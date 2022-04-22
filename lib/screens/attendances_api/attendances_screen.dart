import 'package:ems/models/user.dart';
import 'package:ems/screens/attendances_api/attendance_all_time.dart';
import 'package:ems/screens/attendances_api/attendance_by_day_screen.dart';
import 'package:ems/screens/attendances_api/attendance_by_week_screen.dart';
import 'package:ems/screens/attendances_api/attendance_info.dart';
import 'package:ems/screens/attendances_api/attendances_bymonth.dart';
import 'package:ems/screens/attendances_api/create_attendance_screen.dart';
import 'package:ems/services/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

// ignore: use_key_in_widget_constructors
class AttendancesScreen extends StatefulWidget {
  @override
  State<AttendancesScreen> createState() => _AttendancesScreenState();
}

class _AttendancesScreenState extends State<AttendancesScreen> {
  // services
  final UserService _userService = UserService.instance;

  // list user
  List<User> userDisplay = [];
  List<User> user = [];

  // boolean
  bool _isLoading = true;
  bool order = false;

  // variables
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  final TextEditingController _controller = TextEditingController();

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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('${local?.attendance}'),
          actions: [_popupmenu(context, local)],
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
              ? _fetchingData(local)
              : userDisplay.isEmpty
                  ? _notFound(local)
                  : _employeeList(),
        ));
  }

// employee list
  Column _employeeList() {
    return Column(
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
    );
  }

// show not found msg when search wrong name
  Column _notFound(AppLocalizations? local) {
    return Column(
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
    );
  }

// fetching and loading name
  Container _fetchingData(AppLocalizations? local) {
    return Container(
      padding: const EdgeInsets.only(top: 320),
      alignment: Alignment.center,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${local?.fetchData}'),
            const SizedBox(
              height: 10,
            ),
            const CircularProgressIndicator(
              color: kWhite,
            ),
          ],
        ),
      ),
    );
  }

// popupmenu to navigate to other screen
  PopupMenuButton<int> _popupmenu(
      BuildContext context, AppLocalizations? local) {
    return PopupMenuButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        color: kBlack,
        onSelected: (item) => onSelected(context, item as int),
        icon: const Icon(Icons.filter_list),
        itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  '${local?.byDay}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 0,
              ),
              PopupMenuItem(
                child: Text(
                  'ប្រចាំសប្ដាហ៍',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 3,
              ),
              PopupMenuItem(
                child: Text(
                  '${local?.byMonth}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 2,
              ),
              PopupMenuItem(
                child: Text(
                  '${local?.byAllTime}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: 1,
              ),
            ]);
  }

// search bar for searching employee name
  _searchBar() {
    AppLocalizations? local = AppLocalizations.of(context);
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

// employee list
  _listItem(index) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      child: SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AttendancesInfoScreen(
                          id: userDisplay[index].id!,
                        )));
          },
          child: Row(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
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
              SizedBox(
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
                              builder: (_) => AttendancesInfoScreen(
                                    id: id,
                                  )));
                        }
                        if (selectedValue == 1) {
                          int id = userDisplay[index].id as int;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => CreateAttendance(
                                    id: id,
                                  )));
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Text('${local?.info}'),
                          value: 0,
                        ),
                        PopupMenuItem(
                          child: Text('${local?.createAttendance}'),
                          value: 1,
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
      ),
    );
  }
}

// onSelected popupmenu
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
    case 3:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AttendanceByWeekScreen(),
        ),
      );
      break;
  }
}
