import 'package:flutter/foundation.dart';

@immutable
abstract class WeatherEvent {}

class GetWeather extends WeatherEvent {
  final String cityName;

  GetWeather(this.cityName);
}
