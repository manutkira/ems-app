// ignore_for_file: deprecated_member_use

import 'package:ems/constants.dart';
import 'package:ems/screens/payroll/generate_screen.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../models/payment.dart';
import '../../models/user.dart';
import '../../services/user.dart';

// ignore: must_be_immutable
class GeneratedScreen extends StatefulWidget {
  List<Payment>? payment;
  GeneratedScreen({
    Key? key,
    this.payment,
  }) : super(key: key);

  @override
  State<GeneratedScreen> createState() => _GeneratedScreenState();
}

class _GeneratedScreenState extends State<GeneratedScreen> {
  // service
  final UserService _userService = UserService();

  // list user
  List<User> userList = [];

  // boolean
  bool _isLoading = true;

  // fetch data from api
  fetchManyUser() async {
    _isLoading = true;
    try {
      List<User> userDisplay = await _userService.findMany();
      setState(() {
        userList =
            userDisplay.where((element) => element.status == 'active').toList();
        _isLoading = false;
      });
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchManyUser();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${local?.payment}',
        ),
      ),
      body: _isLoading
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
                    Image.asset(
                      'assets/images/Gear-0.5s-200px.gif',
                      width: 60,
                    )
                  ],
                ),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: isEnglish ? 0 : 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 18,
                    right: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${local?.generatedPayment}',
                        style: kHeadingThree,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      collapsedBackgroundColor: const Color(0xff254973),
                      backgroundColor: const Color(0xff254973),
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      initiallyExpanded: false,
                      title: Row(
                        children: [
                          Text(
                            userList[index].name!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Container(
                          color: Colors.black38,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 18,
                              top: 10,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${local?.id}'),
                                    Text(widget.payment![index].id.toString()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${local?.userId}'),
                                    Text(widget.payment![index].userId
                                        .toString()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${local?.status}'),
                                    Text(widget.payment![index].status!
                                        ? '${local?.paid}'
                                        : '${local?.pending}'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${local?.loan}'),
                                    Text(
                                      '\$${doubleParse(widget.payment![index].loan!)}',
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${local?.from}'),
                                    Text(
                                      DateFormat('dd-MM-yyyy').format(widget
                                          .payment![index]
                                          .dateFrom as DateTime),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${local?.to}'),
                                    Text(
                                      DateFormat('dd-MM-yyyy').format(widget
                                          .payment![index].dateTo as DateTime),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RaisedButton(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: kBlueBackground,
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                GeneratePaymentScreen(
                                                    id: widget.payment![index]
                                                        .userId!),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        '${local?.optionView}',
                                        style: const TextStyle(
                                          color: kBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: widget.payment!.length,
                ))
              ],
            ),
    );
  }
}
