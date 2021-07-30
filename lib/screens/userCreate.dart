import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:dosepix/models/user.dart';

class UserCreate extends StatelessWidget {
  UserCreate({Key? key}) : super(key: key);
  bool _validate = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get registered users
    var registeredUsers = context.watch<UserModel>();

    // Build inputs
    Map<String, String> formFieldNames = {'fullName': 'Full name',
      'userName': 'Username',
      'email': 'E-mail'};
    List<String> formFieldKeys = formFieldNames.keys.toList();
    Map<String, TextEditingController> formFieldControllers = {};
    for (String key in formFieldKeys) {
      formFieldControllers[key] = TextEditingController();
    }

    List<TextFormField> formFieldContainers = [];
    for (String formFieldKey in formFieldKeys) {
      bool obscure = formFieldNames[formFieldKey] == 'Password' ? true : false;
      formFieldContainers.add(
        TextFormField(
          decoration: InputDecoration(
            hintText: formFieldNames[formFieldKey],
          ),
          obscureText: obscure,
          controller: formFieldControllers[formFieldKey],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field required";
            }
            return null;
          },
        )
     );
    }

    return Dialog(
      child: Form(
        key: _formKey,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Register a new user",
              style: Theme.of(context).textTheme.headline5,
            ),
            ...formFieldContainers,
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                // Check if fields are missing
                if (!_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Inputs are missing!")),
                  );
                  return;
                }

                // Add new user in registered users
                // Read values from input fields
                Map<String, String> inputs = {};
                for(String key in formFieldKeys) {
                  inputs[key] = formFieldControllers[key]!.text;
                }

                print(inputs);
                registeredUsers.addNew(
                  fullName: inputs['fullName']!,
                  userName: inputs['userName']!,
                  email: inputs['email']!,
                );

                // Go back to user list
                Navigator.pop(context);
              },
              child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
