import 'package:ems/models/user.dart';
import 'package:ems/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

const currentUserBoxName = 'currentUser';
const tokenBoxName = 'tokenBox';

class CurrentUserStore {
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
    //
    // await userBox.delete(currentUserBoxName);
    // await tokenBox.delete(tokenBoxName);

    /// fetch logged in user's information
    try {
      var token = tokenBox.get(tokenBoxName);
      if (token == null || token.isEmpty) {
        _reset();
        return;
      }

      bool isOnline = await InternetConnectionChecker().hasConnection;
      if (isOnline) {
        /// fetch user via api route /me
        /// token will be sent through headers of the request
        final AuthService _authService = AuthService.instance;
        User? user = await _authService.findMe();

        if (user == null) {
          _reset();
          return;
        }

        /// after that set current user to returned user;
        userBox.put(currentUserBoxName, user);
      } else {
        return;
        // throw Exception('Not connected to the internet');
      }
    } catch (err) {
      _reset();
    }
  }

  void _reset() async {
    final userBox = Hive.box<User>(currentUserBoxName);
    final tokenBox = Hive.box<String>(tokenBoxName);
    await tokenBox.delete(tokenBoxName);
    await userBox.delete(currentUserBoxName);
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
