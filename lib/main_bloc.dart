import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBloc {
  BehaviorSubject<double> _red = BehaviorSubject<double>.seeded(0);
  Stream<double> get red => _red.stream;
  BehaviorSubject<double> _green = BehaviorSubject<double>.seeded(0);
  Stream<double> get green => _green.stream;
  BehaviorSubject<double> _blue = BehaviorSubject<double>.seeded(0);
  Stream<double> get blue => _blue.stream;

  StreamView<List<double>> get colors => CombineLatestStream.combine3(
      red,
      green,
      blue,
      (double param1, double param2, double param3) =>
          [param1, param2, param3]);

  MainBloc() {
    _getColors();
  }

  void _getColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _red.sink.add(prefs.getDouble(_redK) ?? 0);
    _green.sink.add(prefs.getDouble(_greenK) ?? 0);
    _blue.sink.add(prefs.getDouble(_blueK) ?? 0);
  }

  void redChange(double red) {
    _red.add(red);
  }

  void greenChange(double green) {
    _green.add(green);
  }

  void blueChange(double blue) {
    _blue.add(blue);
  }

  void saveColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_redK, _red.value);
    await prefs.setDouble(_greenK, _green.value);
    await prefs.setDouble(_blueK, _blue.value);
    print("Save success");
  }

  String _redK = "red";
  String _greenK = "green";
  String _blueK = "blue";

  void dispose() {
    _red.close();
    _green.close();
    _blue.close();
  }
}
