import 'package:flutter/material.dart';
import 'package:weatherapp/features/weather/domain/entities/seven_day_weather/seven_day_weather_data.dart';
import 'package:weatherapp/features/weather/presentation/widgets/seven_day_weather/seven_day_extra_data.dart';

class SevenDaysView extends StatelessWidget {
  final SevenDayWeatherData sevenDayWeatherData;

  const SevenDaysView(this.sevenDayWeatherData, {super.key});

  @override
  Widget build(BuildContext context) {
    final days = sevenDayWeatherData.sevenDayWeatherdata;
    final displayCount = days.length.clamp(0, 5); // Limit to 5 days max per PDF

    return Column(
      children: List.generate(
        displayCount,
            (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Minimal vertical spacing between days
          child: SevenDayExtraData(days[index]),
        ),
      ),
    );
  }
}