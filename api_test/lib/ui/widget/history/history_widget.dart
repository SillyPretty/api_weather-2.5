import 'package:api_test/domain/api_client/api_client.dart';
import 'package:api_test/domain/entity_hive/HiveGroup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  HiveGroup? data;
  int count = 0;

  @override
  void initState() {
    super.initState();
    itemCount();
    initHive();
    setState(() {});
  }

  final _controller = TextEditingController(text: 'tula');
  final List<bool> _isCardVisibleList = List.generate(100000, (index) => false);

  Future<Box<dynamic>> openbox() async {
    if (Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveGroupAdapter());
    }
    final box = await Hive.openBox('data');
    return box;
  }

  void initHive() async {
    final box = await Hive.openBox('data');
    setupHive(box.length - 1);
    setState(() {});
  }

  void setupHive(int index) async {
    try {
    final box = await openbox();
    data = box.getAt(index);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteHiveItem(int index) async {
    final box = await openbox();
    await box.deleteAt(index);
    setState(() {});
    await box.compact();
  }

  Future<void> itemCount() async {
    final box = await openbox();
    final int length = box.length;
    setState(() {
      count = length;
    });
    await box.compact();
  }

  String imagePath() {
    if (data!.weather != '') {
      if (data!.weather == 'cloud') {
        return 'assets/weather/cloud.png';
      } else if (data!.weather == 'rain') {
        return 'assets/weather/rain.png';
      } else if (data!.weather == 'wind') {
        return 'assets/weather/wind.png';
      }
      return 'assets/weather/wind.png';
    } else {
      return 'assets/weather/wind.png';
    }
  }

  void showCard(int index) {
    _isCardVisibleList[index] = !_isCardVisibleList[index];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xff2E335A),
      appBar: AppBar(
        backgroundColor: const Color(0xff2E335A),
        title: const Text(
          'Weather',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              keyboardAppearance: Brightness.dark,
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.white54,
                labelText: 'Search for a city',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          (data != null)
              ? Expanded(
                  child: ListView.separated(
                    itemCount: count,
                    separatorBuilder: (BuildContext context, int index) {
                      setupHive(index);
                      return const Divider(height: 1);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: <Widget>[
                                SlidableAction(
                                  onPressed: (BuildContext context) {
                                    deleteHiveItem(index);
                                    itemCount();
                                    setState(() {});
                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  data!.time != 'Error'
                                      ? Expanded(
                                          child: Text(
                                            data!.time.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        )
                                      : const Spacer(),
                                  Expanded(
                                    child: Text(
                                      data!.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: _isCardVisibleList[index] == true
                                  ? const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.white,
                                    ),
                              onTap: () => showCard(index),
                            ),
                          ),
                          AnimatedContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            width: double.infinity,
                            height: _isCardVisibleList[index] ? 200 : 0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/back.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all((20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data!.temp.toString() + '°'.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 64,
                                        ),
                                      ),
                                      Text(
                                        data!.tempMaxMin,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            data!.name + ', '.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                          Text(
                                            data!.country,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        imagePath(),
                                        width: 120,
                                        height: 120,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        data!.weather,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : const CircularProgressIndicator(strokeWidth: 3),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ApiClient().getWeather(_controller.text);
          final box = await Hive.openBox('data');
          data = box.getAt(box.length - 1);
          itemCount();
          setState(() {});
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
