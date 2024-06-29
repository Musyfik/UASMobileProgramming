class Weather {
  final double temperature;
  final double windSpeed;
  final int humidity;
  final double visibility;
  final String description;

  Weather({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.visibility,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      visibility: json['visibility'] / 1000,
      description: json['weather'][0]['description'],
    );
  }
}
