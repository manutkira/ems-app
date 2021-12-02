import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

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

  String dropDownValue = 'Active';
  String dropDownValue1 = 'Admin';
  String dropDownValue2 = 'Very\ Good';

  final _form = GlobalKey<FormState>();

  File? _pickedImage;
  File? _idFile;
  var resJson;

  // void _selectImage(File pickedImage) {
  //   _pickedImage = pickedImage;
  // }

  Future getImageFromCamera() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 1,
      maxHeight: 450,
      maxWidth: 450,
    );
    if (image == null) {
      return;
    }

    setState(() {
      _pickedImage = File(image.path);
    });
  }

  Future getImage() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 1,
      maxHeight: 450,
      maxWidth: 450,
    );
    if (image == null) {
      return;
    }

    setState(() {
      _pickedImage = File(image.path);
    });
  }

  Future _getIdFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 1,
      maxHeight: 450,
      maxWidth: 450,
    );
    if (pickedFile == null) {
      return;
    }
    cropImage(pickedFile.path);

    // Navigator.pop(context);
  }

  Future _getIdFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 1,
      maxHeight: 450,
      maxWidth: 450,
    );
    if (pickedFile == null) {
      return;
    }
    cropImage(pickedFile.path);

    // Navigator.pop(context);
  }

  Future cropImage(filePath) async {
    File? cropped = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxHeight: 500,
        maxWidth: 700,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white));
    if (cropped != null) {
      setState(() {
        _idFile = cropped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Add Employee'),
            leading: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text('Are you Sure?'),
                            content: Text('Your data will be lost.'),
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
                    // ImageInput(_selectImage),
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
                                  ),
                                )
                              : Text(
                                  'No Profile',
                                  textAlign: TextAlign.center,
                                ),
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
                                                getImageFromCamera();
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Name',
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              controller: name,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Phone Number',
                                errorStyle: TextStyle(
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
                                  return 'Please Enter Correct Phone';
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Email address',
                                errorStyle: TextStyle(
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
                          'Password ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                                errorStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              controller: password,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Password';
                                }
                                if (value.length < 8) {
                                  return 'Enter more than 8 characters';
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter Position',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              controller: position,
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter Skill',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              controller: skill,
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter Salary',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              controller: salary,
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 233,
                          child: DropdownButtonFormField(
                            icon: Icon(Icons.expand_more),
                            value: dropDownValue1,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue1 = newValue!;
                              });
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 233,
                          child: DropdownButtonFormField(
                            icon: Icon(Icons.expand_more),
                            value: dropDownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue = newValue!;
                              });
                            },
                            items: <String>[
                              'Active',
                              'Inactive',
                              'Resigned',
                              'Fired'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 233,
                          child: DropdownButtonFormField(
                            icon: Icon(Icons.expand_more),
                            value: dropDownValue2,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue2 = newValue!;
                              });
                            },
                            items: <String>[
                              'Very \Good',
                              'Good',
                              'Meduim',
                              'Low',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 1),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter Address',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              controller: address,
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 1),
                          child: Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Enter Employee background',
                                  errorStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              controller: background,
                              textInputAction: TextInputAction.done,
                              maxLines: 3,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              height: 80,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                width: 1,
                                color: Colors.white,
                              )),
                              child: _idFile != null
                                  ? ClipRRect(
                                      child: Image.file(
                                        _idFile!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    )
                                  : Text(
                                      'No ID Image',
                                      textAlign: TextAlign.center,
                                    ),
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
                                                    _getIdFromCamera();
                                                    Navigator.of(context).pop();
                                                  },
                                                  leading: Icon(Icons.camera),
                                                  title: Text('Take a picture'),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    _getIdFromGallery();
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
                                              'Do you want to add new employee?'),
                                          actions: [
                                            OutlineButton(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                              onPressed: () {
                                                if (_form.currentState!
                                                    .validate()) {
                                                  uploadImage();
                                                  // addNew();
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Yes'),
                                            ),
                                            OutlineButton(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('No'),
                                            ),
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
                                        title: Text('Are you sure?'),
                                        content:
                                            Text('Your data will be lost.'),
                                        actions: [
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      EmployeeListScreen(),
                                                ),
                                              );
                                            },
                                            child: Text('Yes'),
                                          ),
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('No'),
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
          )),
    );
  }

  uploadImage() async {
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
    if (_pickedImage != null) {
      request.files.add(http.MultipartFile('image',
          _pickedImage!.readAsBytes().asStream(), _pickedImage!.lengthSync(),
          filename: _pickedImage!.path.split('/').last));
    }
    if (_idFile != null) {
      request.files.add(http.MultipartFile(
          'image_id', _idFile!.readAsBytes().asStream(), _idFile!.lengthSync(),
          filename: _idFile!.path.split('/').last));
    }
    request.files.add(http.MultipartFile.fromString('name', aName));
    request.files.add(http.MultipartFile.fromString('phone', aPhone));
    request.files.add(http.MultipartFile.fromString('email', aEmail));
    request.files.add(http.MultipartFile.fromString('address', aAddress));
    request.files.add(http.MultipartFile.fromString('position', aPosition));
    request.files.add(http.MultipartFile.fromString('skill', aSkill));
    request.files.add(http.MultipartFile.fromString('salary', aSalary));
    request.files.add(http.MultipartFile.fromString('role', aRole));
    request.files.add(http.MultipartFile.fromString('status', aStatus));
    request.files.add(http.MultipartFile.fromString('password', apassword));
    request.files.add(http.MultipartFile.fromString('rate', aWorkrate));
    request.files.add(http.MultipartFile.fromString('background', aBackground));
    request.headers.addAll(headers);

    var res = await request.send();
    if (res.statusCode == 201) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => EmployeeListScreen()));
    }
    res.stream.transform(utf8.decoder).listen((event) {
      print(event);
    });
  }
}
