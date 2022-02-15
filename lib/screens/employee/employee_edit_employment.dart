import 'dart:convert';

import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class EmployeeEditEmployment extends StatefulWidget {
  final String name;
  final String phone;
  final int id;
  final String position;
  final String skill;
  final String salary;
  final String role;
  final String status;
  final String ratee;
  const EmployeeEditEmployment(
    this.name,
    this.phone,
    this.id,
    this.position,
    this.skill,
    this.salary,
    this.role,
    this.status,
    this.ratee,
  );

  @override
  _EmployeeEditEmploymentState createState() => _EmployeeEditEmploymentState();
}

class _EmployeeEditEmploymentState extends State<EmployeeEditEmployment> {
  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  // text controller
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController backgroundController = TextEditingController();

  // variables
  String role = '';
  String status = '';
  String rate = '';

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text = widget.name;
    phoneController.text = widget.phone;
    positionController.text = widget.position;
    skillController.text = widget.skill;
    salaryController.text = widget.salary;
    rate = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);

    String checkRole() {
      if (widget.role == 'admin') {
        return '${local?.admin}';
      }
      if (widget.role == 'employee') {
        return '${local?.employee}';
      } else {
        return '';
      }
    }

    String checkSatus() {
      if (widget.status == 'active') {
        return '${local?.active}';
      }
      if (widget.status == 'inactive') {
        return '${local?.inactive}';
      }
      if (widget.status == 'resigned') {
        return '${local?.resigned}';
      }
      if (widget.status == 'fired') {
        return '${local?.fired}';
      } else {
        return '';
      }
    }

    String checkRate() {
      if (widget.ratee == 'verygood') {
        return '${local?.veryGood}';
      }
      if (widget.ratee == 'good') {
        return '${local?.good}';
      }
      if (widget.ratee == 'medium') {
        return '${local?.medium}';
      }
      if (widget.ratee == 'low') {
        return '${local?.low}';
      } else {
        return '';
      }
    }

    setState(() {
      if (role.isEmpty) {
        role = checkRole();
      }
      if (status.isEmpty) {
        status = checkSatus();
      }
      if (rate.isEmpty) {
        rate = checkRate();
      }
    });
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${local?.editEmployee}'),
          leading: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('${local?.areYouSure}'),
                          content: Text('${local?.changesWillLost}.'),
                          actions: [
                            // ignore: deprecated_member_use
                            OutlineButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('${local?.yes}'),
                              borderSide: const BorderSide(color: Colors.green),
                            ),
                            // ignore: deprecated_member_use
                            OutlineButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('${local?.no}'),
                              borderSide: const BorderSide(color: Colors.red),
                            )
                          ],
                        ));
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.salary} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    MdiIcons.currencyUsd,
                                    color: kWhite,
                                  ),
                                  hintText: '${local?.enterSalary}',
                                  errorStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controller: salaryController,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.role} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 233,
                        child: DropdownButtonFormField(
                          icon: const Icon(Icons.expand_more),
                          value: role,
                          onChanged: (String? newValue) {
                            setState(() {
                              role = newValue!;
                            });
                          },
                          items: <String>[
                            '${local?.admin}',
                            '${local?.employee}'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ));
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.status} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 233,
                        child: DropdownButtonFormField(
                          icon: const Icon(Icons.expand_more),
                          value: status,
                          onChanged: (String? newValue) {
                            setState(() {
                              status = newValue!;
                            });
                          },
                          items: <String>[
                            '${local?.active}',
                            '${local?.inactive}',
                            '${local?.resigned}',
                            '${local?.fired}'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ));
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('${local?.areYouSure}'),
                                        content: Text('${local?.saveChanges}'),
                                        actions: [
                                          // ignore: deprecated_member_use
                                          OutlineButton(
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                            child: Text('${local?.yes}'),
                                            onPressed: () {
                                              if (!_form.currentState!
                                                  .validate()) {
                                                return Navigator.of(context)
                                                    .pop();
                                              }
                                              updateEmployee();
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title:
                                                      Text('${local?.editing}'),
                                                  content: Flex(
                                                    direction: Axis.horizontal,
                                                    children: const [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 100),
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          // ignore: deprecated_member_use
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('${local?.no}'),
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                          )
                                        ],
                                      ));
                            },
                            child: Text('${local?.save}'),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: Text('${local?.areYouSure}'),
                                      content: const Text(
                                          'Your changes will be lost.'),
                                      actions: [
                                        // ignore: deprecated_member_use
                                        OutlineButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.pop(context);
                                          },
                                          child: Text('${local?.yes}'),
                                          borderSide: const BorderSide(
                                              color: Colors.green),
                                        ),
                                        // ignore: deprecated_member_use
                                        OutlineButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('${local?.no}'),
                                          borderSide: const BorderSide(
                                              color: Colors.red),
                                        )
                                      ],
                                    ));
                          },
                          child: Text('${local?.cancel}'),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateEmployee() async {
    AppLocalizations? local = AppLocalizations.of(context);

    var aName = nameController.text;
    var aPhone = phoneController.text;
    var aSalary = salaryController.text;
    var aRole = role;
    var aStatus = status;

    var request = await http.MultipartRequest(
        'POST', Uri.parse("$url/${widget.id}?_method=PUT"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    request.files.add(http.MultipartFile.fromString('name', aName));
    request.files.add(http.MultipartFile.fromString('phone', aPhone));
    request.files.add(http.MultipartFile.fromString('salary', aSalary));
    String checkRole() {
      if (aRole == local?.employee) {
        return 'employee';
      }
      if (aRole == local?.admin) {
        return 'admin';
      } else {
        return '';
      }
    }

    request.files.add(http.MultipartFile.fromString('role', checkRole()));
    String checkStatus() {
      if (aStatus == local?.active) {
        return 'active';
      }
      if (aStatus == local?.inactive) {
        return 'inactive';
      }
      if (aStatus == local?.resigned) {
        return 'resigned';
      }
      if (aStatus == local?.fired) {
        return 'fired';
      } else {
        return '';
      }
    }

    request.files.add(http.MultipartFile.fromString('status', checkStatus()));
    request.headers.addAll(headers);

    var res = await request.send();
    if (res.statusCode != 200) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('${local?.failed}',
                    style: const TextStyle(color: Colors.red)),
                content: Text('${local?.editFailed}'),
                actions: [
                  // ignore: deprecated_member_use
                  OutlineButton(
                    borderSide: const BorderSide(color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('${local?.back}',
                        style: const TextStyle(color: Colors.red)),
                  ),
                ],
              ));
    }
    if (res.statusCode == 200) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('${local?.success}'),
                content: Text('${local?.edited}'),
                actions: [
                  // ignore: deprecated_member_use
                  OutlineButton(
                    borderSide: const BorderSide(color: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('${local?.done}'),
                  ),
                  // ignore: deprecated_member_use
                  OutlineButton(
                    borderSide: const BorderSide(color: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('${local?.back}'),
                  ),
                ],
              ));
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
