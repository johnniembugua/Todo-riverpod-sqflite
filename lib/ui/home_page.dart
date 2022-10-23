import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';

import 'add_task_bar.dart';
import 'widgets/task_tile.dart';

class HomePageUi extends ConsumerStatefulWidget {
  const HomePageUi({super.key});

  @override
  ConsumerState<HomePageUi> createState() => _HomePageUiState();
}

class _HomePageUiState extends ConsumerState<HomePageUi> {
  NotifyHelper notifyHelper = NotifyHelper();
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    final tasks = ref.watch(getTasksController);
    return Expanded(
        child: tasks.when(data: (data) {
      return data!.isEmpty
          ? const Center(
              child: Text("Your TaskList is empty"),
            )
          : RefreshIndicator(
              onRefresh: () => ref.refresh(getTasksController.future),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final reversedTask = data.reversed.toList();
                    final task = reversedTask[index];
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                            child: FadeInAnimation(
                                child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("tapped");
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ))));
                  }),
            );
    }, error: (error, _) {
      return Center(
        child: Text(error.toString()),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }));
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: white,
        dateTextStyle: GoogleFonts.lato().copyWith(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        dayTextStyle: GoogleFonts.lato().copyWith(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        monthTextStyle: GoogleFonts.lato().copyWith(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle.copyWith(
                  color: ref.watch(appThemeProvider).getTheme()
                      ? Colors.grey[400]
                      : Colors.black,
                ),
              ),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              lable: "+ Add Task",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTaskPage()));
              })
        ],
      ),
    );
  }

  _appBar() {
    final bool isDarkTheme = ref.watch(appThemeProvider).getTheme();
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ref.watch(appThemeProvider.notifier).setTheme(!isDarkTheme);
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: isDarkTheme
                  ? "Acticated Light Theme"
                  : "Acticated Dark Theme");
          notifyHelper.scheduledNotification();
        },
        child: Icon(
            isDarkTheme ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 20,
            color: isDarkTheme ? Colors.white : Colors.black),
      ),
      actions: [
        Icon(Icons.person,
            size: 20, color: isDarkTheme ? Colors.white : Colors.black),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }
}
