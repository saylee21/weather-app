import 'package:flutter/material.dart';
import '../../../../../core/utils/size_config.dart';
import '../../../domain/entities/current_weather/current_weather.dart';
import 'current_extra_data.dart';
import 'current_main_data.dart';

class CurrentWeatherView extends StatelessWidget {
  final CurrentWeather currentWeather;

  const CurrentWeatherView(this.currentWeather, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900], // Dark background for minimal dark theme
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(getProportionateScreenWidth(30)), // Subtler radius
          bottomRight: Radius.circular(getProportionateScreenWidth(30)),
        ),
      ),
      child: Column(
        children: [
          CurrentMainData(currentWeather),
          SizedBox(height: getProportionateScreenHeight(18)), // Reduced spacing
          CurrentExtraData(currentWeather),
          SizedBox(height: getProportionateScreenHeight(8)),
        ],
      ),
    );
  }
}