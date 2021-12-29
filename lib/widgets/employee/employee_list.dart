import 'dart:async';
import 'dart:ui';

import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/employee/employee_edit_screen.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeList extends StatefulWidget {
  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);
  final UserService _userService = UserService.instance;
  List<User> userDisplay = [];
  List<User> user = [];

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode == 200) {
      userDisplay = [];
      user = [];
      _userService.findMany().then((usersFromServer) {
        setState(() {
          _isLoading = false;
          user.addAll(usersFromServer);
          userDisplay = user;

          userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
        });
      });
    } else {
      return false;
    }
  }

  bool _isLoading = true;
  bool order = false;

  var _controller = TextEditingController();

  void clearText() {
    _controller.clear();
  }

  @override
  void initState() {
    try {
      _userService.findMany().then((usersFromServer) {
        setState(() {
          _isLoading = false;
          user.addAll(usersFromServer);
          userDisplay = user;

          userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
        });
      });
      super.initState();
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
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
              padding: EdgeInsets.only(top: 320),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${local?.fetchData}'),
                    SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(
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
                      padding: EdgeInsets.only(top: 150),
                      child: Column(
                        children: [
                          Text(
                            'Employee not found!!',
                            style: kHeadingTwo.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
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
                          itemCount: userDisplay.length,
                          itemBuilder: (context, index) {
                            return _listItem(index);
                          }),
                    ),
                  ],
                ),
    );
  }

  _searchBar() {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: _controller.text.isEmpty
                    ? Icon(
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
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                hintText: '${local?.search}...',
                hintStyle: TextStyle(
                  fontSize: isEnglish ? 15 : 13,
                ),
                errorStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  userDisplay = user.where((user) {
                    var userName = user.name!.toLowerCase();
                    return userName.contains(text);
                  }).toList();
                });
              },
            ),
          ),
          PopupMenuButton(
            color: kDarkestBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (int selectedValue) {
              if (selectedValue == 0) {
                setState(() {
                  userDisplay.sort((a, b) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 1) {
                setState(() {
                  userDisplay.sort((b, a) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 2) {
                setState(() {
                  userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
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
            icon: Icon(Icons.filter_list),
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
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
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
            SizedBox(
              width: 10,
            ),
            Container(
              width: 245,
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
                            child: Text('${local?.id}: ',
                                style: TextStyle(
                                  fontSize: isEnglish ? 15 : 15,
                                )),
                          ),
                          Text(userDisplay[index].id.toString()),
                        ],
                      )
                    ],
                  ),
                  PopupMenuButton(
                    color: kDarkestBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onSelected: (int selectedValue) {
                      if (selectedValue == 1) {
                        int id = userDisplay[index].id as int;
                        String name = userDisplay[index].name.toString();
                        String phone = userDisplay[index].phone.toString();
                        String email = userDisplay[index].email.toString();
                        String address = userDisplay[index].address.toString();
                        String position =
                            userDisplay[index].position.toString();
                        String skill = userDisplay[index].skill.toString();
                        String salary = userDisplay[index].salary.toString();
                        String role = userDisplay[index].role.toString();
                        String status = userDisplay[index].status.toString();
                        String rate = userDisplay[index].rate.toString();
                        String background =
                            userDisplay[index].background.toString();
                        String image = userDisplay[index].image.toString();
                        String imageId = userDisplay[index].imageId.toString();
                        print(imageId);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => EmployeeEditScreen(
                                id,
                                name,
                                phone,
                                email,
                                address,
                                position,
                                skill,
                                salary,
                                role,
                                status,
                                rate,
                                background,
                                image,
                                imageId)));
                      }
                      if (selectedValue == 0) {
                        Navigator.of(context).pushNamed(
                          EmployeeInfoScreen.routeName,
                          arguments: userDisplay[index].id,
                        );
                      }
                      if (selectedValue == 2) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text('This action cannot be undone!'),
                            actions: [
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteData(userDisplay[index].id as int);
                                },
                                child: Text('Yes'),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                borderSide: BorderSide(color: Colors.red),
                                child: Text('No'),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          '${local?.info}',
                          style: TextStyle(
                            fontSize: isEnglish ? 15 : 16,
                          ),
                        ),
                        value: 0,
                      ),
                      PopupMenuItem(
                        child: Text(
                          '${local?.edit}',
                          style: TextStyle(
                            fontSize: isEnglish ? 15 : 16,
                          ),
                        ),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text(
                          '${local?.delete}',
                          style: TextStyle(
                            fontSize: isEnglish ? 15 : 16,
                          ),
                        ),
                        value: 2,
                      ),
                    ],
                    icon: Icon(Icons.more_vert),
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
