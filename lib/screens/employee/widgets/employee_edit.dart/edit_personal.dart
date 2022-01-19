import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/image_input/edit_emp_id.dart';
import 'package:ems/widgets/image_input/edit_emp_profile.dart';

import '../../../../constants.dart';

class EditPersonal extends StatelessWidget {
  final form;
  final Function selectImageId;
  final Function selectImage;
  final Function uploadImage;
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
    required this.uploadImage,
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
    bool isEnglish = isInEnglish(context);
    final _form = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ImageInputProfileEdit(selectImage, imageUrl),
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
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
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
                    ],
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
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
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
                    ],
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
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
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
                    ],
                  ),
                ),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
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
                        ],
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
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
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ImageInputPickerId(selectImageId, idUrl!)
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
                                  content: Text('${local?.saveChanges}'),
                                  actions: [
                                    OutlineButton(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      child: Text('${local?.yes}'),
                                      onPressed: () {
                                        if (!form.currentState!.validate()) {
                                          return Navigator.of(context).pop();
                                        }
                                        uploadImage();
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('${local?.editing}'),
                                            content: Flex(
                                              direction: Axis.horizontal,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                content: Text('Your changes will be lost.'),
                                actions: [
                                  OutlineButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pop(context);
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
                    child: Text('${local?.cancel}'),
                    color: Colors.red,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
