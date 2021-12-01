import 'dart:convert';
import 'dart:io';

import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/widgets/image_input.dart';
import 'package:http/http.dart' as http;
import 'package:ems/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String role = 'Admin';
  String status = 'Active';
  String rate = 'Good';

  final _form = GlobalKey<FormState>();

  File? _pickedImage;
  String? imageUrl = '';

  // void _selectImage(File pickedImage) {
  //   _pickedImage = pickedImage;
  // }

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = File(image!.path);
    });
  }

  // void imageConvert() {
  //   var image = _pickedImage!.readAsBytes().asStream();
  //   var image1 = _pickedImage!.path;
  //   var image2 = _pickedImage!.lengthSync();
  // }

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
    role = widget.role;
    status = widget.status;
    rate = widget.ratee;
    imageUrl = widget.image!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          title: Text('Are you Sure?'),
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
                              child: Text('Yes'),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            OutlineButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
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
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            )),
                        child: _pickedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 120,
                                ),
                              )
                            : imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(150),
                                    child: Image.network(
                                      imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/profile-icon-png-910.png'),
                        alignment: Alignment.center,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 143, 158, 1),
                                  Color.fromRGBO(255, 188, 143, 1),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(45.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: RaisedButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 150,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              getImage();
                                              Navigator.of(context).pop();
                                            },
                                            leading: Icon(Icons.camera),
                                            title: Text('Take a picture'),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              getImage();
                                              Navigator.of(context).pop();
                                            },
                                            leading: Icon(Icons.folder),
                                            title: Text('From library'),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            elevation: 10,
                            color: kBlue,
                            // borderSide: BorderSide(color: Colors.black),
                            icon: Icon(Icons.photo),
                            label: Text('Upload an image'),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Name ',
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
                              hintText: 'Enter Name',
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Correct Name';
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
                        'Phone ',
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
                              hintText: 'Enter Phone number',
                              errorStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: phoneController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Phone Number';
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
                        'Email ',
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
                              hintText: 'Enter Email address',
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
                                return 'Please Enter Correct Email';
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
                        'Position ',
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
                              hintText: 'Enter Position',
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
                        'Skill ',
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
                              hintText: 'Enter Skill',
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
                        'Salary ',
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
                              hintText: 'Enter Salary',
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
                        'Role ',
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
                            widget.role;
                          },
                          items: <String>['Admin', 'Employee']
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
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status ',
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
                            widget.status;
                          },
                          items: <String>[
                            'Active',
                            'Inactive',
                            'Resigned',
                            'Fired'
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
                        'Rate ',
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
                            widget.ratee;
                          },
                          items: <String>['Very\ Good', 'Good', 'Meduim', 'Low']
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
                            'Address ',
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
                                  hintText: 'Enter Address',
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
                            'Background ',
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
                                  hintText: 'Enter Employee background',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controller: backgroundController,
                                textInputAction: TextInputAction.done,
                                maxLines: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                        title: Text('Are you sure?'),
                                        content: Text(
                                            'Do you want to save the changes'),
                                        actions: [
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                            child: Text('Yes'),
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
                                            child: Text('No'),
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          )
                                        ],
                                      ));
                            },
                            child: Text('Save'),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: Text('Are you Sure?'),
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
                                          child: Text('Yes'),
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                        ),
                                        OutlineButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'),
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        )
                                      ],
                                    ));
                          },
                          child: Text('Cancel'),
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

  // updateData() async {
  //   var aName = nameController.text;
  //   var aPhone = phoneController.text;
  //   var aEmail = emailController.text;
  //   var aAddress = addressController.text;
  //   var aPosition = positionController.text;
  //   var aSkill = skillController.text;
  //   var aSalary = salaryController.text;
  //   var aBackground = backgroundController.text;
  //   var aRole = role;
  //   var aStatus = status;
  //   var aRate = rate;

  //   var data = json.encode({
  //     "name": aName,
  //     "phone": aPhone,
  //     "email": aEmail,
  //     "address": aAddress,
  //     "position": aPosition,
  //     "skill": aSkill,
  //     "salary": aSalary,
  //     "background": aBackground,
  //     "role": aRole,
  //     "status": aStatus,
  //     "rate": aRate,
  //     "image": _pickedImage!.readAsBytes().asStream().last,
  //   });
  //   var response = await http.put(Uri.parse("${url}/${widget.id}"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json"
  //       },
  //       body: data);

  //   if (response.statusCode == 200) {
  //     Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (_) => EmployeeListScreen()));
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

  uploadImage() async {
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
    var request =
        await http.MultipartRequest('PUT', Uri.parse("${url}/${widget.id}"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    // request.files.add(http.MultipartFile('image',
    //     _pickedImage!.readAsBytes().asStream(), _pickedImage!.lengthSync(),
    //     filename: _pickedImage!.path.split('/').last));
    // request.files.add(http.MultipartFile(
    //     'image_id', _idFile!.readAsBytes().asStream(), _idFile!.lengthSync(),
    //     filename: _idFile!.path.split('/').last));
    request.files.add(http.MultipartFile.fromString('name', aName));
    request.files.add(http.MultipartFile.fromString('phone', aPhone));
    request.files.add(http.MultipartFile.fromString('email', aEmail));
    request.files.add(http.MultipartFile.fromString('address', aAddress));
    request.files.add(http.MultipartFile.fromString('position', aPosition));
    request.files.add(http.MultipartFile.fromString('skill', aSkill));
    request.files.add(http.MultipartFile.fromString('salary', aSalary));
    request.files.add(http.MultipartFile.fromString('role', aRole));
    request.files.add(http.MultipartFile.fromString('status', aStatus));
    // request.files.add(http.MultipartFile.fromString('password', apassword));
    request.files.add(http.MultipartFile.fromString('rate', aWorkrate));
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
