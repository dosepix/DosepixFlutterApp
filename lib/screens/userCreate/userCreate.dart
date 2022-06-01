import 'package:flutter/material.dart';
import 'package:dosepix/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart'
    if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class UserCreate extends StatelessWidget {
  UserCreate({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get registered users
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);

    // Build inputs
    Map<String, String> formFieldNames = {
      'fullName': 'Full name',
      'userName': 'Username',
      'email': 'E-mail',
      'password': 'Password',
    };

    Map<String, IconData> formFieldIcons = {
      'fullName': Icons.face,
      'userName': Icons.account_circle,
      'email': Icons.mail,
      'password': Icons.vpn_key,
    };

    List<String> formFieldKeys = formFieldNames.keys.toList();
    Map<String, TextEditingController> formFieldControllers = {};
    for (String key in formFieldKeys) {
      formFieldControllers[key] = TextEditingController();
    }

    List<Widget> formFieldContainers = [];
    for (String formFieldKey in formFieldKeys) {
      bool obscure = formFieldNames[formFieldKey] == 'Password' ? true : false;
      formFieldContainers.add(
        TextFormField(
          scrollPadding: EdgeInsets.only(bottom: 40),
          decoration: InputDecoration(
            fillColor: dosepixColor10,
            filled: true,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
            hintText: formFieldNames[formFieldKey],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(formFieldIcons[formFieldKey]),
            errorStyle: TextStyle(
              fontSize: 10,
              color: dosepixColor80,
            ),
          ),
          obscureText: obscure,
          controller: formFieldControllers[formFieldKey],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field is required";
            }
            return null;
          },
        ),
      );
      formFieldContainers.add(
        const SizedBox(
          height: 10,
        ),
      );
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 0.0,
        child: Row(
          children: [
            Container(
              height: 50,
              margin: EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: 50,
                right: 50,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                ),
                iconSize: 30,
                color: dosepixColor50,
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ),
          ],
        ),
        color: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
      padding: EdgeInsets.all(50),
      child:
        ListView(
          children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create",
                          style: GoogleFonts.nunito(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: dosepixColor40,
                          ),
                        ),
                        Text(
                          "new User",
                          style: GoogleFonts.nunito(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.person_add,
                      color: dosepixColor10,
                      size: 100,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ...formFieldContainers,
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(20),
                textStyle: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                primary: dosepixColor40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Check if fields are missing
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                // Add new user in registered users
                // Read values from input fields
                Map<String, String> inputs = {};
                for (String key in formFieldKeys) {
                  inputs[key] = formFieldControllers[key]!.text;
                }

                // Via internal system
                /*
                registeredUsers.addNew(
                  fullName: inputs['fullName']!,
                  userName: inputs['userName']!,
                  email: inputs['email']!,
                );
               */

                // Via SQL
                doseDatabase.usersDao.insertUser(UsersCompanion.insert(
                  userName: inputs['userName']!,
                  fullName: inputs['fullName']!,
                  email: inputs['email']!,
                  password: inputs['password']!,
                ));

                doseDatabase.usersDao.getUsers().then((users) => print(users));

                // Go back to user list
                Navigator.pop(context);
              },
              child: Text(
                'Register',
              ),
            ),
          ),
         ],
        ),
      ),
    );
  }
}
