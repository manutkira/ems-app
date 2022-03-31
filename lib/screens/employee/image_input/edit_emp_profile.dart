import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageInputProfileEdit extends StatefulWidget {
  final Function onSelectImage;
  String imageUrl;

  ImageInputProfileEdit(this.onSelectImage, this.imageUrl);

  @override
  _ImageInputProfileEditState createState() => _ImageInputProfileEditState();
}

class _ImageInputProfileEditState extends State<ImageInputProfileEdit> {
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
    cropImage(pickedFile.path);
  }

  Future getImageCamara() async {
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

  Future cropImage(filePath) async {
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
                        height: 120,
                      ),
                    )
                  : widget.imageUrl.length == 4
                      ? Image.asset('assets/images/profile-icon-png-910.png')
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.network(
                            widget.imageUrl.toString(),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 120,
                          ),
                        ),
              alignment: Alignment.center,
            ),
            Visibility(
              visible: _pickedImage != null || widget.imageUrl != 'null',
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
                        _pickedImage = null;
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
                                getImageCamara();
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
              // borderSide: BorderSide(color: Colors.black),
              icon: Icon(Icons.photo),
              label: Text('${local?.uploadImage}'),
            ),
          ),
        )
      ],
    );
  }
}
