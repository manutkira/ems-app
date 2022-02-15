import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';

import '../../constants.dart';

class ViewAttendanceScreen extends StatefulWidget {
  final int id;
  final int userId;
  final DateTime date;
  String? note;
  final String userName;
  final String image;
  final TimeOfDay time;

  ViewAttendanceScreen({
    Key? key,
    required this.id,
    required this.userId,
    required this.date,
    this.note,
    required this.userName,
    required this.image,
    required this.time,
  }) : super(key: key);

  @override
  State<ViewAttendanceScreen> createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> {
  String? userIdController;
  String? id;
  String? date;
  String? time;
  String type = '';
  String? image;
  TextEditingController? note = TextEditingController();
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    id = widget.id.toString();
    date = DateFormat('dd-MM-yyyy').format(widget.date);
    time = DateFormat('hh:mm').format(widget.date);
    note!.text = widget.note.toString();
    userIdController = widget.userId.toString();
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('${local?.viewAttendance}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: kPaddingAll,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: kDarkestBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: image == 'null'
                            ? Image.asset(
                                'assets/images/profile-icon-png-910.png',
                                width: 50,
                              )
                            : Image.network(
                                image!,
                                width: 60,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaselineRow(
                          children: [
                            Text(
                              '${local?.name} : ',
                              style: kParagraph.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(widget.userName),
                          ],
                        ),
                        BaselineRow(
                          children: [
                            Text(
                              '${local?.id} : ',
                              style: kParagraph.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(userIdController.toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.id} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Text(
                      id.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local!.time} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: Row(
                      children: [
                        Text(widget.time.format(context))
                        // Text(
                        //   widget.time.hour.toString().padLeft(2, '0'),
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // Text(
                        //   ':${widget.time.minute.toString().padLeft(2, '0')}',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local.date} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Text(
                      date.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local.note} ',
                    style: kParagraph.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isEnglish ? 15 : 15.5),
                  ),
                  const SizedBox(
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            readOnly: true,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: note,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '${local.back}',
                        style: const TextStyle(
                          color: kBlueText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: kBlueBackground,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
