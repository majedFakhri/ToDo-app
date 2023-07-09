import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_bloc/bloc/states/tasks_states.dart';
import 'package:todo_app_bloc/models/task_model.dart';
import 'package:todo_app_bloc/pages/done_page.dart';
import 'package:todo_app_bloc/pages/home_page.dart';
import 'package:todo_app_bloc/utils/ui_state_enum.dart';

class TasksCubit extends Cubit<TasksStates> {
  ///init cubit

  TasksCubit(this.prefs) : super(TasksInitialStates());

  static TasksCubit get(context) => BlocProvider.of(context);

  final SharedPreferences prefs;

  /// declare shared vars
  List screensList = [const HomePage(), DonePage()];
  List<TaskModel> tasksList = [];
  List<TaskModel> doneList = [];
  List<TaskModel> allTask = [];
  List<TaskModel> todayTask = [];
  List<TaskModel> thisMonthTask = [];
  List<TaskModel> thisYearTask = [];
  TextEditingController timeController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isDone = false;
  String object = "";
  DateTime date = DateTime.now();
  UIStateEnum uiState = UIStateEnum.add;
  int currentIndex = -1;
  int currentIndexForNavBar = 0;
  // int remainHoursTime = 0;

  ///declare ui events
  void ChangeIndexForNavBar(int index) {
    currentIndexForNavBar = index;

    emit(RefreshTasksUIState());
  }

  void changeIsDoneEvent(bool val) {
    isDone = val;
    emit(RefreshTasksUIState());
  }

  void clearFormEvent() {
    isDone = false;
    titleController.text = '';
    descController.text = '';
    object = '';
    dateTimeController.text = '';
    timeController.text = '';
    uiState = UIStateEnum.add;
    emit(RefreshTasksUIState());
  }

  void fillFormEvent(TaskModel taskModel, int index) {
    isDone = taskModel.isDone;
    titleController.text = taskModel.title;
    descController.text = taskModel.description ?? "";
    object = taskModel.object ?? "";
    dateTimeController.text = taskModel.datetime;
    timeController.text = taskModel.time;
    uiState = UIStateEnum.edit;
    currentIndex = index;
    emit(RefreshTasksUIState());
  }

  Future<void> addNewTaskEvent() async {
    TaskModel tm = TaskModel(
      title: titleController.text.trim(),
      isDone: isDone,
      description: descController.text.trim(),
      object: object,
      datetime: dateTimeController.text,
      time: timeController.text,
    );
    tasksList.add(tm);
    currentIndex = -1;
    await saveData();
    emit(RefreshTasksUIState());
  }

  Future<void> deleteDoneTaskByInedexEvent(int index) async {
    doneList.remove(doneList[index]);
    await saveData();
    emit(RefreshTasksUIState());
    getData();
  }

  Future<void> deleteTaskByInedexEvent(int index) async {
    tasksList.remove(tasksList[index]);
    await saveData();
    emit(RefreshTasksUIState());
    getData();
  }

  Future<void> editTaskEvent() async {
    if (currentIndex != -1) {
      tasksList[currentIndex].title = titleController.text.trim();
      tasksList[currentIndex].description =
          descController.text.trim() == "" ? null : descController.text.trim();
      tasksList[currentIndex].isDone = isDone;
      tasksList[currentIndex].object = object == '' ? null : object;
      tasksList[currentIndex].datetime = dateTimeController.text;
      tasksList[currentIndex].time = timeController.text;
      await saveData();
      emit(RefreshTasksUIState());
    }
  }

  Future<void> changeIsDoneOnMainPageEvent(int index, bool val) async {
    if (val == true) {
      tasksList[index].isDone = val;
      doneList.add(tasksList[index]);
      tasksList.remove(tasksList[index]);
    } else {
      doneList[index].isDone = val;
      tasksList.add(doneList[index]);
      doneList.remove(doneList[index]);
    }

    await saveData();
    getData();
  }

  void clearAllTask() {
    tasksList = [];
    saveData();
    emit(RefreshTasksUIState());
  }

  void clearAllDoneTask() {
    doneList = [];
    saveData();
    emit(RefreshTasksUIState());
  }

  

  List<TaskModel> sortedTask() {
    for (var i = 0; i < tasksList.length; i++) {
      for (var j = 0; j < tasksList.length - 1; j++) {
        if (DateTime.parse(tasksList[j].datetime)
            .isAfter(DateTime.parse(tasksList[j + 1].datetime))) {
          TaskModel swap = tasksList[j];
          tasksList[j] = tasksList[j + 1];
          tasksList[j + 1] = swap;
        }
      }
    }
    // }

    return tasksList;
  }

  Container addSome() {
    if (tasksList.isEmpty) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add Some Task To Do',
                style: const TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,fontFamily: 'BackToSchool')),
                    SizedBox(height: 20,),
                    // Lottie.asset('assets/84339-arrow-down.json',height: 150,width:80)
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Container doSome() {
    if (doneList.isEmpty) {
      return Container(
        child: Text("You Didn't Done Any Tasks Lately!",
            style: const TextStyle(
                color: Colors.purpleAccent,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,fontFamily: 'BackToSchool')),
      );
    } else {
      return Container();
    }
  }

  
  // 

  Future<void> saveData() async {
    List<Map<String, dynamic>> tasksAsJson = [];
    List<String> tasksAsString = [];

    for (var element in tasksList) {
      tasksAsJson.add(element.toJson());
    }

    for (var element in tasksAsJson) {
      tasksAsString.add(jsonEncode(element));
    }
    bool res = await prefs.setStringList("tasks", tasksAsString);
    emit(RefreshTasksUIState());
  }

  void getData() {
    List<String> tasksAsString = [];
    List<Map<String, dynamic>> tasksAsJson = [];

    tasksList.clear();

    tasksAsString = prefs.getStringList("tasks") ?? [];

    for (var element in tasksAsString) {
      tasksAsJson.add(jsonDecode(element));
    }

    for (var element in tasksAsJson) {
      tasksList.add(TaskModel.fromJson(element));
    }
    emit(RefreshTasksUIState());
  }
}
