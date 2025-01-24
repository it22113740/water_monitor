import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/utils/date_helper.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startofWeek;
  const WaterSummary({super.key, required this.startofWeek});

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(startofWeek.add(Duration(days: 0)));
    String monday = convertDateTimeToString(startofWeek.add(Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startofWeek.add(Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startofWeek.add(Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startofWeek.add(Duration(days: 4)));
    String friday = convertDateTimeToString(startofWeek.add(Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startofWeek.add(Duration(days: 6)));

    return Consumer<WaterData>(
        builder: (context, value, child) => SizedBox(
              height: 200,
              child: BarGraph(
                maxY: calculateMaxAmount(value, sunday, monday, tuesday,
                    wednesday, thursday, friday, saturday),
                sunWaterAmt: value.calculateDailyWaterSummary()[sunday] ?? 0,
                monWaterAmt: value.calculateDailyWaterSummary()[monday] ?? 0,
                tueWaterAmt: value.calculateDailyWaterSummary()[tuesday] ?? 0,
                wedWaterAmt: value.calculateDailyWaterSummary()[wednesday] ?? 0,
                thuWaterAmt: value.calculateDailyWaterSummary()[thursday] ?? 0,
                friWaterAmt: value.calculateDailyWaterSummary()[friday] ?? 0,
                satWaterAmt: value.calculateDailyWaterSummary()[saturday] ?? 0,
              ),
            ));
  }

  double calculateMaxAmount(
      WaterData waterData,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    double? maxAmount = 100;
    List<double> values = [
      waterData.calculateDailyWaterSummary()[sunday] ?? 0,
      waterData.calculateDailyWaterSummary()[monday] ?? 1,
      waterData.calculateDailyWaterSummary()[tuesday] ?? 2,
      waterData.calculateDailyWaterSummary()[wednesday] ?? 3,
      waterData.calculateDailyWaterSummary()[thursday] ?? 4,
      waterData.calculateDailyWaterSummary()[friday] ?? 5,
      waterData.calculateDailyWaterSummary()[saturday] ?? 6,
    ];

    // sort from smallest to largest
    values.sort();

    // get the largest value
    //increase the max amount by x% of the largest value
    maxAmount = values.last * 1.3;
    return maxAmount == 0 ? 100 : maxAmount;
  }
}
