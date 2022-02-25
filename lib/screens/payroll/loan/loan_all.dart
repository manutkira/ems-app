import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/utils.dart';

class LoanAll extends StatefulWidget {
  const LoanAll({Key? key}) : super(key: key);

  @override
  _LoanAllState createState() => _LoanAllState();
}

class _LoanAllState extends State<LoanAll> {
  // text controller
  final TextEditingController _controller = TextEditingController();

  // colors
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

  // list user
  List userDisplay = [];

  List user = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (userDisplay.isEmpty) {
        userDisplay = [
          {
            'name': 'manut1',
            'id': '1',
          },
          {
            'name': 'manut2',
            'id': '2',
          },
          {
            'name': 'manut3',
            'id': '3',
          },
          {
            'name': 'manut4',
            'id': '4',
          },
          {
            'name': 'manut5',
            'id': '5',
          },
        ];
      }
      user = userDisplay;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan'),
      ),
      body: Column(
        children: [
          const Text(
            'Employee',
            style: kHeadingTwo,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
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
            child: Column(
              children: [
                _searchBar(),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/images/profile-icon-png-910.png',
                                      width: 50,
                                    ),
                                  ),
                                  Column(
                                    children: const [
                                      BaselineRow(
                                        children: [
                                          Text(
                                            'Name:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            'Manut',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      BaselineRow(children: [
                                        Text(
                                          'ID:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '3',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        )
                                      ])
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Amount: ',
                                  ),
                                  Text(
                                    '\$500',
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  },
                  itemCount: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void clearText() {
    _controller.clear();
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
            shape: const RoundedRectangleBorder(
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
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }
}
