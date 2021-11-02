import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusDemo extends StatefulWidget {
  const StatusDemo({Key? key}) : super(key: key);

  @override
  State<StatusDemo> createState() => _StatusDemoState();
}

class _StatusDemoState extends State<StatusDemo> {
  late Future<User>? _user;
  late Future<List<User>>? _users;

  void _getUser() {
    // maybe get id from context
    setState(() {
      // and put id here
      _user = UserService().getUser(1);
    });
  }

  void _getUsers() {
    setState(() {
      _users = UserService().getAllUsers();
    });
  }

  @override
  initState() {
    super.initState();
    _getUser();
    // _getUsers();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
      ),
      body: FutureBuilder<User>(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.id.toString());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator(
            color: kWhite,
          );
        },
      ),
      // body: FutureBuilder<List<User>>(
      //   future: _users,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return ListView.builder(
      //         itemCount: snapshot.data!.length,
      //         itemBuilder: (context, index) {
      //           print(snapshot.data![index]);
      //           return Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(snapshot.data![index].id.toString()),
      //               Text(snapshot.data![index].name.toString()),
      //               Text(snapshot.data![index].phone.toString()),
      //               Text(snapshot.data![index].email.toString()),
      //               Text(snapshot.data![index].emailVerifiedAt != null
      //                   ? snapshot.data![index].emailVerifiedAt.toString()
      //                   : "Not Verified"),
      //               Text(snapshot.data![index].address.toString()),
      //               Text(snapshot.data![index].position.toString()),
      //               Text(snapshot.data![index].skill.toString()),
      //               Text(snapshot.data![index].salary.toString()),
      //               Text(snapshot.data![index].status.toString()),
      //               Text(snapshot.data![index].rate.toString()),
      //               Text(snapshot.data![index].roleId.toString()),
      //               Text(snapshot.data![index].createdAt.toString()),
      //               Text(snapshot.data![index].updatedAt.toString()),
      //               // Text(snapshot.data![index].createdAt.toIso8601String()),
      //               SizedBox(
      //                 height: 20,
      //               ),
      //             ],
      //           );
      //         },
      //       );
      //     } else if (snapshot.hasError) {
      //       print(snapshot.error);
      //       return Text('${snapshot.error}');
      //       return const Text(
      //         'Error fetching data.',
      //       );
      //     }
      //
      //     // By default, show a loading spinner.
      //     return const CircularProgressIndicator(
      //       color: kWhite,
      //     );
      //   },
      // ),
    );
  }
}
