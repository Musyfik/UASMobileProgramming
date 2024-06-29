
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/weather_cubit.dart';
import 'repositories/weather_repository.dart';
import 'cubit/weather_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WeatherRepository repository = WeatherRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => WeatherCubit(repository),
        child: WeatherScreen(),
      ),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    BlocProvider.of<WeatherCubit>(context)
                        .getWeather(_cityController.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return CircularProgressIndicator();
                } else if (state is WeatherLoaded) {
                  return WeatherView(state.weather);
                } else if (state is WeatherError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  final Weather weather;

  WeatherView(this.weather);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${weather.temperature}°',
          style: TextStyle(fontSize: 72),
        ),
        Text(
          weather.description,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WeatherInfo(
              icon: Icons.air,
              value: '${weather.windSpeed} km/h',
              label: 'Wind',
            ),
            WeatherInfo(
              icon: Icons.opacity,
              value: '${weather.humidity}%',
              label: 'Humidity',
            ),
            WeatherInfo(
              icon: Icons.visibility,
              value: '${weather.visibility} km',
              label: 'Visibility',
            ),
          ],
        ),
      ],
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  WeatherInfo({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
