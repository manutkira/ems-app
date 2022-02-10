import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/image_input/new_emp_id_img.dart';
import 'package:ems/widgets/image_input/new_emp_profile_img.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class NewEmployeeScreen extends StatefulWidget {
  @override
  State<NewEmployeeScreen> createState() => _NewEmployeeScreenState();
}

class _NewEmployeeScreenState extends State<NewEmployeeScreen> {
  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/image";
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

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

  String dropDownValue = '';
  String dropDownValue1 = '';
  String dropDownValue2 = '';

  final _form = GlobalKey<FormState>();
  File? pickedImg;
  File? pickedId;

  void _selectImage(File pickedImage) {
    pickedImg = pickedImage;
  }

  void _selectId(File pickedImage) {
    pickedId = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
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
            leading: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('${local?.areYouSure}'),
                            content: Text('${local?.yourDataWillLost}'),
                            actions: [
                              OutlineButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text('${local?.yes}'),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('${local?.no}'),
                                borderSide: BorderSide(color: Colors.red),
                              )
                            ],
                          ));
                },
                icon: Icon(Icons.arrow_back)),
          ),
          body: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ImageInputPicker(_selectImage),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${local?.name} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${local?.phoneNumber} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${local?.email} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${local?.role} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 233,
                          child: DropdownButtonFormField(
                            icon: const Icon(Icons.expand_more),
                            value: dropDownValue1,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue1 = newValue!;
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
                          '${local?.password} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                child: TextFormField(
                                  decoration: InputDecoration(
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${local?.address} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 1),
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${local?.background} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 1),
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
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: RaisedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          title: Text('${local?.areYouSure}'),
                                          content:
                                              Text('${local?.doYouWantToAdd}'),
                                          actions: [
                                            OutlineButton(
                                              borderSide: const BorderSide(
                                                  color: Colors.green),
                                              onPressed: () {
                                                if (!_form.currentState!
                                                    .validate()) {
                                                  return Navigator.of(context)
                                                      .pop();
                                                }
                                                uploadImage();
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              '${local?.adding}'),
                                                          content: Flex(
                                                            direction:
                                                                Axis.horizontal,
                                                            children: [
                                                              Flexible(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          100),
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ));
                                              },
                                              child: Text('${local?.yes}'),
                                            ),
                                            OutlineButton(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
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
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('${local?.areYouSure}'),
                                        content:
                                            Text('${local?.yourDataWillLost}'),
                                        actions: [
                                          OutlineButton(
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('${local?.yes}'),
                                          ),
                                          OutlineButton(
                                            borderSide: const BorderSide(
                                                color: Colors.red),
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
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  uploadImage() async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    var aName = name.text;
    var aPhone = phone.text;
    var aEmail = email.text;
    var aAddress = address.text;
    var aPosition = position.text;
    var aSkill = skill.text;
    var aSalary = salary.text;
    var aRole = dropDownValue1;
    var aStatus = dropDownValue;
    var apassword = password.text;
    var aWorkrate = dropDownValue2;
    var aBackground = background.text;
    var request = await http.MultipartRequest('POST', Uri.parse(urlUser));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    if (pickedImg != null) {
      request.files.add(http.MultipartFile(
          'image', pickedImg!.readAsBytes().asStream(), pickedImg!.lengthSync(),
          filename: pickedImg!.path.split('/').last));
    }
    if (pickedId != null) {
      request.files.add(http.MultipartFile('image_id',
          pickedId!.readAsBytes().asStream(), pickedId!.lengthSync(),
          filename: pickedId!.path.split('/').last));
    }
    request.files.add(http.MultipartFile.fromString('name', aName));
    request.files.add(http.MultipartFile.fromString('phone', aPhone));
    request.files.add(http.MultipartFile.fromString('email', aEmail));
    request.files.add(http.MultipartFile.fromString('address', aAddress));
    // request.files.add(http.MultipartFile.fromString('position', aPosition));
    // request.files.add(http.MultipartFile.fromString('skill', aSkill));
    // request.files.add(http.MultipartFile.fromString('salary', aSalary));

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
    request.files.add(http.MultipartFile.fromString('password', apassword));

    // String checkRate() {
    //   if (aWorkrate == local?.veryGood) {
    //     return 'verygood';
    //   }
    //   if (aWorkrate == local?.good) {
    //     return 'good';
    //   }
    //   if (aWorkrate == local?.medium) {
    //     return 'medium';
    //   }
    //   if (aWorkrate == local?.low) {
    //     return 'low';
    //   } else {
    //     return '';
    //   }
    // }

    // request.files.add(http.MultipartFile.fromString('rate', checkRate()));

    request.files.add(http.MultipartFile.fromString('background', aBackground));
    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode != 201) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('${local?.failed}',
                    style: TextStyle(color: Colors.red)),
                content: Text('${local?.addFail}'),
                actions: [
                  OutlineButton(
                    borderSide: BorderSide(color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pop(context);
                    },
                    child: Text('${local?.back}',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ));
    }
    if (res.statusCode == 201) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('${local?.success}'),
                content: Text('${local?.newEmpAdded}'),
                actions: [
                  OutlineButton(
                    borderSide: BorderSide(color: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('${local?.done}'),
                  ),
                ],
              ));
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
