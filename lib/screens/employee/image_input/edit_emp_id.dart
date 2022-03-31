import 'dart:io';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageInputPickerId extends StatefulWidget {
  final Function onSelectImage;
  String imageUrl;

  ImageInputPickerId(this.onSelectImage, this.imageUrl);

  @override
  _ImageInputPickerIdState createState() => _ImageInputPickerIdState();
}

class _ImageInputPickerIdState extends State<ImageInputPickerId> {
  File? _pickedNationalId;

  Future getIdFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 450,
      maxWidth: 450,
      imageQuality: 1,
    );
    if (pickedFile == null) {
      return;
    }
    cropImage(pickedFile.path);
  }

  Future getIdFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 450,
      maxWidth: 450,
      imageQuality: 50,
    );
    if (pickedFile == null) {
      return;
    }
    cropImage(pickedFile.path);
  }

  Future cropImage(filePath) async {
    File? cropped = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxHeight: 500,
        maxWidth: 700,
        aspectRatio: CropAspectRatio(ratioX: 3.375, ratioY: 2.125),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white));
    if (cropped != null) {
      setState(() {
        _pickedNationalId = cropped;
      });
      widget.onSelectImage(cropped);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Row(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Colors.white,
                )),
                child: _pickedNationalId != null
                    ? ClipRRect(
                        child: Image.file(
                          _pickedNationalId!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120,
                        ),
                      )
                    : widget.imageUrl.length == 4
                        ? Text(
                            '${local?.noIdImage}',
                            textAlign: TextAlign.center,
                          )
                        : ClipRRect(
                            child: Image.network(
                              widget.imageUrl.toString(),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                            ),
                          ),
                alignment: Alignment.center,
              ),
            ),
            Visibility(
              visible: _pickedNationalId != null || widget.imageUrl != 'null',
              child: Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 80,
                  ),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: kBlack,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _pickedNationalId = null;
                          widget.imageUrl = 'null';
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                                getIdFromCamera();
                                Navigator.of(context).pop();
                              },
                              leading: Icon(Icons.camera),
                              title: Text('${local?.takePicture}'),
                            ),
                            ListTile(
                              onTap: () {
                                getIdFromGallery();
                                Navigator.of(context).pop();
                              },
                              leading: Icon(Icons.folder),
                              title: Text('${local?.fromGallery}'),
                            ),
                          ],
                        ),
                      );
                    });
              },
              elevation: 10,
              color: kBlue,
              icon: Icon(Icons.photo),
              label: Text('${local?.uploadImage}'),
            ),
          ),
        )
      ],
    );
  }
}
