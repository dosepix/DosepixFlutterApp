import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dosepix/colors.dart';

class Instructions extends StatefulWidget {
  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  int currentIndex = 0;

  List<SliderModel> slides = [
    SliderModel(
      image: "assets/placeholder.png",
      title: "Test",
      description: "description",
    ),
      SliderModel(
      image: "assets/placeholder.png",
      title: "Test2",
      description: "description2",
    ),
      SliderModel(
      image: "assets/placeholder.png",
      title: "Test3",
      description: "description3",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 50,
          bottom: 50,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  setState(() {
                      currentIndex = value;
                    }
                  );
                },
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  return Slider(
                    image: slides[index].getImage(),
                    title: slides[index].getTitle(),
                    description: slides[index].getDescription(),
                  );
                }
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                  (index) => buildDot(index, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(
    int index,
    BuildContext context,
  ) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: dosepixColor40,
      ),
    );
  }
}

class Slider extends StatelessWidget {
  final String image, title, description;
  Slider({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage(image)),
          SizedBox(height: 20,),
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12,),
          Text(
            description,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 25,),
        ],
      ),
    );
  }
}

class SliderModel {
  String image, title, description;

  SliderModel({
    required this.image,
    required this.title,
    required this.description,
  });

  String getImage() {
    return image;
  }

  String getTitle() {
    return title;
  }

  String getDescription() {
    return description;
  }
}
