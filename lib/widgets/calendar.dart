import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:dosepix/colors.dart';
import 'package:google_fonts/google_fonts.dart';

// Models
import 'package:dosepix/models/measurementTime.dart';
import 'package:dosepix/widgets/measurementSelect.dart';
import 'package:dosepix/models/listLayout.dart';

class Calendar extends StatelessWidget {
  final Map<DateTime, List<MeasurementTimeModel>> dateTimes;
  const Calendar(this.dateTimes);

  Map<DateTime, int> getTotalDose(Map<DateTime, List<MeasurementTimeModel>> dateTimes) {
    Map<DateTime, int> totalDoses = new Map();
    for (DateTime key in dateTimes.keys) {
      List<MeasurementTimeModel> measTimes = dateTimes[key]!;
      double doseSum = 0;
      for (MeasurementTimeModel measTime in measTimes) {
        doseSum += measTime.totalDose;
      }
      totalDoses[DateUtils.dateOnly(key)] = doseSum.toInt();
    }
    return totalDoses;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: [
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ].reduce(min).roundToDouble() * 0.8,
      ),
      padding: EdgeInsets.only(
        left: 50,
        right: 50,
        top: 20,
      ),
      child: HeatMapCalendar(
        datasets: getTotalDose(dateTimes),
        colorMode: ColorMode.opacity,
        colorsets: const {
          1000: dosepixColor40,
        },
        size: 60,
        monthFontSize: 20,
        weekFontSize: 15,
        textColor: Colors.black,
        flexible: true,
        onClick: (date) {
          print(date);
          if (dateTimes.containsKey(date)) {
            print(dateTimes[date]);

            List<int> measurementIds = [];
            for (MeasurementTimeModel mt in dateTimes[date]!) {
              print(mt.id);
              measurementIds.add(mt.id);
            }
            
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  content: Container(
                    width: double.maxFinite,
                    child: getListLayout(
                      context,
                      "Select",
                      " Measurement",
                      Icons.abc,
                      SizedBox.shrink(),
                      MeasurementSelectWidget(dateTimes[date]!),
                      size: 200,
                      fontSize: 40,
                      iconSize: 50,
                    ),
                  ),
                );
              }
            );
          }
        },
        defaultColor: dosepixColor10.withAlpha(20),
        borderRadius: 20,
        margin: EdgeInsets.all(10),
        colorTipSize: 20,
        colorTipHelper: [
          Text(
            "left",
            style: GoogleFonts.nunito(
              fontSize: 20,
            ),
          ),
          Text(
            " right",
            style: GoogleFonts.nunito(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
