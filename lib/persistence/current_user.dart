import 'package:ems/models/user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const currentUserBoxName = 'currentUser';

class CurrentUserStore {
  final User initUser = User(
    id: 0,
    name: "UNREGISTERED USER",
    phone: "012 345 678",
    email: "",
    emailVerifiedAt: DateTime.now(),
    address: "",
    position: "",
    skill: "",
    salary: "",
    status: "",
    password: "",
    role: "",
    rate: "",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  init() async {
    //initialize hive
    await Hive.initFlutter();

    // register adapter
    Hive.registerAdapter<User>(UserAdapter());

    // open the box
    await Hive.openBox<User>(currentUserBoxName);

    final box = Hive.box<User>(currentUserBoxName);

    try {
      int? id = box.values.toList().isNotEmpty ? box.values.toList()[0].id : 0;
      User user = await UserService().findOne(id as int);
      box.put(currentUserBoxName, user);
    } catch (err) {
      await box.delete(currentUserBoxName);
    }
  }

  /// returns the current user
  User get user {
    final box = Hive.box<User>(currentUserBoxName);
    final listFromBox = box.values.toList();
    return listFromBox[0];
  }

  /// to be used with ValueListenableBuilder
  ValueListenable<Box<User>> get currentUserListenable =>
      Hive.box<User>(currentUserBoxName).listenable();

  /// Sets current user to local data
  void setUser({required User user}) async {
    final box = Hive.box<User>(currentUserBoxName);
    if (user.isNotEmpty) {
      await box.put(
        currentUserBoxName,
        user.copyWith(
          role: user.role ?? "Employee",
          status: user.status ?? "Active",
        ),
      );
    }
  }

  /// delete the current user box all together
  Future<void> reset() async {
    final box = Hive.box<User>(currentUserBoxName);
    // await box.delete(currentUserBoxName);
    await box.delete(currentUserBoxName);
  }
}

/// provider will be overridden in the main function in main.dart
/// probably look something like this:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final dataStore = CurrentUserStore();
///   await dataStore.init();
///
///   runApp(
///     ProviderScope(
///       overrides: [
///         currentUserProvider.overrideWithValue(dataStore),
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
final currentUserProvider = Provider<CurrentUserStore>(
  (ref) => throw UnimplementedError(),
);
