import 'package:api_test/ui/widget/history/history_widget.dart';
import 'package:api_test/ui/widget/main_screen/main_screen_widget.dart';
import 'package:flutter/material.dart';

class AllWidget extends StatefulWidget {
  const AllWidget({super.key});

  @override
  State<AllWidget> createState() => _AllWidgetState();
}

class _AllWidgetState extends State<AllWidget> {
  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 0;
    PageController pageController =
        PageController(initialPage: currentPageIndex);

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const <Widget>[
          MainScreen(),
          HistoryWidget(),
        ],
        onPageChanged: (index) {
          currentPageIndex = index;
        },
      ),
    );
  }
}
