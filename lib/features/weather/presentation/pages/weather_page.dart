import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/core/constant/string_constants.dart';
import 'package:weatherapp/core/utils/size_config.dart';
import 'package:weatherapp/features/map/presentation/pages/map_page.dart';
import 'package:weatherapp/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weatherapp/features/weather/presentation/widgets/current_weather/current_weather_view.dart';
import 'package:weatherapp/features/weather/presentation/widgets/empty_or_loading.dart';
import 'package:weatherapp/features/weather/presentation/widgets/seven_day_weather/seven_day_weathet_view.dart';
import 'package:weatherapp/features/weather/presentation/widgets/today_weather/today_weather_view.dart';
import 'package:weatherapp/injection_container.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBody(context),
    );
  }

  BlocProvider<WeatherBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeatherBloc>(),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is Empty) {
            context.read<WeatherBloc>().add(GetWeatherForLatLong());
            return const EmptyOrLoading();
          } else if (state is Loading) {
            return const EmptyOrLoading();
          } else if (state is Loaded) {
            return _buildLoadedView(context, state);
          } else if (state is Error) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return Center(
              child: Text(
                StringConstants.errorText,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  // Separate widget for loaded state with FAB
  Widget _buildLoadedView(BuildContext context, Loaded state) {
    return Scaffold(
      backgroundColor: Colors.black,

      // FAB is now inside the BlocBuilder scope
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        elevation: 6.0, // Added elevation for nicer shadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Rounded FAB
        onPressed: () {
         Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MapPage(
                latitude: state.latitude,
                longitude: state.longitude,
                temperature: state.weather.currentWeatherData.currentWeatherData.current.toDouble(),
                humidity: state.weather.currentWeatherData.currentWeatherData.humidity,
              ),
            ),
          );
        },
        child: Icon(
          Icons.map,
          size: getProportionateScreenHeight(30),
          color: Colors.white,
        ),
      ),

      body: Column(
        children: [
          // Search bar at the top with nicer styling
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // More vertical padding for breathing room
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30.0), // Fully rounded for modern look
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4), // Subtle shadow for depth
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: StringConstants.searchHintText,
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.0), // Softer hint
                  prefixIcon: Icon(Icons.search, color: Colors.grey[300]), // Moved icon inside for cleaner UI
                  border: InputBorder.none, // No border for seamless look
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0), // Better padding
                ),
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<WeatherBloc>().add(GetWeatherForCity(value));
                    _searchController.clear();
                  }
                },
              ),
            ),
          ),

          // Weather content with added spacing for nicer layout
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16.0), // Spacing above current weather
                  CurrentWeatherView(
                    state.weather.currentWeatherData.currentWeatherData,
                  ),
                  const SizedBox(height: 24.0), // More space between sections
                  TodaysWeatherView(state.weather.todayWeatherData),
                  const SizedBox(height: 24.0),
                  SevenDaysView(state.weather.sevenDayWeatherData),
                  const SizedBox(height: 32.0), // Bottom padding for FAB clearance
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}