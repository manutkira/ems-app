import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../constants.dart';

class ImageInputPicker extends StatefulWidget {
  final Function onSelectImage;

  ImageInputPicker(this.onSelectImage);
  @override
  State<ImageInputPicker> createState() => _ImageInputPickerState();
}

class _ImageInputPickerState extends State<ImageInputPicker> {
  File? _pickedImage;

  Future getImage() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 450,
      maxWidth: 450,
      imageQuality: 1,
    );
    if (pickedFile == null) {
      return;
    }

    cropImageProfile(pickedFile.path);
  }

  Future getImageCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 450,
      maxWidth: 450,
      imageQuality: 1,
    );

    if (pickedFile == null) {
      return;
    }
    cropImageProfile(pickedFile.path);
  }

  Future cropImageProfile(filePath) async {
    File? cropped = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxHeight: 500,
        maxWidth: 700,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white));
    if (cropped != null) {
      setState(() {
        _pickedImage = cropped;
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
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
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
                      '${local?.noProfile}',
                      style: TextStyle(
                        fontSize: isEnglish ? 15 : 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
              alignment: Alignment.center,
            ),
            _pickedImage == null
                ? Container()
                : Padding(
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
                            _pickedImage = null;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          size: 15,
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
                                getImageCamera();
                                Navigator.of(context).pop();
                              },
                              leading: Icon(Icons.camera),
                              title: Text('${local?.takePicture}'),
                            ),
                            ListTile(
                              onTap: () {
                                getImage();
                                Navigator.of(context).pop();
                              },
                              leading: Icon(Icons.photo),
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
              label: Text(
                '${local?.uploadImage}',
                style: TextStyle(
                  fontSize: isEnglish ? 15 : 16,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
