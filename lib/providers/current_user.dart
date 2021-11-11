import 'package:ems/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

User initUser = User(
  id: 0,
  name: "",
  phone: "",
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

final currentUserProvider =
    StateNotifierProvider<CurrentUserState, User>((ref) {
  return CurrentUserState(initUser);
});

class CurrentUserState extends StateNotifier<User> {
  CurrentUserState(User state) : super(state);

  void setUser(User user) {
    state = user;
  }

  void reset() {
    state = initUser;
  }

  // void editUser({required String field, required dynamic value}) {
  //   switch (field) {
  //     case "name":
  //       {
  //         state = state.copyWith(name: value.toString());
  //       }
  //       break;
  //     case "phone":
  //       {
  //         state = state.copyWith(phone: value.toString());
  //       }
  //       break;
  //     case "address":
  //       {
  //         state = state.copyWith(address: value.toString());
  //       }
  //       break;
  //     case "skill":
  //       {
  //         state = state.copyWith(skill: value.toString());
  //       }
  //       break;
  //     case "salary":
  //       {
  //         state = state.copyWith(salary: value.toString());
  //       }
  //       break;
  //     case "background":
  //       {
  //         state = state.copyWith(background: value.toString());
  //       }
  //       break;
  //     case "status":
  //       {
  //         state = state.copyWith(status: value.toString());
  //       }
  //       break;
  //     case "rate":
  //       {
  //         state = state.copyWith(status: value.toString());
  //       }
  //       break;
  //     case "role":
  //       {
  //         state = state.copyWith(role: value.toString());
  //       }
  //       break;
  //     case "email":
  //       {
  //         state = state.copyWith(email: value.toString());
  //       }
  //       break;
  //
  //     default:
  //       {
  //         //
  //       }
  //       break;
  //   }
  // }
}
