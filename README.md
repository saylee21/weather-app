# Weather App - Flutter Assignment

A comprehensive Flutter weather application with interactive map features and real-time weather data visualization.

## 📱 Features

### Home Page
- **Current Weather Display**: Shows temperature, weather condition, and icons
- **5-Day Forecast**: Visual representation of upcoming weather
- **GPS Auto-Location**: Automatic detection of user's current location
- **City Search**: Manual search functionality to view weather for any city
- **Real-time Updates**: Live weather data from OpenWeatherMap API

### Map Page
- **Interactive Map**: OpenStreetMap integration with smooth navigation
- **4 Weather Layers** (2 Required + 2 Bonus):
    - 🌡️ **Temperature Layer**: Visualizes hot and cold regions
    - 💧 **Precipitation Layer**: Shows rainfall and snow areas
    - ☁️ **Cloud Cover Layer** (Bonus): Displays cloud coverage
    - 💨 **Wind Speed Layer** (Bonus): Shows wind patterns
- **Location Marker**: Interactive marker at user's current/selected location
- **Weather Details**: Tap marker to view temperature and humidity
- **Layer Selector**: Easy switching between different weather visualizations
- **Visual Legend**: Color-coded guide for understanding weather data

---

## 📋 Requirements Fulfillment

### ✅ Home Page Requirements

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| **Weather Display** | Current temperature, condition, and icon prominently displayed | ✅ Complete |
| **Forecast Overview** | 5-day forecast with clear visual cards | ✅ Complete |
| **GPS Location** | Automatic location detection with permission handling | ✅ Complete |
| **Manual Search** | Search bar for city-based weather lookup | ✅ Complete |

### ✅ Map Page Requirements

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| **Map Integration** | OpenStreetMap (Google Maps alternative) | ✅ Complete |
| **Precipitation Overlay** | Toggle-able precipitation layer with color visualization | ✅ Complete |
| **Temperature Overlay** | Toggle-able temperature layer with color zones | ✅ Complete |
| **Visual Depiction** | Comprehensive weather visualization across entire map | ✅ Complete |
| **Location Marker** | Red pin marker at user/selected location | ✅ Complete |
| **Marker Interaction** | Tappable marker with bottom sheet | ✅ Complete |
| **Temperature Display** | Shows current temperature in styled card | ✅ Complete |
| **Humidity Display** | Shows current humidity percentage | ✅ Complete |

---

## 🌟 Extra Features (Going Beyond Requirements)

### Map Page Enhancements
1. **4 Weather Layers**: Added Cloud Cover and Wind Speed (beyond required 2)
2. **Layer Selector UI**: Beautiful bottom sheet for easy layer switching
3. **Visual Legend**: Real-time legend showing what colors mean
4. **Info Dialog**: Explanatory dialog about each weather layer
5. **Layer Indicator**: Bottom bar showing active layer
6. **Smooth Animations**: Fade-in effects for layer transitions
7. **Color Enhancement**: Color filters for better layer visibility
8. **Multiple FABs**: Quick toggle + detailed selector options

### Home Page Enhancements
1. **Search Integration**: Instant city search with real-time API calls
2. **Error Handling**: Comprehensive error states with retry options
3. **Loading States**: Smooth loading indicators
4. **Dark Theme**: Professional dark UI matching modern design trends

---

## 🏗️ Architecture & Best Practices

### Clean Architecture
```
lib/
├── core/                    # Shared utilities
│   ├── constants/          # API keys, configuration
│   ├── error/              # Error handling
│   ├── location/           # GPS services
│   └── utils/              # Helper functions
├── features/
│   ├── weather/
│   │   ├── data/           # Data layer
│   │   │   ├── datasources/    # API calls
│   │   │   ├── models/         # Data models
│   │   │   └── repositories/   # Repository impl
│   │   ├── domain/         # Business logic
│   │   │   ├── entities/       # Domain models
│   │   │   ├── repositories/   # Repository contracts
│   │   │   └── usecases/       # Use cases
│   │   └── presentation/   # UI layer
│   │       ├── bloc/           # State management
│   │       ├── pages/          # Screens
│   │       └── widgets/        # Reusable components
│   └── map/                # Map feature (same structure)
```

