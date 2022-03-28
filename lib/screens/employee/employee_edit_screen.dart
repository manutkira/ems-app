// ignore_for_file: await_only_futures

import 'dart:io';
import 'package:ems/screens/employee/widgets/employee_edit.dart/edit_personal.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../services/user.dart';
import '../../models/user.dart';

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

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
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
  // service
  final UserService _userService = UserService();

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  // text controller
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController backgroundController = TextEditingController();

  // variable
  String role = '';
  String status = '';
  String rate = '';
  String? imageUrl = '';
  String? idUrl = '';

  final _form = GlobalKey<FormState>();

  // Files
  File? pickedImg;
  File? pickedId;

  // image picker
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
            child: EditPersonal(
                form: _form,
                selectImageId: _selectImageId,
                selectImage: _selectImage,
                updateEmployee: updatePersonal,
                imageUrl: imageUrl.toString(),
                idUrl: idUrl.toString(),
                nameController: nameController,
                phoneController: phoneController,
                emailController: emailController,
                addressController: addressController,
                backgroundController: backgroundController)),
      ),
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

// function for update employee's personal information
  updatePersonal() async {
    AppLocalizations? local = AppLocalizations.of(context);
    try {
      User user = User(
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        address: addressController.text,
        background: backgroundController.text,
        id: widget.id,
      );
      await _userService.updateOne(user, image: pickedImg, imageId: pickedId);
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
