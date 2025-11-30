import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weatherapp/core/constant/string_constants.dart';

import '../../../../core/constant/api_key.dart';
import '../widgets/info_card.dart';
import '../widgets/legend_row.dart'; // New import
import '../widgets/info_section.dart'; // New import

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double temperature;
  final int humidity;

  const MapPage({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.humidity,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Track current layer: 0=Temperature, 1=Precipitation, 2=Clouds, 3=Wind
  int currentLayerIndex = 0;

  final List<Map<String, dynamic>> weatherLayers = [
    {
      'name': 'Temperature',
      'icon': Icons.thermostat,
      'emoji': '🌡️',
      'urlType': 'temp_new',
      'legend': [
        {'emoji': '🔴', 'label': 'Hot (30°C+)', 'color': Colors.red},
        {'emoji': '🟠', 'label': 'Warm (20-30°C)', 'color': Colors.orange},
        {'emoji': '🟡', 'label': 'Mild (10-20°C)', 'color': Colors.yellow},
        {'emoji': '🔵', 'label': 'Cold (0-10°C)', 'color': Colors.blue},
      ],
      'colorBoost': Colors.orange,
      'opacity': 0.6,
    },
    {
      'name': 'Precipitation',
      'icon': Icons.water_drop,
      'emoji': '💧',
      'urlType': 'precipitation_new',
      'legend': [
        {'emoji': '🟦', 'label': 'Heavy Rain', 'color': Colors.blue[900]},
        {'emoji': '💧', 'label': 'Moderate Rain', 'color': Colors.blue},
        {'emoji': '☁️', 'label': 'Light Rain', 'color': Colors.blue[300]},
      ],
      'colorBoost': Colors.blue,
      'opacity': 0.7,
    },
    {
      'name': 'Cloud Cover',
      'icon': Icons.cloud,
      'emoji': '☁️',
      'urlType': 'clouds_new',
      'legend': [
        {'emoji': '⬜', 'label': 'Clear Sky', 'color': Colors.grey[300]},
        {'emoji': '☁️', 'label': 'Partly Cloudy', 'color': Colors.grey[500]},
        {'emoji': '☁️☁️', 'label': 'Overcast', 'color': Colors.grey[700]},
      ],
      'colorBoost': Colors.grey,
      'opacity': 0.5,
    },
    {
      'name': 'Wind Speed',
      'icon': Icons.air,
      'emoji': '💨',
      'urlType': 'wind_new',
      'legend': [
        {'emoji': '💨', 'label': 'Light Wind', 'color': Colors.cyan[300]},
        {'emoji': '💨💨', 'label': 'Moderate Wind', 'color': Colors.cyan},
        {'emoji': '💨💨💨', 'label': 'Strong Wind', 'color': Colors.cyan[700]},
      ],
      'colorBoost': Colors.cyan,
      'opacity': 0.6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    print('🗺️ [MAP PAGE] Building with:');
    print(' Lat: ${widget.latitude}, Long: ${widget.longitude}');
    print(' Temp: ${widget.temperature}, Humidity: ${widget.humidity}');

    final currentLayer = weatherLayers[currentLayerIndex];
    final weatherLayerUrl =
        'https://tile.openweathermap.org/map/${currentLayer['urlType']}/{z}/{x}/{y}.png?appid=$API_KEY';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${currentLayer['emoji']} ${currentLayer['name']} Map',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Info button
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About Weather Layers',
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),

      // Layer selector FAB
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Main toggle FAB
          FloatingActionButton(
            backgroundColor: Colors.orange,
            heroTag: 'toggle',
            onPressed: () {
              setState(() {
                currentLayerIndex = (currentLayerIndex + 1) % weatherLayers.length;
              });
              print('🔄 [MAP PAGE] Switched to: ${weatherLayers[currentLayerIndex]['name']}');
            },
            child: Icon(
              currentLayer['icon'] as IconData,
              color: Colors.white,
            ),
            tooltip: 'Switch Layer (${currentLayerIndex + 1}/4)',
          ),
          const SizedBox(height: 10),

          // Layer selector button
          FloatingActionButton.small(
            backgroundColor: Colors.black,
            heroTag: 'selector',
            onPressed: () => _showLayerSelector(context),
            child: const Icon(Icons.layers, color: Colors.white),
            tooltip: 'Select Layer',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

      // Map
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(widget.latitude, widget.longitude),
              initialZoom: 8.0,
              minZoom: 4.0,
              maxZoom: 15.0,
            ),
            children: [
              // Base map layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: StringConstants.packageName,
              ),

              // Weather overlay
              TileLayer(
                urlTemplate: weatherLayerUrl,
                userAgentPackageName: StringConstants.packageName,
                tileDisplay: TileDisplay.fadeIn(
                  startOpacity: currentLayer['opacity'] as double,
                ),
                tileBuilder: (context, tileWidget, tile) {
                  return ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      (currentLayer['colorBoost'] as Color).withOpacity(0.2),
                      BlendMode.srcATop,
                    ),
                    child: tileWidget,
                  );
                },
              ),

              // Location marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.latitude, widget.longitude),
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () => _showWeatherInfo(context),
                      child: const Icon(
                        Icons.location_pin,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Legend
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white30, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentLayer['emoji'] as String,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        currentLayer['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...(currentLayer['legend'] as List).map((item) =>
                      LegendRow( // Use new widget
                        emoji: item['emoji'] as String,
                        label: item['label'] as String,
                        color: item['color'] as Color,
                      )),
                  const SizedBox(height: 6),
                  Text(
                    'Tap FAB to switch\nZoom for details',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 9,
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Layer indicator at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    currentLayer['icon'] as IconData,
                    color: currentLayer['colorBoost'] as Color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${currentLayer['name']} Layer Active',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${currentLayerIndex + 1}/4)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLayerSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Select Weather Layer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            ...List.generate(weatherLayers.length, (index) {
              final layer = weatherLayers[index];
              final isSelected = index == currentLayerIndex;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  tileColor: isSelected
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.orange : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  leading: Icon(
                    layer['icon'] as IconData,
                    color: isSelected ? Colors.orange : Colors.white,
                    size: 28,
                  ),
                  title: Text(
                    '${layer['emoji']} ${layer['name']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.orange)
                      : null,
                  onTap: () {
                    setState(() {
                      currentLayerIndex = index;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '🗺️ Weather Layers Info',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InfoSection( // Use new widget
                title: '🌡️ Temperature',
                description: 'Shows hot and cold regions across the map with color-coded zones.',
              ),
              const SizedBox(height: 12),
              InfoSection( // Use new widget
                title: '💧 Precipitation',
                description: 'Displays rainfall and snow areas. Darker blue indicates heavier precipitation.',
              ),
              const SizedBox(height: 12),
              InfoSection( // Use new widget
                title: '☁️ Cloud Cover',
                description: 'Visualizes cloud coverage. Darker areas indicate thicker cloud cover.',
              ),
              const SizedBox(height: 12),
              InfoSection( // Use new widget
                title: '💨 Wind Speed',
                description: 'Shows wind patterns and speed across regions.',
              ),
              const SizedBox(height: 16),
              Text(
                'Tip: Zoom in/out for better visualization!',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showWeatherInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Current Location Weather',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Weather info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InfoCard(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  value: '${widget.temperature.toStringAsFixed(1)}°C',
                  color: Colors.orange,
                ),
                InfoCard(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${widget.humidity}%',
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Coordinates
            Text(
              'Lat: ${widget.latitude.toStringAsFixed(4)}, '
                  'Long: ${widget.longitude.toStringAsFixed(4)}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}