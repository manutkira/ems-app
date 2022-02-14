import 'package:ems/constants.dart';
import 'package:ems/persistence/attendances.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  Future<void> massUpload() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Cache'),
      ),
      body: ValueListenableBuilder(
        valueListenable:
            ref.watch(localAttendanceCacheProvider).localCacheListenable,
        builder: (BuildContext context, Box<List<dynamic>> box, Widget? child) {
          var list = box.get(localAttendanceCacheBoxName);

          if (list!.isEmpty) return _buildEmptyCache;

          return ListView.builder(
            // shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              var currentItem = list[index];
              String profile = "${currentItem['user']['profile']}";
              String name = "${currentItem['user']['name']}";
              DateTime datetime = DateTime.parse("${currentItem['date']}");
              String date =
                  getDateStringFromDateTime(datetime, format: 'dd-MM-yyyy');
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
                                    .remove(currentItem);
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
            },
          );
        },
      ),
      // body: Container(
      //   child: Text(
      //       'hey ${ref.read(localAttendanceCacheProvider).get().then((value) => print(value.))}'),
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: massUpload,
        // onPressed: () {
        //   ref.read(localAttendanceCacheProvider).add({
        //     "user": {"id": 1, "name": 'song', "profile": 'gg.jpg'},
        //     "user_id": 1,
        //     "date": DateTime.now(),
        //     "note": 'this is a note'
        //   });
        // },
        child: const Icon(MdiIcons.arrowUp),
      ),
    );
  }

  Widget get _buildEmptyCache {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "🤷🏽‍",
            style: kHeadingOne.copyWith(fontSize: 100),
          ),
          const Text('No Record Found.', style: kParagraph),
        ],
      ),
    );
  }
}
