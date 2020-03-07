import 'package:flutter/material.dart';
import 'package:todo_app/helpers/colors.dart';
import 'package:todo_app/helpers/utils.dart';
import 'package:todo_app/services/firestore.dart';
import 'package:todo_app/views/widgets/add_task_fb.dart';
import 'package:todo_app/views/widgets/date_picker_timeline/date_picker_timeline.dart';
import 'package:todo_app/views/widgets/day_task.dart';
import 'package:todo_app/views/widgets/task_list.dart';

class CompletedTask extends StatefulWidget {
  final String title;

  const CompletedTask({Key key, @required this.title}) : super(key: key);

  @override
  _AllTaskState createState() => _AllTaskState();
}

class _AllTaskState extends State<CompletedTask> {
  final pageStatus = TaskPageStatus.completed;
  DateTime _selectedValue = DateTime.now();
  bool isFilterSelected = false;

  @override
  Widget build(BuildContext context) {
    Stream taskStream = FirestoreService().getTaskByStatus(
      'c9ad90ca-7071-41c4-bb42-7945ea330a3a',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primary,
        leading: Icon(Icons.event_note),
        actions: <Widget>[
          Theme(
            data: ThemeData(
              accentColor: Colors.transparent,
            ),
            child: FloatingActionButton(
              mini: true,
              elevation: 0,
              tooltip: 'Filter by date',
              child: Icon(Icons.date_range, size: 22),
              backgroundColor:
                  isFilterSelected ? AppColors.primaryAccent : null,
              onPressed: () {
                setState(() {
                  isFilterSelected = !isFilterSelected;
                });
              },
            ),
          ),
          IconButton(
            tooltip: 'Mark All as done',
            icon: Icon(Icons.playlist_add_check),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Visibility(
              maintainSize: false,
              maintainAnimation: true,
              maintainState: true,
              visible: isFilterSelected,
              child: Column(
                children: <Widget>[
                  DatePickerTimeline(
                    _selectedValue,
                    onDateChange: (date) {
                      setState(() {
                        _selectedValue = date;
                      });
                    },
                  ),
                  Divider(color: AppColors.darkGrey),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DayTasksText(),
                    AddTaskFloatingButton(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 6.0),
                  height: MediaQuery.of(context).size.height -
                      (4 * kBottomNavigationBarHeight),
                  child: TaskList(
                    taskStream: taskStream,
                    pageStatus: pageStatus,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
