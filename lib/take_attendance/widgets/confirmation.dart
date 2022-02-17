import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';

class ScanConfirmation extends ConsumerStatefulWidget {
  const ScanConfirmation({
    Key? key,
    required this.attendance,
    required this.ok,
  }) : super(key: key);
  final Attendance attendance;
  final Function ok;

  @override
  ConsumerState createState() => _ScanConfirmationState();
}

class _ScanConfirmationState extends ConsumerState<ScanConfirmation> {
  late User currentUser;
  final TextEditingController _noteController = TextEditingController();

  String formatTime(DateTime? time) {
    AppLocalizations? local = AppLocalizations.of(context);
    if (time != null) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
    } else {
      return '${local?.errorParsingTime}';
    }
  }

  @override
  void initState() {
    super.initState();
    currentUser = ref.read(currentUserProvider).user;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    Size _size = MediaQuery.of(context).size;
    return Expanded(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          // shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Text(
              '${local?.confirm}',
              style: kHeadingThree,
            ),
            //currentUser info
            SizedBox(height: isEnglish ? 20 : 14),
            _buildUserInfo(_size),
            const SizedBox(height: 20),
            //date
            BaselineRow(
              children: [
                Text(
                  "${local?.date}",
                  style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  getDateStringFromDateTime(DateTime.now()),
                  style: kParagraph,
                ),
              ],
            ),
            _buildSpacer(),
            // from/to
            BaselineRow(
              children: [
                Text(
                  "${local?.time}",
                  style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  formatTime(widget.attendance.date),
                  style: kParagraph,
                ),
              ],
            ),
            _buildSpacer(),
            // from/to
            BaselineRow(
              children: [
                Text(
                  "${local?.type}",
                  style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  widget.attendance.type == AttendanceType.typeCheckIn
                      ? '${local?.checkin}'
                      : '${local?.checkout}',
                  style: kParagraph,
                ),
              ],
            ),
            _buildSpacer(),
            Text(
              "${local?.note}",
              style: kParagraph.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            TextField(
              minLines: 5,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              controller: _noteController,
            ),
            _buildSpacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: kPadding.copyWith(
                        top: isEnglish ? 10 : 4, bottom: isEnglish ? 10 : 4),
                    primary: Colors.white,
                    textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    backgroundColor: kBlack.withOpacity(0.3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: () {
                    widget.ok(_noteController.text);
                    goBack(context);
                  },
                  child: Text(
                    '${local?.update}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  autofocus: true,
                  style: TextButton.styleFrom(
                    padding: kPadding.copyWith(
                        top: isEnglish ? 10 : 4, bottom: isEnglish ? 10 : 4),
                    primary: Colors.white,
                    textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    backgroundColor: kRedText,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: () => goBack(context),
                  child: Text(
                    '${local?.cancel}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            _buildSpacer(), _buildSpacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(Size _size) {
    AppLocalizations? local = AppLocalizations.of(context);

    return Container(
      height: 70,
      width: _size.width,
      decoration: BoxDecoration(
        color: kDarkestBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCircleAvatar(
            imageUrl: "${currentUser.image}",
            size: 50,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaselineRow(
                children: [
                  Text(
                    'ID',
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${currentUser.id ?? ""}',
                    style: kParagraph,
                  ),
                ],
              ),
              BaselineRow(
                children: [
                  Text(
                    '${local?.name}',
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: _size.width * 0.6,
                    child: Text(
                      currentUser.name ?? "",
                      style: kParagraph,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildSpacer() => SizedBox(height: isInEnglish(context) ? 16 : 10);
}
