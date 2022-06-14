import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dosepix/colors.dart';

PreferredSize getAppBar(
  BuildContext context,
  String titleText1,
  String titleText2,
  IconData icon,
  {
    double size=200,
    double fontSize=40,
    double iconSize=100,
  }
) {
  return PreferredSize(
    preferredSize: Size.fromHeight(size),
    child: Container(
      padding: EdgeInsets.only(
        top: 60,
        left: 50,
        right: 50,
        bottom: 50,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor,
            Color.fromARGB(0, 255, 255, 255),
          ],
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.nunito(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: dosepixColor40,
              ),
              children: [
                TextSpan(text: titleText1),
                TextSpan(
                  text: titleText2,
                  style: GoogleFonts.nunito(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            color: dosepixColor10,
            size: iconSize,
          ),
        ],
      ),
    ),
  );
}

Scaffold getListLayout(
  BuildContext context,
  String titleText1,
  String titleText2,
  IconData icon,
  Widget floatingActionButton,
  Widget body,
  {
    double size=200,
    double fontSize=40,
    double iconSize=100,
  }
  ) {
  return Scaffold(
    appBar: getAppBar(
      context,
      titleText1,
      titleText2,
      icon,
      size: size,
      fontSize: fontSize,
      iconSize: iconSize,
    ),
    bottomNavigationBar: BottomAppBar(
      notchMargin: 0.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(0, 255, 255, 255),
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          )
        ),
        alignment: Alignment.bottomLeft,
        height: 80,
        padding: EdgeInsets.only(
          bottom: 50,
        ),
        margin: EdgeInsets.only(
          top: 20,
          bottom: 0,
          left: 50,
          right: 50,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          iconSize: 30,
          color: dosepixColor50,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      color: Colors.transparent,
      elevation: 0.0,
    ),
    floatingActionButton: floatingActionButton,
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    body: body,
  );
}

ListTile getListTile(
  String mainText,
  String subText,
  void Function() onTap,
) {
  return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 10,
        bottom: 10,
      ),
      tileColor: dosepixColor10,
      textColor: Color.fromRGBO(88, 88, 88, 1.0),
      title: Text(
        mainText,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20.0,
        ),
      ),
      subtitle: Text(subText),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
  );
}
