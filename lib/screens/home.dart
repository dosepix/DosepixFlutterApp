import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dosepix/models/mode.dart';
import 'package:dosepix/screens/measInfo.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double horizontalSpace = 20.0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Container(
          padding: EdgeInsets.only(
            top: 30,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(104, 185, 234, 1.0),
                Color.fromRGBO(177, 235, 249, 0.0),
              ],
            ),
          ),
          child: SvgPicture.asset(
            "assets/app_logo.svg",
            semanticsLabel: 'App Logo',
            height: 150,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
            left: 60.0,
            right: 60.0,
          ),
          scrollDirection: Axis.vertical,
          children: [
            Text(
              "Measurement",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(23, 130, 232, 1.0),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(
              height: horizontalSpace,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: MenuButton(
                  "/screen/measure",
                  "Start",
                  Icons.more_time,
                  12.0,
                  Color.fromRGBO(90, 168, 241, 1.0),
                  Color.fromRGBO(204, 187, 236, 1.0),
                )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: MenuButton(
                  "/screen/analyze",
                  "Analyze",
                  Icons.query_stats,
                  12.0,
                  Color.fromRGBO(90, 168, 241, 1.0),
                  Color.fromRGBO(204, 187, 236, 1.0),
                )),
              ],
            ),
            SizedBox(
              height: horizontalSpace,
            ),
            MenuButton(
              "/screen/instructions",
              "Instructions",
              Icons.menu_book,
              12.0,
              Color.fromRGBO(223, 159, 194, 1.0),
              Color.fromRGBO(223, 187, 159, 1.0),
            ),
            SizedBox(
              height: horizontalSpace,
            ),
            Divider(
              color: Colors.blue,
            ),
            SizedBox(
              height: horizontalSpace,
            ),
            Text(
              "Settings & Administration",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(23, 130, 232, 1.0),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(
              height: horizontalSpace,
            ),
            MenuButton(
              "/screen/settings",
              "Settings",
              Icons.settings,
              12.0,
              Color.fromRGBO(223, 208, 159, 1.0),
              Color.fromRGBO(189, 223, 159, 1.0),
            ),
            SizedBox(
              height: horizontalSpace,
            ),
            MenuButton(
              "/screen/administration",
              "Administration",
              Icons.security,
              12.0,
              Color.fromRGBO(131, 190, 151, 1.0),
              Color.fromRGBO(159, 192, 223, 1.0),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  MenuButton(
    this.path,
    this.text,
    this.icon,
    this.borderRadius,
    this.color1,
    this.color2,
  );

  final String path;
  final String text;
  final IconData icon;
  final double borderRadius;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: [
              color1,
              color2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: () {
              if (path == '/screen/analyze') {
                Navigator.pushNamed(
                  context,
                  '/screen/userSelect',
                  arguments: ModeArguments(
                    MODE_ANALYZE,
                    '/screen/measurementSelect',
                  ),
                );
              } else {
                Navigator.pushNamed(
                  context,
                  path,
                );
              }
            },
            child: Container(
              height: 100.0,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 60.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
