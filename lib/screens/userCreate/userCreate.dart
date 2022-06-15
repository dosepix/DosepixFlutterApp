import 'package:flutter/material.dart';
import 'package:dosepix/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dosepix/models/listLayout.dart';

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

    formFieldContainers.add(
      const SizedBox(
        height: 20,
      ),
    );

    formFieldContainers.add(
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
    );

    Form listView = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          top: 10,
          bottom: 10,
        ),
        children: <Widget>[
          ...formFieldContainers,
        ],
      ),
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: Container(
        width: double.maxFinite,
        child: getListLayout(
          context,
          "Create",
          " User",
          Icons.group_add,
          SizedBox.shrink(),
          listView,
        ),
      ),
    );
  }
}
