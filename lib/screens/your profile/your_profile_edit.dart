import 'package:ems/constants.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YourProfileEditScreen extends StatefulWidget {
  const YourProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<YourProfileEditScreen> createState() => _YourProfileEditScreenState();
}

class _YourProfileEditScreenState extends State<YourProfileEditScreen> {
  var name = 'loading...';
  var email = 'loading...';
  var password = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() {
    // fetch the data here
    name = 'User Name';
    email = 'user@login.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
        ),
        actions: [
          IconButton(
              onPressed: () {
                print("$name $email $password");
              },
              icon: Icon(
                Icons.check,
                size: 30,
              ))
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Name",
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    //
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),

                    child: TextBoxCustom(
                      textHint: 'username',
                      getValue: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      defaultText: name,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email",
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: TextBoxCustom(
                      defaultText: email,
                      textHint: 'email',
                      getValue: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Password",
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: TextBoxCustom(
                      isPassword: true,
                      textHint: 'password',
                      getValue: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      defaultText: password,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
