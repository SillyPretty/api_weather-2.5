import 'package:api_test/domain/entity/post.dart';
import 'package:api_test/domain/entity_hive/HiveGroup.dart';
import 'package:api_test/domain/model/api_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:translator/translator.dart';

class ApiClient {
  Future<ApiResponse> getWeather(String city) async {
    final DateTime currentDate = DateTime.now();

    String time = currentDate.toString().substring(0, 16);
    const error = ApiResponse(
      name: 'Error',
      country: 'Error',
      temp: 0,
      tempMaxMin: '0',
      weather: 'Error',
      time: 'Error',
    );
    try {
      if (city != '') {
        Translation translation =
            await GoogleTranslator().translate(city, from: 'ru', to: 'en');
        var apiKey = 'a3ab115da55d3d9416179eb9e5978000';
        final url =
            'http://api.openweathermap.org/data/2.5/weather?q=$translation&units=metric&appid=$apiKey';
        final response = await Dio().get(url);
        final data = Post.fromJson(response.data);
        final temp = data.main['temp']?.toString() ?? '';
        final country = data.sys['country']?.toString() ?? '';
        final int finalTemp = (double.parse(temp)).round();
        final tempMax = data.main['temp_max']?.toString() ?? '';
        final tempMin = data.main['temp_min']?.toString() ?? '';
        final weather = response.data['weather'][0]['main'];
        final name = data.name;
        final tempMaxMin = 'H:'.toString() +
            tempMax.substring(0, 4).toString() +
            '°'.toString() +
            ' '.toString() +
            'L:'.toString() +
            tempMin.substring(0, 4) +
            '°'.toString();
        debugPrint(response.toString());
        debugPrint(country);
        Translation citiName =
            await GoogleTranslator().translate(name, from: 'en', to: 'ru');
        debugPrint(name);
        final result = ApiResponse(
          name: citiName.text,
          country: country,
          temp: finalTemp,
          tempMaxMin: tempMaxMin,
          weather: weather.toString().toString(),
          time: time,
        );
        _hiveadd(citiName.text, country, finalTemp, tempMaxMin, weather, time);
        return result;
      } else {
        return error;
      }
    } catch (e) {
      return error;
    }
  }

  void _hiveadd(String name, String country, int finalTemp, String tempMaxMin,
      String weather, String time) async {
    if (Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveGroupAdapter());
    }
    final box = await Hive.openBox('data');
    final dataHive = HiveGroup(
      name: name,
      country: country,
      temp: finalTemp,
      tempMaxMin: tempMaxMin,
      weather: weather,
      time: time,
    );
    await box.add(dataHive);
    debugPrint(box.length.toString());
    await box.compact();
    await box.close();
  }
}
