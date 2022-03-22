import 'package:ems/constants.dart';
import 'package:ems/screens/payroll/loan/loan_record.dart';
import 'package:ems/screens/payroll/loan/new_loan.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/loan.dart';
import '../../../services/loan.dart' as new_service;
import '../../../utils/utils.dart';

class LoanAll extends StatefulWidget {
  const LoanAll({Key? key}) : super(key: key);

  @override
  _LoanAllState createState() => _LoanAllState();
}

class _LoanAllState extends State<LoanAll> {
  // service
  final new_service.LoanService _loanService = new_service.LoanService();

  // loan all list
  List<Loan> loanAllList = [];
  List<Loan> loan = [];

  // text controller
  final TextEditingController _controller = TextEditingController();

  // colors
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

  // boolean
  bool _isloading = true;

  // fetch loan all from api
  fetchLoanAll() async {
    setState(() {
      _isloading = true;
    });
    try {
      List<Loan> loanAllDIsplay = await _loanService.findManyLoans();
      if (mounted) {
        setState(() {
          loanAllList = loanAllDIsplay;
          loan = loanAllList;
          _isloading = false;
        });
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLoanAll();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${local?.loan}'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NewLoanScreen(),
                ),
              );
              loanAllList = [];
              fetchLoanAll();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${local?.fetchData}'),
                  const CircularProgressIndicator(
                    color: kWhite,
                  ),
                ],
              ),
            )
          : Container(
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100)),
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.white,
                                                )),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                              child: loanAllList[index]
                                                          .user!
                                                          .image ==
                                                      null
                                                  ? Image.asset(
                                                      'assets/images/profile-icon-png-910.png')
                                                  : Image.network(
                                                      loanAllList[index]
                                                          .user!
                                                          .image!,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: 75,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  BaselineRow(
                                                    children: [
                                                      Text(
                                                        '${local?.name}: ',
                                                        style: TextStyle(
                                                          fontSize: isEnglish
                                                              ? 15
                                                              : 15,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            isEnglish ? 2 : 4,
                                                      ),
                                                      SizedBox(
                                                        width: 140,
                                                        child: Text(
                                                          loanAllList[index]
                                                              .user!
                                                              .name
                                                              .toString(),
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
                                                            fontSize: isEnglish
                                                                ? 15
                                                                : 15,
                                                          )),
                                                      const SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text(loanAllList[index]
                                                          .user!
                                                          .id
                                                          .toString()),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '\$${loanAllList[index].remain!.toStringAsFixed(0)}',
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton(
                                            color: kDarkestBlue,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            onSelected:
                                                (int selectedValue) async {
                                              if (selectedValue == 0) {
                                                // int id = loanAllList[index].user!.id as int;
                                                // await Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //     builder: (_) => GeneratePaymentScreen(id: id),
                                                //   ),
                                                // );
                                              }
                                              if (selectedValue == 1) {
                                                String id = loanAllList[index]
                                                    .user!
                                                    .id
                                                    .toString();
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            LoanRecord(
                                                              id: id,
                                                            )));
                                                loanAllList = [];
                                                fetchLoanAll();
                                              }
                                            },
                                            itemBuilder: (_) => [
                                              PopupMenuItem(
                                                child: Text(
                                                  '${local?.info}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        isEnglish ? 15 : 16,
                                                  ),
                                                ),
                                                value: 1,
                                              ),
                                            ],
                                            icon: const Icon(Icons.more_vert),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                        itemCount: loanAllList.length,
                      ),
                    ),
                  ),
                ],
              ),
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
                            loanAllList = loan.where((user) {
                              var userName = user.user!.name!.toLowerCase();
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
                  loanAllList = loan.where((user) {
                    var userName = user.user!.name!.toLowerCase();
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
                  loanAllList.sort((a, b) => a.user!.name!
                      .toLowerCase()
                      .compareTo(b.user!.name!.toLowerCase()));
                });
              }
              if (selectedValue == 1) {
                setState(() {
                  loanAllList.sort((b, a) => a.user!.name!
                      .toLowerCase()
                      .compareTo(b.user!.name!.toLowerCase()));
                });
              }
              if (selectedValue == 2) {
                setState(() {
                  loanAllList
                      .sort((a, b) => a.user!.id!.compareTo(b.user!.id as int));
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
