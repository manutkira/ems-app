// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';
import 'package:ems/models/user.dart';
import 'package:ems/screens/employee/image_input/new_emp_id_img.dart';
import 'package:ems/screens/employee/image_input/new_emp_profile_img.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';
import '../../services/user.dart';

class NewEmployeeScreen extends StatefulWidget {
  @override
  State<NewEmployeeScreen> createState() => _NewEmployeeScreenState();
}

class _NewEmployeeScreenState extends State<NewEmployeeScreen> {
  // service
  final UserService _userService = UserService();

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/image";
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  // text controller
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController position = TextEditingController();
  TextEditingController skill = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController workrate = TextEditingController();
  TextEditingController background = TextEditingController();

  // variables
  String dropDownValue = '';
  String dropDownValue1 = '';
  String dropDownValue2 = '';

  final _form = GlobalKey<FormState>();

  // boolean
  bool _passwordVisible = true;

  // files
  File? pickedImg;
  File? pickedId;

  // image picker
  void _selectImage(File pickedImage) {
    pickedImg = pickedImage;
  }

  void _selectId(File pickedImage) {
    pickedId = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    setState(() {
      if (dropDownValue1.isEmpty) {
        dropDownValue1 = '${local?.employee}';
      }
      if (dropDownValue.isEmpty) {
        dropDownValue = '${local?.active}';
      }
      if (dropDownValue2.isEmpty) {
        dropDownValue2 = '${local?.low}';
      }
    });
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('${local?.addEmployee}'),
            leading: _backBtn(context, local),
          ),
          body: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ImageInputPicker(_selectImage),
                    _sizedBox15(),
                    _nameInput(local, context),
                    _sizedBox15(),
                    _phoneInput(local, context),
                    _sizedBox15(),
                    _emailInput(local, context),
                    _sizedBox15(),
                    _roleInput(local),
                    _sizedBox15(),
                    _passwordInput(local, context),
                    _sizedBox15(),
                    _addressInput(local, context),
                    _sizedBox15(),
                    _backgroundInput(local, context),
                    _yesAndNoBtn(context, local)
                  ],
                ),
              ),
            ),
          )),
    );
  }

// sizedBox
  SizedBox _sizedBox15() {
    return const SizedBox(
      height: 15,
    );
  }

// yes/no button for saving new employee or not
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
                          content: Text('${local?.doYouWantToAdd}'),
                          actions: [
                            // ignore: deprecated_member_use
                            OutlineButton(
                              borderSide: const BorderSide(color: Colors.green),
                              onPressed: () async {
                                if (!_form.currentState!.validate()) {
                                  return Navigator.of(context).pop();
                                }

                                await createOne();
                              },
                              child: Text('${local?.yes}'),
                            ),
                            // ignore: deprecated_member_use
                            OutlineButton(
                              borderSide: const BorderSide(color: Colors.red),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('${local?.no}'),
                            ),
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
                        content: Text('${local?.yourDataWillLost}'),
                        actions: [
                          // ignore: deprecated_member_use
                          OutlineButton(
                            borderSide: const BorderSide(color: Colors.green),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('${local?.yes}'),
                          ),
                          // ignore: deprecated_member_use
                          OutlineButton(
                            borderSide: const BorderSide(color: Colors.red),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('${local?.no}'),
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

// backgroud input field for background information
  Column _backgroundInput(AppLocalizations? local, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${local?.background} ',
          style: kParagraph.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 1),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: '${local?.enterBackground} ',
                      errorStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  controller: background,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ImageInputId(_selectId),
      ],
    );
  }

// address input field for address information
  Column _addressInput(AppLocalizations? local, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${local?.address} ',
          style: kParagraph.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 20,
          height: 15,
        ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 1),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: '${local?.enterAddress} ',
                      errorStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  controller: address,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// password input field for login password
  Row _passwordInput(AppLocalizations? local, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${local?.password} ',
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
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      icon: Icon(
                        _passwordVisible ? MdiIcons.eye : MdiIcons.eyeOff,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    hintText: '${local?.enterPassword} ',
                    errorStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controller: password,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '${local?.errorPassword}';
                    }
                    if (value.length < 8) {
                      return '${local?.errorPasswordLength}';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
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
            value: dropDownValue1,
            onChanged: (String? newValue) {
              setState(() {
                dropDownValue1 = newValue!;
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

// email input field for employee's email information
  Row _emailInput(AppLocalizations? local, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${local?.email} ',
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
                    hintText: '${local?.enterEmail} ',
                    errorStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                            .hasMatch(value)) {
                      return '${local?.errorEmail}';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// phone input field for employee's phone information
  Row _phoneInput(AppLocalizations? local, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${local?.phoneNumber} ',
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
                    hintText: '${local?.enterPhone} ',
                    errorStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controller: phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]+$')
                            .hasMatch(value)) {
                      return '${local?.errorPhone}';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// name input field for employee's name
  Row _nameInput(AppLocalizations? local, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${local?.name} ',
          style: kParagraph.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          child: Flex(direction: Axis.horizontal, children: [
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: '${local?.enterName} ',
                  errorStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                controller: name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '${local?.errorName}';
                  }
                  return null;
                },
              ),
            ),
          ]),
        ),
      ],
    );
  }

// button for pop back screen
  IconButton _backBtn(BuildContext context, AppLocalizations? local) {
    return IconButton(
        onPressed: () {
          if (name.text.isEmpty &&
              phone.text.isEmpty &&
              email.text.isEmpty &&
              password.text.isEmpty &&
              address.text.isEmpty &&
              background.text.isEmpty &&
              pickedId == null &&
              pickedImg == null) {
            Navigator.pop(context);
          } else {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text('${local?.areYouSure}'),
                      content: Text('${local?.yourDataWillLost}'),
                      actions: [
                        // ignore: deprecated_member_use
                        OutlineButton(
                          onPressed: () async {
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
          }
        },
        icon: const Icon(Icons.arrow_back));
  }

// function for create new employee
  createOne() async {
    AppLocalizations? local = AppLocalizations.of(context);
    String checkRole() {
      if (dropDownValue1 == local?.employee) {
        return 'employee';
      }
      if (dropDownValue1 == local?.admin) {
        return 'admin';
      } else {
        return '';
      }
    }

    String checkStatus() {
      if (dropDownValue == local?.active) {
        return 'active';
      }
      if (dropDownValue == local?.inactive) {
        return 'inactive';
      }
      if (dropDownValue == local?.resigned) {
        return 'resigned';
      }
      if (dropDownValue == local?.fired) {
        return 'fired';
      } else {
        return '';
      }
    }

    try {
      User user = User(
        name: name.text,
        phone: phone.text,
        email: email.text,
        password: password.text,
        address: address.text,
        background: background.text,
        status: checkStatus(),
        role: checkRole(),
      );
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('${local?.adding}'),
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
              ));

      User newUser = await _userService.createOne(
        user,
        image: pickedImg,
        imageId: pickedId,
      );
      if (newUser.isNotEmpty) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('${local?.success}'),
                  content: Text('${local?.newEmpAdded}'),
                  actions: [
                    // ignore: deprecated_member_use
                    OutlineButton(
                      borderSide: const BorderSide(color: Colors.green),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // Navigator.pop(context);
                      },
                      child: Text('${local?.done}'),
                    ),
                  ],
                ));
      }
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
