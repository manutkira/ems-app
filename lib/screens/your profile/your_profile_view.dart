import 'package:ems/constants.dart';
import 'package:ems/screens/your%20profile/your_profile_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YourProfileViewScreen extends StatelessWidget {
  const YourProfileViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Profile",
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => YourProfileEditScreen(),),);
              },
              icon: Icon(Icons.edit_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: kDarkestBlue,
                  radius: 75,
                  child: Image.asset(
                    'assets/images/bigprofile.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Email",
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Account Type",
                        style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "User Name",
                        style: kParagraph,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "user@login.com",
                        style: kParagraph,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Administrator",
                        style: kParagraph,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
