import 'package:flutter/material.dart';
import 'package:weatherapp/features/weather/presentation/widgets/today_weather/today_extra_data.dart';
import '../../../../../core/utils/size_config.dart';
import '../../../domain/entities/today_weather/today_weather_data.dart';

class TodaysWeatherView extends StatelessWidget {
  final TodayWeatherData todayWeatherData;

  const TodaysWeatherView(this.todayWeatherData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Minimal padding
          child: Text(
            "Today's Weather",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.white70, // Softer white for minimalism
              fontSize: getProportionateScreenWidth(20), // Slightly smaller
              fontWeight: FontWeight.w500, // Less bold
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)), // Reduced spacing
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: getProportionateScreenWidth(8)), // Minimal spacing
              TodayExtraData(todayWeatherData.todayWeatherData[0]),
              SizedBox(width: getProportionateScreenWidth(8)),
              TodayExtraData(todayWeatherData.todayWeatherData[1]),
              SizedBox(width: getProportionateScreenWidth(8)),
              TodayExtraData(todayWeatherData.todayWeatherData[2]),
              SizedBox(width: getProportionateScreenWidth(8)),
              TodayExtraData(todayWeatherData.todayWeatherData[3]),
              SizedBox(width: getProportionateScreenWidth(8)), // Extra end spacing
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            "5 Days Weather",
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: getProportionateScreenHeight(20),
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}