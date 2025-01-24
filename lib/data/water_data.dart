import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:water_intake/model/water_model.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/utils/date_helper.dart';

class WaterData extends ChangeNotifier {
  List<WaterModel> waterDataList = [];

  //add water
  void addWater(WaterModel water) async {
    final url = Uri.https(
        'water-intaker-6ed8d-default-rtdb.asia-southeast1.firebasedatabase.app',
        'water.json');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': double.parse(water.amount.toString()),
          'unit': 'ml',
          'dateTime': DateTime.now().toString()
        }));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      waterDataList.add(WaterModel(
          id: extractedData['name'],
          amount: water.amount,
          dateTime: water.dateTime,
          unit: 'ml'));
    } else {
      print('Error: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future<List<WaterModel>> getWater() async {
    final url = Uri.https(
        'water-intaker-6ed8d-default-rtdb.asia-southeast1.firebasedatabase.app',
        'water.json');
    final response = await http.get(url);
    if (response.statusCode == 200 && response.body != 'null') {
      waterDataList.clear();
      final extratedData = json.decode(response.body) as Map<String, dynamic>;
      for (var element in extratedData.entries) {
        waterDataList.add(WaterModel(
            id: element.key, // must add this so we can delete the item
            amount: element.value['amount'],
            dateTime: DateTime.parse(element.value['dateTime']),
            unit: element.value['unit']));
      }
    }
    notifyListeners();
    return waterDataList;
  }

  String getWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  DateTime getStartOfWeek() {
    DateTime? startOfWeek;

    DateTime dateTime = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getWeekday(dateTime.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = dateTime.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  void delete(WaterModel waterModel) {
    final url = Uri.https(
        'water-intaker-6ed8d-default-rtdb.asia-southeast1.firebasedatabase.app',
        'water/${waterModel.id}.json');
    http.delete(url);

    //remove the item from the List
    waterDataList.removeWhere((element) => element.id == waterModel.id);

    notifyListeners();
  }

  // calculate the Weekly water intake
  String calculateWeeklyWaterIntake(WaterData value) {
    double weeklyWaterIntake = 0;

    // loop through the water data list
    for (var water in value.waterDataList) {
      weeklyWaterIntake += double.parse(water.amount.toString());
    }
    return weeklyWaterIntake.toStringAsFixed(2);
  }

// calculate the daily water intake
  Map<String, double> calculateDailyWaterSummary() {
    Map<String, double> dailyWaterSummary = {};

    // loop through the water data list
    for (var water in waterDataList) {
      String date = convertDateTimeToString(water.dateTime);
      double amount = double.parse(water.amount.toString());
      if (dailyWaterSummary.containsKey(date)) {
        double currentAmount = dailyWaterSummary[date]!;
        currentAmount += amount;
        dailyWaterSummary[date] = currentAmount;
      } else {
        dailyWaterSummary.addAll({date: amount});
      }
    }
    return dailyWaterSummary;
  }
}
