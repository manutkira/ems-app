import 'package:ems/models/user.dart';
import 'package:ems/utils/services/auth_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const currentUserBoxName = 'currentUser';
const tokenBoxName = 'tokenBox';

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
    await Hive.openBox<String>(tokenBoxName);

    final userBox = Hive.box<User>(currentUserBoxName);
    final tokenBox = Hive.box<String>(tokenBoxName);

    /// fetch logged in user's information
    try {
      var token = tokenBox.get('token');
      if (token == null || token.isEmpty) {
        await tokenBox.delete('token');
        await userBox.delete(currentUserBoxName);
      }

      bool isOnline = await isConnected();
      print('from current user');
      if (isOnline) {
        print("online");

        /// fetch user via api route /me
        /// token will be sent through headers of the request
        final AuthService _authService = AuthService.instance;
        User? user = await _authService.findMe();

        /// after that set current user to returned user;
        userBox.put(currentUserBoxName, user);
      } else {
        print('offline');
        print(user.name);
        return;
        // throw Exception('Not connected to the internet');
      }
    } catch (err) {
      await tokenBox.delete('token');
      await userBox.delete(currentUserBoxName);
    }
  }

  /// returns the current user
  User get user {
    final box = Hive.box<User>(currentUserBoxName);
    final listFromBox = box.values.toList();
    return listFromBox[0];
  }

  bool get isAdmin {
    return user.role?.toLowerCase() == 'admin' ||
        user.role?.toLowerCase() == 'superadmin';
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
          image: user.image.runtimeType != String ? null : user.image,
          role: user.role ?? "Employee",
          status: user.status ?? "Active",
        ),
      );
    }
  }

  /// delete the current user box all together
  Future<void> reset() async {
    final box = Hive.box<User>(currentUserBoxName);
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
