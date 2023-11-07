import 'package:api_test/domain/api_client/api_client.dart';
import 'package:api_test/domain/entity_hive/HiveGroup.dart';
import 'package:api_test/domain/model/api_response.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  HiveGroup? name;
  ApiResponse? data;
  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveGroupAdapter());
    }
    final box = await Hive.openBox('data');
    if (box.length != 0) {
      name = await box.getAt(box.length - 1);
      final response = await ApiClient().getWeather(name!.name.toString());
      setState(() {
        data = response;
      });
    } else {
      final response = await ApiClient().getWeather('Novomoskovsk');
      setState(() {
        data = response;
      });
    }
  }

  void delete() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveGroupAdapter());
    }
    final box = await Hive.openBox('data');
    await box.deleteFromDisk();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mainscreen/back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: (data != null)
              ? SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          ' '.toString() +
                              data!.temp.toString() +
                              '°'.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 96,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Text(
                          data!.weather,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data!.tempMaxMin,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))),
    );
  }
}
