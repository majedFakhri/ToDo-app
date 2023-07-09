import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_bloc/bloc/cubits/tasks_cubit.dart';
import 'package:todo_app_bloc/bloc/states/tasks_states.dart';
import 'package:todo_app_bloc/utils/ui_state_enum.dart';

class TaskDetailsPage extends StatelessWidget {
  TaskDetailsPage({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TasksCubit tasksCubit = TasksCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.event_note,
                  size: 40,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text("Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        fontFamily: 'BackToSchool')),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.purple,
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return "this field is required";
                      } else if (value == "") {
                        return "this field is required";
                      } else {
                        return null;
                      }
                    },
                    controller: tasksCubit.titleController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.purple[200]!, width: 0.5)),
                        hintText: 'Title:',
                        // prefix: Icon(Icons.title),
                        label: Text(
                          'Title',
                          style: TextStyle(color: Colors.purple[200]),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.purple[200]!, width: 0.5))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: tasksCubit.descController,
                    maxLines: 6,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.purple[200]!, width: 0.5)),
                        hintText: 'Description:',
                        // prefix: Icon(Icons.calendar_month),
                        label: Text(
                          'Description',
                          style: TextStyle(color: Colors.purple[200]),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.purple[200]!, width: 0.5))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return "this field is required";
                      } else if (value == "") {
                        return "this field is required";
                      } else {
                        return null;
                      }
                    },
                    controller: tasksCubit.dateTimeController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030));

                      if (pickeddate != null) {
                        tasksCubit.dateTimeController.text =
                            DateFormat('yyyy-MM-dd').format(pickeddate);
                      }
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.purple[200]!, width: 0.5)),
                        hintText: 'Date:',
                        // prefix: Icon(Icons.calendar_month),
                        label: Text(
                          'Date',
                          style: TextStyle(color: Colors.purple[200]),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.purple[200]!, width: 0.5))),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return "this field is required";
                      } else if (value == "") {
                        return "this field is required";
                      } else {
                        return null;
                      }
                    },
                    controller: tasksCubit.timeController,
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedtime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());

                      if (pickedtime != null) {
                        tasksCubit.timeController.text =
                            // '${pickedtime.hour}:${pickedtime.minute}';
                            tasksCubit.timeController.text =
                                pickedtime.format(context).toString();
                        // TimeFormat('yyyy-MM-dd').format(pickedtime);

                      }
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.purple[200]!, width: 0.5)),
                        hintText: 'Time:',
                        // prefix: Icon(Icons.calendar_month),
                        label: Text(
                          'Time',
                          style: TextStyle(color: Colors.purple[200]),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.purple[200]!, width: 0.5))),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (tasksCubit.uiState == UIStateEnum.add) {
                  await tasksCubit.addNewTaskEvent();
                } else {
                  await tasksCubit.editTaskEvent();
                }
                tasksCubit.getData();
                Navigator.pop(context);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.purple,
          ),
        );
      },
    );
  }
}
