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

import '../models/task.dart';
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
                    print(task.toMap());
                    if (task.repeat == "Daily") {
                      DateTime date =
                          DateFormat.jm().parse(task.startTime.toString());

                      var myTime = DateFormat("HH:mm").format(date);
                      notifyHelper.scheduledNotification(
                        int.parse(myTime.toString().split(":")[0]),
                        int.parse(myTime.toString().split(":")[1]),
                        task,
                      );
                      print("MyTime is :$myTime");
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                              child: FadeInAnimation(
                                  child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ))));
                    }
                    if (task.date == DateFormat.yMd().format(_selectedDate)) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                              child: FadeInAnimation(
                                  child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ))));
                    } else {
                      return Container();
                    }
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

  _showBottomSheet(BuildContext context, Task task) {
    final bool isDarkTheme = ref.watch(appThemeProvider).getTheme();
    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        // backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                  color: isDarkTheme ? darkGreyClr : Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              height: task.isCompleted == 1
                  ? MediaQuery.of(context).size.height * 0.24
                  : MediaQuery.of(context).size.height * 0.32,
              child: Column(
                children: [
                  Container(
                    height: 6,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            isDarkTheme ? Colors.grey[600] : Colors.grey[300]),
                  ),
                  const Spacer(),
                  task.isCompleted == 1
                      ? Container()
                      : _bottomSheetButton(
                          context: context,
                          label: "Task Completed",
                          onTap: () {
                            ref.read(taskController).update(task);
                            ref.refresh(getTasksController.future);
                            Navigator.pop(context);
                          },
                          color: primaryClr),
                  _bottomSheetButton(
                    context: context,
                    label: "Delete Task",
                    onTap: () {
                      ref.read(taskController).delete(task);
                      ref.refresh(getTasksController.future);
                      Navigator.pop(context);
                    },
                    color: Colors.red[300]!,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _bottomSheetButton(
                      context: context,
                      label: "Close",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      color: Colors.red[300]!,
                      isClose: true),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        });
  }

  _bottomSheetButton({
    required BuildContext context,
    required String label,
    required Function()? onTap,
    required Color color,
    bool isClose = false,
  }) {
    final bool isDarkTheme = ref.watch(appThemeProvider).getTheme();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClose == true ? Colors.transparent : color,
          border: Border.all(
              color: isClose == true
                  ? isDarkTheme
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : color,
              width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
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
          setState(() {
            _selectedDate = date;
          });
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
          // notifyHelper.scheduledNotification();
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