### State Management
- **BLoC Pattern**: Used throughout the app for predictable state management
- **Events**: User actions trigger events
- **States**: UI rebuilds based on state changes
- **Separation of Concerns**: Business logic separated from UI

### SOLID Principles Applied

#### Single Responsibility Principle (SRP)
- Each class has one clear purpose
- `WeatherRemoteDataSource`: Only handles API calls
- `WeatherRepository`: Only manages data flow
- `WeatherBloc`: Only handles state management

#### Open/Closed Principle (OCP)
- Abstract classes allow extension without modification
- `WeatherRepository` interface can have multiple implementations

#### Liskov Substitution Principle (LSP)
- `WeatherModel` extends `Weather` entity properly
- Can substitute model for entity without breaking code

#### Interface Segregation Principle (ISP)
- Small, focused interfaces
- `WeatherRemoteDataSource` only defines needed methods

#### Dependency Inversion Principle (DIP)
- High-level modules don't depend on low-level modules
- Both depend on abstractions (repository interfaces)
- Dependency injection throughout

### Error Handling
- **Network Errors**: Graceful handling with user-friendly messages
- **API Failures**: Retry mechanisms and fallback states
- **Permission Denial**: Clear guidance for users
- **Invalid Input**: Validation and error feedback
- **Exception Logging**: Debug prints for troubleshooting

### Code Quality
- **Consistent Naming**: Clear, descriptive variable/function names
- **Code Comments**: Strategic comments explaining complex logic
- **Debug Logging**: Comprehensive logging with emojis for easy tracking
- **Type Safety**: Proper type annotations throughout
- **Null Safety**: Flutter 3.x null-safe code

---

## 🛠️ Technologies Used

### Core Framework
- **Flutter 3.x**: Cross-platform mobile development
- **Dart**: Programming language

### State Management
- **flutter_bloc ^8.1.6**: BLoC pattern implementation
- **equatable ^2.0.5**: Value equality for state comparison

### Networking
- **http ^1.2.2**: API requests to OpenWeatherMap

### Location Services
- **geolocator ^13.0.1**: GPS location detection
- **geocoding ^3.0.0**: City name to coordinates conversion

### Maps
- **flutter_map ^7.0.2**: OpenStreetMap integration
- **latlong2 ^0.9.1**: Latitude/longitude utilities

### UI/UX
- **intl ^0.19.0**: Date/time formatting

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.16 or higher)
- Android Studio / VS Code
- Android device or emulator

### Installation Steps

1. **Clone the repository**
```bash
   git clone <repository-url>
   cd weather_app
```

2. **Install dependencies**
```bash
   flutter pub get
```

3. **Configure API Keys**

   Create `lib/core/constant/api_key.dart`:
```dart
   const String API_KEY = 'your_openweathermap_api_key_here';
```

