String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.year.toString(); //year
  String month = dateTime.month.toString(); //month
  String day = dateTime.day.toString(); //day

  // 2089 / 02 / 12

  if (month.length == 1) {
    month = '0$month';
  }
  if (day.length == 1) {
    day = '0$day';
  }
  return year + month + day;
}
