import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/data/water_data.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startofWeek;
  const WaterSummary({super.key, required this.startofWeek});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(
        builder: (context, value, child) => SizedBox(
              height: 200,
              child: BarGraph(
                maxY: 100,
                sunWaterAmt: 19,
                monWaterAmt: 34,
                tueWaterAmt: 10,
                wedWaterAmt: 9,
                thuWaterAmt: 2,
                friWaterAmt: 7,
                satWaterAmt: 4,
              ),
            ));
  }
}
