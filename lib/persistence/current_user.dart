import 'package:ems/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const currentUserBoxName = 'currentUser';

class CurrentUserStore {
  init() async {
    //initialize hive
    await Hive.initFlutter();

    // register adapter
    Hive.registerAdapter<User>(UserAdapter());

    // open the box
    await Hive.openBox<User>(currentUserBoxName);
  }

  User get user {
    final box = Hive.box<User>(currentUserBoxName);
    // Stream<User> _user = box.watch().map((event) => box.values.toList()[0]);
    // var user = await _user.toList();
    return box.values.toList()[0];
  }

  // to be used with ValueListenableBuilder
  ValueListenable<Box<User>> get currentUserListenable =>
      Hive.box<User>(currentUserBoxName).listenable();

  // set current user
  void setUser({required User user}) async {
    print('hi from persistence');
    final box = Hive.box<User>(currentUserBoxName);
    if (user.isEmpty == false) {
      await box.put(
        currentUserBoxName,
        user.copyWith(
          role: user.role ?? "Employee",
          status: user.status ?? "Active",
        ),
      );
    }
  }

  // reset to empty box
  Future<void> reset() async {
    final box = Hive.box<User>(currentUserBoxName);
    // await box.delete(currentUserBoxName);
    await box.put(currentUserBoxName, User());
  }
}

// provider will be overridden in main function
final currentUserProvider = Provider<CurrentUserStore>(
  (ref) => throw UnimplementedError(),
);
