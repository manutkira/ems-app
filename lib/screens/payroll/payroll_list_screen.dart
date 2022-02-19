import 'package:ems/models/attendances.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/screens/payroll/payroll_screen.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

class PayrollListScreen extends StatefulWidget {
  const PayrollListScreen({Key? key}) : super(key: key);

  @override
  _PayrollListScreenState createState() => _PayrollListScreenState();
}

class _PayrollListScreenState extends State<PayrollListScreen> {
  // servicers
  final UserService _userService = UserService.instance;
  final AttendanceService _attendanceService = AttendanceService.instance;

  // list users
  List<User> userList = [];
  List<User> user = [];

  // list attendances
  List<AttendancesWithDate> attendancesList = [];

  // text controller
  final TextEditingController _controller = TextEditingController();

  // boolean
  bool _isLoading = true;

  // color
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

  // fetch user from api
  fetchUser() async {
    try {
      _isLoading = true;
      List<User> userDisplay = await _userService.findMany();
      setState(() {
        userList = userDisplay;
        user = userList;
        _isLoading = false;
      });
    } catch (err) {}
  }

  // clear
  void clearText() {
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payroll'),
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
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(
                        color: kWhite,
                      ),
                    ],
                  ),
                ),
              )
            : userList.isEmpty
                ? Column(
                    children: [
                      _searchBar(),
                      Container(
                        padding: const EdgeInsets.only(top: 150),
                        child: Column(
                          children: [
                            Text(
                              'Employee not found!!',
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
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              return _listItem(index);
                            }),
                      ),
                    ],
                  ),
      ),
    );
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
                            userList = user.where((user) {
                              var userName = user.name!.toLowerCase();
                              return userName.contains(_controller.text);
                            }).toList();
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                hintText: '${local?.search}...',
                hintStyle: TextStyle(
                  fontSize: isEnglish ? 15 : 13,
                ),
                errorStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  userList = user.where((user) {
                    var userName = user.name!.toLowerCase();
                    return userName.contains(text);
                  }).toList();
                });
              },
            ),
          ),
          PopupMenuButton(
            color: kDarkestBlue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (int selectedValue) {
              if (selectedValue == 0) {
                setState(() {
                  userList.sort((a, b) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 1) {
                setState(() {
                  userList.sort((b, a) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 2) {
                setState(() {
                  userList.sort((a, b) => a.id!.compareTo(b.id as int));
                });
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  '${local?.fromAtoZ}',
                  style: TextStyle(
                    fontSize: isEnglish ? 15 : 16,
                  ),
                ),
                value: 0,
              ),
              PopupMenuItem(
                child: Text(
                  '${local?.fromZtoA}',
                  style: TextStyle(fontSize: isEnglish ? 15 : 16),
                ),
                value: 1,
              ),
              PopupMenuItem(
                child: Text(
                  '${local?.byId}',
                  style: TextStyle(fontSize: isEnglish ? 15 : 16),
                ),
                value: 2,
              ),
            ],
            icon: const Icon(Icons.filter_list),
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
      padding: const EdgeInsets.only(bottom: 20),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            EmployeeInfoScreen(id: userList[index].id as int)));
                userList = [];
                user = [];
                fetchUser();
              },
              child: Container(
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
                  child: userList[index].image == null
                      ? Image.asset('assets/images/profile-icon-png-910.png')
                      : Image.network(
                          userList[index].image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 75,
                        ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 245,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EmployeeInfoScreen(
                                  id: userList[index].id as int)));
                      userList = [];
                      user = [];
                      fetchUser();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaselineRow(
                          children: [
                            Text(
                              '${local?.name}: ',
                              style: TextStyle(
                                fontSize: isEnglish ? 15 : 15,
                              ),
                            ),
                            SizedBox(
                              width: isEnglish ? 2 : 4,
                            ),
                            SizedBox(
                              width: 140,
                              child: Text(
                                userList[index].name.toString(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: isEnglish ? 10 : 0,
                        ),
                        BaselineRow(
                          children: [
                            Text('${local?.id}: ',
                                style: TextStyle(
                                  fontSize: isEnglish ? 15 : 15,
                                )),
                            const SizedBox(
                              width: 1,
                            ),
                            Text(userList[index].id.toString()),
                          ],
                        )
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    color: kDarkestBlue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onSelected: (int selectedValue) async {
                      if (selectedValue == 0) {
                        int id = userList[index].id as int;
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PayrollScreen(id: id),
                        ));
                        userList = [];
                        user = [];
                        fetchUser();
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          'Generate Payroll',
                          style: TextStyle(
                            fontSize: isEnglish ? 15 : 16,
                          ),
                        ),
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
