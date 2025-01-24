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
                maxY: 100,
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
}
