import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  final String title;
  const NavigationDrawer({Key? key, this.title = "Drawer"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text("Menu")
          ),
          ListTile(
            title: Text("Measure ToT"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/measurePage');
            },
          ),
          ListTile(
            title: Text("Pair"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/pairPage');
            },
          ),
          ListTile(
            title: Text("Close"),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
