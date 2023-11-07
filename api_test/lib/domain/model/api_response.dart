class ApiResponse {
  final String name;
  final String country;
  final int temp;
  final String tempMaxMin;
  final String weather;
  final String time;

  const ApiResponse({
    required this.name,
    required this.country,
    required this.temp,
    required this.tempMaxMin,
    required this.weather,
    required this.time,
  });
}
