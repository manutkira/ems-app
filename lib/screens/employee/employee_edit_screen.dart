import 'dart:convert';
import 'dart:io';

import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/check_status.dart';
import 'package:ems/widgets/image_input/edit_emp_id.dart';
import 'package:ems/widgets/image_input/edit_emp_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:ems/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EmployeeEditScreen extends StatefulWidget {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String position;
  final String skill;
  final String salary;
  final String role;
  final String status;
  final String ratee;
  final String background;
  final String? image;
  final String? imageId;

  EmployeeEditScreen(
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.position,
    this.skill,
    this.salary,
    this.role,
    this.status,
    this.ratee,
    this.background,
    this.image,
    this.imageId,
  );
  static const routeName = '/employee-edit';

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController backgroundController = TextEditingController();
  String role = '';
  String status = '';
  String rate = '';

  final _form = GlobalKey<FormState>();

  String? imageUrl = '';
  String? idUrl = '';

  File? pickedImg;
  File? pickedId;

  void _selectImage(File pickedImage) {
    pickedImg = pickedImage;
  }

  void _selectImageId(File pickedImage) {
    pickedId = pickedImage;
  }

  @override
  void initState() {
    nameController.text = widget.name;
    phoneController.text = widget.phone;
    emailController.text = widget.email;
    addressController.text = widget.address;
    positionController.text = widget.position;
    skillController.text = widget.skill;
    salaryController.text = widget.salary;
    backgroundController.text = widget.background;
    // role = '';
    // status = '';
    rate = '';
    imageUrl = widget.image;
    idUrl = widget.imageId;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    print(widget.status);

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
          title: Text('Edit Employee'),
          leading: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('${local?.areYouSure}'),
                          content: Text('Your changes will be lost.'),
                          actions: [
                            OutlineButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await Navigator.of(context)
                                    .pushReplacementNamed(
                                  EmployeeListScreen.routeName,
                                );
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
                  ImageInputProfileEdit(_selectImage, imageUrl!),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.name} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${local?.enterName}',
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '${local?.errorName}';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.phoneNumber} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${local?.enterPhone}',
                              errorStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: phoneController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '${local?.errorPhone}';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please Enter valid number';
                              }
                              if (value.length < 9 || value.length > 10) {
                                return 'Enter Between 8-9 Digits';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.email} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${local?.enterEmail}',
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: emailController,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.position} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${local?.enterPosition}',
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: positionController,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.skill} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '${local?.enterSkill}',
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: skillController,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.salary} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                MdiIcons.currencyUsd,
                                color: kWhite,
                              ),
                              hintText: '${local?.enterSalary}',
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: salaryController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.role} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 233,
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.expand_more),
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.status} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 233,
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.expand_more),
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.rate} ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 233,
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.expand_more),
                          value: rate,
                          onChanged: (String? newValue) {
                            setState(() {
                              rate = newValue!;
                            });
                          },
                          items: <String>[
                            '${local?.veryGood}',
                            '${local?.good}',
                            '${local?.medium}',
                            '${local?.low}',
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
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${local?.address} ',
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                            height: 15,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 1),
                            child: Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: '${local?.enterAddress}',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controller: addressController,
                                textInputAction: TextInputAction.next,
                                maxLines: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${local?.background} ',
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 1),
                            child: Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: '${local?.enterBackground}',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controller: backgroundController,
                                textInputAction: TextInputAction.done,
                                maxLines: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ImageInputPickerId(_selectImageId, idUrl!)
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('${local?.areYouSure}'),
                                        content: Text(
                                            'Do you want to save the changes'),
                                        actions: [
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                            child: Text('${local?.yes}'),
                                            onPressed: () {
                                              if (_form.currentState!
                                                  .validate()) {
                                                uploadImage();
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('${local?.no}'),
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          )
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
                                          Text('Your changes will be lost.'),
                                      actions: [
                                        OutlineButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            await Navigator.of(context)
                                                .pushReplacementNamed(
                                              EmployeeListScreen.routeName,
                                            );
                                          },
                                          child: Text('${local?.yes}'),
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                        ),
                                        OutlineButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('${local?.no}'),
                                          borderSide:
                                              BorderSide(color: Colors.red),
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

  uploadImage() async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    var aName = nameController.text;
    var aPhone = phoneController.text;
    var aEmail = emailController.text;
    var aAddress = addressController.text;
    var aPosition = positionController.text;
    var aSkill = skillController.text;
    var aSalary = salaryController.text;
    var aRole = role;
    var aStatus = status;
    var aWorkrate = rate;
    var aBackground = backgroundController.text;
    var request = await http.MultipartRequest(
        'POST', Uri.parse("$url/${widget.id}?_method=PUT"));
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
    request.files.add(http.MultipartFile.fromString('position', aPosition));
    request.files.add(http.MultipartFile.fromString('skill', aSkill));
    request.files.add(http.MultipartFile.fromString('salary', aSalary));
    String checkRole() {
      if (aRole == local?.employee) {
        return 'amployee';
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
    String checkRate() {
      if (aWorkrate == local?.veryGood) {
        return 'verygood';
      }
      if (aWorkrate == local?.good) {
        return 'good';
      }
      if (aWorkrate == local?.medium) {
        return 'medium';
      }
      if (aWorkrate == local?.low) {
        return 'low';
      } else {
        return '';
      }
    }

    request.files.add(http.MultipartFile.fromString('rate', checkRate()));
    request.files.add(http.MultipartFile.fromString('background', aBackground));
    request.headers.addAll(headers);

    var res = await request.send();
    if (res.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => EmployeeListScreen()));
    }
    res.stream.transform(utf8.decoder).listen((event) {
      print(event);
    });
  }
}