**Get OpenWeatherMap API Key:**
- Sign up at [OpenWeatherMap](https://openweathermap.org/api)
- Navigate to API Keys section
- Copy your API key
- Wait 10-15 minutes for activation

4. **Update Android Manifest**

   Add permissions to `android/app/src/main/AndroidManifest.xml`:
```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

5. **Run the app**
```bash
   flutter run
```

### Building APK
```bash
flutter build apk --release
```
APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🧪 Testing

### Manual Testing Checklist
- [ ] App launches successfully
- [ ] Location permission requested
- [ ] GPS location detected
- [ ] Current weather displays
- [ ] 5-day forecast shows
- [ ] City search works
- [ ] Map opens from home page
- [ ] All 4 weather layers display
- [ ] Layer toggling works
- [ ] Marker tap shows info
- [ ] Error states display properly

### Tested Scenarios
- ✅ No internet connection
- ✅ Location permission denied
- ✅ Invalid city name
- ✅ API rate limit
- ✅ GPS unavailable
- ✅ Different zoom levels on map

---

## 📸 Screenshots

1. **Home Page - Current Weather**
    - Shows temperature, condition, icon
    - Location name displayed
    - Search bar visible
    -  - 5-day forecast cards
    - Date, temperature, icons for each day
<img width="331" height="720" alt="home_page" src="https://github.com/user-attachments/assets/d361ea07-20db-443c-a6ac-c1b76324a893" />
<img width="300" height="659" alt="search_city" src="https://github.com/user-attachments/assets/8a8c873f-13af-4314-bf81-c1add789ac5f" />

2. **Map Page - Temperature Layer**
    - Color-coded temperature zones
    - Legend on right side
    - Location marker visible
<img width="335" height="696" alt="temp_layer" src="https://github.com/user-attachments/assets/65e8bb77-231a-4b52-ac33-2d5b12b83e68" />

3. **Map Page - Precipitation Layer**
    - Rain areas visualized
    - Layer indicator at bottom
<img width="336" height="691" alt="precipitation_layer" src="https://github.com/user-attachments/assets/78ff0692-0157-4341-8c88-708cfe48c2ea" />


4. **Map Page - Layer Selector**
    - Bottom sheet with 4 layer options
    - Current layer highlighted
<img width="336" height="696" alt="selector_layer" src="https://github.com/user-attachments/assets/e01f21f1-d4f7-4575-a3b5-44023f2f74e6" />
<img width="336" height="707" alt="info_dialog" src="https://github.com/user-attachments/assets/08a57181-0741-49d6-87fd-104771d80e87" />


5. **Marker Bottom Sheet**
    - Temperature and humidity cards
    - Coordinates displayed
<img width="334" height="687" alt="bottom_sheet" src="https://github.com/user-attachments/assets/11e8a9b3-bf78-4d53-8303-07fdaff27fdd" />

---

## 🎯 Key Design Decisions

### Why OpenStreetMap Instead of Google Maps?
- ✅ **No Credit Card Required**: Completely free, no billing setup
- ✅ **No API Key Needed**: Instant setup
- ✅ **Unlimited Usage**: No rate limits or quotas
- ✅ **Same Functionality**: Meets all assignment requirements
- ✅ **Production Ready**: Used by major applications

### Why 4 Weather Layers?
- Required: Temperature + Precipitation
- **Bonus**: Cloud Cover + Wind Speed
- Demonstrates technical capability
- Enhances user experience
- Shows initiative beyond requirements

### Why BLoC Pattern?
- Industry-standard state management
- Predictable state changes
- Testable architecture
- Separation of business logic from UI
- As recommended in assignment

---

## 🐛 Known Limitations

1. **Weather Layer Visibility**: OpenWeatherMap free tier has subtle colors
    - **Solution**: Added color enhancement and legends

2. **Tile Loading**: Occasional delays in weather tile loading
    - **Solution**: Fade-in animations for smooth UX

3. **No Offline Mode**: Requires internet connection
    - **Future**: Implement caching

---

## 🔮 Future Enhancements

- [ ] Unit tests for BLoC and repositories
- [ ] Widget tests for UI components
- [ ] Local database for offline weather data
- [ ] Weather notifications
- [ ] Favorite locations
- [ ] Weather alerts
- [ ] Animated weather icons
- [ ] Multi-language support
- [ ] Dark/Light theme toggle

---

## 📚 API Documentation

### OpenWeatherMap Endpoints Used

1. **Current Weather**
```
   GET https://api.openweathermap.org/data/2.5/weather
   Params: lat, lon, units=metric, appid
```

2. **5-Day Forecast**---

## 👨‍💻 Development Best Practices Followed

### Code Organization
- ✅ Feature-based folder structure
- ✅ Consistent naming conventions
- ✅ Separation of concerns
- ✅ Reusable components

### Performance
- ✅ Efficient widget rebuilds
- ✅ Lazy loading where applicable
- ✅ Image caching
- ✅ Optimized API calls

### User Experience
- ✅ Loading indicators
- ✅ Error messages
- ✅ Smooth animations
- ✅ Intuitive navigation
- ✅ Helpful tooltips

### Maintainability
- ✅ Clean code principles
- ✅ SOLID principles
- ✅ Documentation
- ✅ Debug logging
- ✅ Type safety

---

## 📄 License

This project is created for educational purposes as part of a Flutter development assignment.

---

## 🙏 Acknowledgments

- **OpenWeatherMap** for weather data API
- **OpenStreetMap** for map tiles
- **Flutter Team** for the amazing framework
- **BLoC Library** for state management solution

---

**Built with ❤️ using Flutter**

*Last Updated: November 2025*
