import 'package:ems/constants.dart';
import 'package:ems/persistence/attendances.dart';
import 'package:ems/services/attendance.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LocalAttendanceCacheScreen extends ConsumerStatefulWidget {
  const LocalAttendanceCacheScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LocalAttendanceCacheScreenState();
}

class _LocalAttendanceCacheScreenState
    extends ConsumerState<LocalAttendanceCacheScreen> {
  AttendanceService attService = AttendanceService.instance;
  bool isUploading = false;

  Future<void> massUpload() async {
    AppLocalizations? local = AppLocalizations.of(context);
    var cache = await ref.read(localAttendanceCacheProvider).get();
    bool isOnline = await InternetConnectionChecker().hasConnection;

    if (cache.isEmpty || !isOnline) return;

    setState(() {
      isUploading = true;
    });

    try {
      await attService.createManyRecords(cache);
      ScaffoldMessenger.of(context).showSnackBar(
        baseSnackBar(
          message: '${local?.savingLocalAttendanceSuccess}',
          textColor: kBlueText,
          backgroundColor: kBlueBackground,
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        baseSnackBar(
          message: '${local?.savingLocalAttendanceFailed}',
          textColor: kRedText,
          backgroundColor: kRedBackground,
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  SnackBar baseSnackBar({
    required String message,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return SnackBar(
      content: Text(
        message.toTitleCase(),
        style: TextStyle(
          color: textColor,
        ),
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
    );
  }

  Future<void> resetLocalCache() async {
    AppLocalizations? local = AppLocalizations.of(context);
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("${local?.cancel}"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(backgroundColor: kRedText),
      child: Text("${local?.delete}"),
      onPressed: () async {
        await ref.read(localAttendanceCacheProvider).clear();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("${local?.confirmDelete}"),
      content: Text("${local?.confirmDeleteQuestion}"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    return ValueListenableBuilder(
      valueListenable:
          ref.watch(localAttendanceCacheProvider).localCacheListenable,
      builder: (BuildContext context, Box<List<dynamic>> box, Widget? child) {
        var list = box.get(localAttendanceCacheBoxName);
        return Scaffold(
          appBar: AppBar(
            title: Text('${local?.localCache}'),
            actions: [
              Visibility(
                visible: list!.isNotEmpty,
                child: IconButton(
                  tooltip: '${local?.clearAll}',
                  onPressed: resetLocalCache,
                  icon: const Icon(Icons.delete_sweep_rounded),
                ),
              ),
            ],
          ),
          body: isUploading
              ? _buildLoading
              : list.isEmpty
                  ? _buildEmptyCache
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        var currentItem = list[index];
                        return attendanceItem(currentItem, index);
                      },
                    ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: kBlueBackground,
            onPressed: massUpload,
            // onPressed: () {
            //   ref.read(localAttendanceCacheProvider).add({
            //     "user": {"id": 3, "name": 'Song Kim', "profile": 'gg.jpg'},
            //     "user_id": 3,
            //     "time": DateTime.now().toIso8601String(),
            //     "note": 'this is a note'
            //   });
            // },
            label: Text(
              '${local?.upload}',
              style: const TextStyle(
                  color: kBlueText, fontWeight: FontWeight.w600),
            ),
            icon: const Icon(
              MdiIcons.arrowUp,
              color: kBlueText,
            ),
          ),
        );
      },
    );
  }

  Widget attendanceItem(dynamic attendance, int index) {
    String profile = "${attendance['user']?['profile']}";
    String name = "${attendance['user']?['name']}";
    DateTime datetime = DateTime.parse("${attendance['time']}");
    String date = getDateStringFromDateTime(datetime, format: 'dd-MM-yyyy');
    String time =
        "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
    return Container(
      color: index % 2 == 0 ? kDarkestBlue : kBlue,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomCircleAvatar(imageUrl: profile),
              const SizedBox(width: 8),
              Text(name),
            ],
          ),
          Row(
            children: [
              Text(date),
              const SizedBox(width: 8),
              Text(time),
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Material(
                  color: kRedText,
                  shape: const CircleBorder(),
                  child: IconButton(
                    constraints: const BoxConstraints(
                      maxHeight: 36,
                      maxWidth: 36,
                    ),
                    onPressed: () async {
                      await ref
                          .read(localAttendanceCacheProvider)
                          .remove(attendance);
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 18,
                      color: kRedBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// builds the loading widget
  Widget get _buildLoading {
    Size _size = MediaQuery.of(context).size;
    AppLocalizations? local = AppLocalizations.of(context);

    return Container(
      width: _size.width,
      height: _size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: kWhite,
              strokeWidth: 4,
            ),
            const SizedBox(
              height: 15,
            ),
            Text('${local?.savingAttendance}')
          ],
        ),
      ),
      color: kDarkestBlue,
    );
  }

  Widget get _buildEmptyCache {
    AppLocalizations? local = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "🤷🏽‍",
            style: kHeadingOne.copyWith(fontSize: 100),
          ),
          Text('${local?.noRecordFound}', style: kParagraph),
        ],
      ),
    );
  }
}
