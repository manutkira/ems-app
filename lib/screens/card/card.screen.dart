import 'package:ems/models/user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class NationalIdScreen extends StatefulWidget {
  final String id;
  NationalIdScreen({required this.id});
  @override
  State<NationalIdScreen> createState() => _NationalIdScreenState();
}

class _NationalIdScreenState extends State<NationalIdScreen> {
  final UserService _userService = UserService.instance;

  User user = User();

  @override
  void initState() {
    try {
      _userService.findOne(int.parse(widget.id)).then((value) {
        setState(() {
          user = value;
        });
      });
      super.initState();
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'National ID',
          style: kHeadingTwo,
        ),
      ),
      body: user.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Fetching Data'),
                  SizedBox(
                    height: 10,
                  ),
                  const CircularProgressIndicator(
                    color: kWhite,
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        )),
                    child: user.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              user.imageId.toString(),
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          )
                        : Text(
                            'No ID Image',
                            textAlign: TextAlign.center,
                          ),
                    // alignment: Alignment.center,
                  ),
                ),
              ],
            ),
    );
  }
}
