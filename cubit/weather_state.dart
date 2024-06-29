import '../models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  WeatherLoaded(this.weather);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

// cubit/weather_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  WeatherCubit(this.repository) : super(WeatherInitial());

  void getWeather(String city) async {
    try {
      emit(WeatherLoading());
      final weather = await repository.fetchWeather(city);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError('Failed to fetch weather'));
    }
  }
}
