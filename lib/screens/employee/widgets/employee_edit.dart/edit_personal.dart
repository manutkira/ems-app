import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ems/screens/employee/image_input/edit_emp_id.dart';
import 'package:ems/screens/employee/image_input/edit_emp_profile.dart';

import '../../../../constants.dart';

// ignore: must_be_immutable
class EditPersonal extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final form;
  final Function selectImageId;
  final Function selectImage;
  final Function updateEmployee;
  final String imageUrl;
  final String idUrl;
  TextEditingController nameController;
  TextEditingController phoneController;
  TextEditingController emailController;
  TextEditingController addressController;
  TextEditingController backgroundController;
  EditPersonal({
    Key? key,
    required this.form,
    required this.selectImageId,
    required this.selectImage,
    required this.updateEmployee,
    required this.imageUrl,
    required this.idUrl,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.backgroundController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ImageInputProfileEdit(selectImage, imageUrl),
            const SizedBox(
              height: 30,
            ),
            _nameInput(local, context),
            const SizedBox(
              height: 15,
            ),
            _phoneInput(local, context),
            const SizedBox(
              height: 15,
            ),
            _emailInput(local, context),
            const SizedBox(
              height: 15,
            ),
            _addressInput(local, context),
            _yesAndNoBtn(context, local)
          ],
        ),
      ),
    );
  }

// yes/no button for updating personal information
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
                              onPressed: () {
                                if (!form.currentState!.validate()) {
                                  return Navigator.of(context).pop();
                                }
                                updateEmployee();
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
                        content: Text('${local?.changesWillLost}'),
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

// address input field for address information
  Column _addressInput(AppLocalizations? local, BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Column(
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
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 1),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '${local?.enterAddress}',
                        errorStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: addressController,
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
              style: kParagraph.copyWith(fontWeight: FontWeight.bold),
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
                        hintText: '${local?.enterBackground}',
                        errorStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: backgroundController,
                      textInputAction: TextInputAction.done,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ImageInputPickerId(selectImageId, idUrl)
      ],
    );
  }

// email input field for email information
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
                    hintText: '${local?.enterEmail}',
                    errorStyle: const TextStyle(
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
            ],
          ),
        ),
      ],
    );
  }

// phone input field for phone information
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
                    hintText: '${local?.enterPhone}',
                    errorStyle: const TextStyle(
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
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: '${local?.enterName}',
                    errorStyle: const TextStyle(
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
            ],
          ),
        ),
      ],
    );
  }
}
