import 'package:flutter/material.dart';

import '../../../../../core/utils/size_config.dart';
import '../../../domain/entities/current_weather/current_weather.dart';

class CurrentMainData extends StatelessWidget {
  final CurrentWeather currentWeather;

  const CurrentMainData(this.currentWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(300),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: AssetImage(currentWeather.image),
            width: getProportionateScreenWidth(250),
            height: getProportionateScreenHeight(250),
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(25, '${currentWeather.current}\u00B0'),
                      SizedBox(width: 16,),
                      text(25, currentWeather.name),
                    ],
                  ),
                  text(18, currentWeather.day),
                  text(16, currentWeather.city), // New city display
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget text(double height, String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontSize: getProportionateScreenHeight(height),
      ),
    );
  }
}