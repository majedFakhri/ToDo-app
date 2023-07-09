import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_bloc/bloc/cubits/tasks_cubit.dart';

import '../bloc/states/tasks_states.dart';
import '../utils/menu_item_enum.dart';

class DonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksStates>(
        listener: (context, state) {},
        builder: (context, state) {
          TasksCubit tasksCubit = TasksCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.done_outline_sharp,
                    size: 40,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Done',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        fontFamily: 'BackToSchool'),
                  ),
                ],
              ),
              centerTitle: true,
              elevation: 15,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<MenuItemAppBar>(
                    onSelected: (value) {
                      if (value == MenuItemAppBar.clear) {
                        if (tasksCubit.doneList.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Container(
                                padding: EdgeInsets.all(16),
                                height: 80,
                                decoration: BoxDecoration(
                                    color: Colors.purple[200],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Icon(
                                      Icons.error,
                                      color: Colors.white,
                                      size: 45,
                                    ),
                                    SizedBox(
                                      width: 48,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Add Some Task!",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("There's No Tasks to Delete",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ));
                        } else {
                          tasksCubit.clearAllDoneTask();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Container(
                                padding: EdgeInsets.all(16),
                                height: 80,
                                decoration: BoxDecoration(
                                    color: Colors.purple[200],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Icon(
                                      Icons.error,
                                      color: Colors.white,
                                      size: 45,
                                    ),
                                    SizedBox(
                                      width: 48,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "All Tasks Deleted",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ));
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        child: Text('Clear'),
                        value: MenuItemAppBar.clear,
                      ),
                    ],
                  ),
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: tasksCubit.currentIndexForNavBar,
              selectedFontSize: 20.0,
              elevation: 15.0,
              onTap: (index) {
                tasksCubit.ChangeIndexForNavBar(index);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => tasksCubit.screensList[index],
                ));
              },
              items: [
                const BottomNavigationBarItem(
                  icon: const Icon(Icons.table_rows_sharp),
                  label: 'Tasks',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: 'Done',
                ),
              ],
            ),
            body: SafeArea(
              child: Stack(children: [
                Center(
                  child: tasksCubit.doSome(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.separated(
                    itemCount: tasksCubit.doneList.length,
                    itemBuilder: (context, index) => Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.transparent,
                            onPressed: ((context) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text(
                                    'Are You Sure?',
                                    style: TextStyle(
                                      color: Colors.purpleAccent,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await tasksCubit
                                              .deleteTaskByInedexEvent(index);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes',
                                            style: TextStyle(
                                              color: Colors.purpleAccent,
                                            ))),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('No',
                                            style: TextStyle(
                                              color: Colors.purpleAccent,
                                            )))
                                  ],
                                ),
                              );
                            }),
                            icon: Icons.delete,
                            foregroundColor: Colors.purple,
                            label: 'Delete',
                          )
                        ],
                      ),
                      child: Container(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          tileColor: Colors.purple[200],
                          textColor: Colors.white,
                          iconColor: Colors.purple,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.purple,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          tasksCubit.doneList[index].time,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          tasksCubit.doneList[index].datetime,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 270,
                                      child: Center(
                                        child: Text(
                                          tasksCubit.doneList[index].title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 270,
                                      child: Center(
                                        child: Text(
                                          tasksCubit.doneList[index]
                                                  .description ??
                                              "",
                                          // softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: Checkbox(
                            value: tasksCubit.doneList[index].isDone,
                            onChanged: (val) {
                              tasksCubit.changeIsDoneOnMainPageEvent(
                                  index, val ?? false);
                            },
                            fillColor: MaterialStateProperty.all(Colors.purple),
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 0.0,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 3.0,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          );
        });
  }
}
