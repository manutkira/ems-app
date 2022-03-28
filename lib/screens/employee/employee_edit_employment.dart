import 'package:ems/models/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';
import '../../services/user.dart';

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
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  EmployeeEditEmployment(
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

  // service
  final UserService _userService = UserService();

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
          leading: _backBtn(context, local),
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
                  _salaryInput(local, context),
                  const SizedBox(
                    height: 15,
                  ),
                  _roleInput(local),
                  const SizedBox(
                    height: 15,
                  ),
                  _statusInput(local),
                  const SizedBox(
                    height: 15,
                  ),
                  _yesAndNoBtn(context, local)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// yes/no button for updating or not
  Container _yesAndNoBtn(BuildContext context, AppLocalizations? local) {
    return Container(
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
                              borderSide: const BorderSide(color: Colors.green),
                              child: Text('${local?.yes}'),
                              onPressed: () async {
                                if (!_form.currentState!.validate()) {
                                  return Navigator.of(context).pop();
                                }
                                updateEmployment();
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('${local?.editing}'),
                                    content: Flex(
                                      direction: Axis.horizontal,
                                      children: const [
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 100),
                                            child: CircularProgressIndicator(
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
                              borderSide: const BorderSide(color: Colors.red),
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
                        content: const Text('Your changes will be lost.'),
                        actions: [
                          // ignore: deprecated_member_use
                          OutlineButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pop(context);
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
            child: Text('${local?.cancel}'),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

// status input field for choosing employee's status
  Row _statusInput(AppLocalizations? local) {
    return Row(
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
    );
  }

// role input field for choosing employee's role
  Row _roleInput(AppLocalizations? local) {
    return Row(
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
            items: <String>['${local?.admin}', '${local?.employee}']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                  ));
            }).toList(),
          ),
        )
      ],
    );
  }

// role input field for employee's salary
  Row _salaryInput(AppLocalizations? local, BuildContext context) {
    return Row(
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
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
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
    );
  }

// button for pop back screen
  IconButton _backBtn(BuildContext context, AppLocalizations? local) {
    return IconButton(
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
        icon: const Icon(Icons.arrow_back));
  }

// function for updating employment information
  updateEmployment() async {
    AppLocalizations? local = AppLocalizations.of(context);

    String checkRole() {
      if (role == local?.employee) {
        return 'employee';
      }
      if (role == local?.admin) {
        return 'admin';
      } else {
        return '';
      }
    }

    String checkStatus() {
      if (status == local?.active) {
        return 'active';
      }
      if (status == local?.inactive) {
        return 'inactive';
      }
      if (status == local?.resigned) {
        return 'resigned';
      }
      if (status == local?.fired) {
        return 'fired';
      } else {
        return '';
      }
    }

    try {
      User user = User(
        salary: doubleParse(salaryController.text),
        role: checkRole(),
        status: checkStatus(),
        id: widget.id,
      );

      await _userService.updateOne(user);
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
    } catch (err) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('${local?.failed}',
                    style: const TextStyle(color: Colors.red)),
                content: Text('${local?.addFail}'),
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
  }
}
