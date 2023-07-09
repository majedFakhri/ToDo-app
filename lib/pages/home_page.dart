import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_bloc/bloc/cubits/tasks_cubit.dart';
import 'package:todo_app_bloc/bloc/states/tasks_states.dart';
import 'package:todo_app_bloc/pages/task_details_page.dart';

import '../utils/menu_item_enum.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TasksCubit tasksCubit = TasksCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton<MenuItemAppBar>(
                  onSelected: (value) {
                    if (value == MenuItemAppBar.clear) {
                      if (tasksCubit.tasksList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Container(
                              padding: const EdgeInsets.all(16),
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.purple[200],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Add Some Task!",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text("There's No Tasks to Delete",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
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
                        tasksCubit.clearAllTask();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Container(
                            
                              padding: const EdgeInsets.all(16),
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.purple[200],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  const Icon(
                                    Icons.error,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  ),
                                  const Expanded(
                                    child: const Text(
                                      "All Tasks Deleted",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                      value: MenuItemAppBar.clear,
                      child: Text('Clear',
                          style: TextStyle(
                            color: Colors.purpleAccent,
                          )),
                    ),
                  ],
                ),
              )
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.checklist_rtl_outlined,
                  size: 40,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text("ToDos",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        fontFamily: 'BackToSchool')),
              ],
            ),
            centerTitle: true,
            elevation: 15,
          ),
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              tasksCubit.clearFormEvent();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailsPage(),
                  ));
            },
            backgroundColor: Colors.purple,
            child: const Icon(Icons.add_card),
          ),
          body: SafeArea(
            child: Stack(children: [
              Center(
                child: tasksCubit.addSome(),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView.separated(
                  
                  itemCount: tasksCubit.sortedTask().length,
                  itemBuilder: (context, index) => Slidable(
                    
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor:  Colors.transparent,
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
                        onTap: () {
                          tasksCubit.fillFormEvent(
                              tasksCubit.tasksList[index], index);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailsPage(),
                              ));
                        },
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
                                        tasksCubit.tasksList[index].datetime,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        tasksCubit.tasksList[index].time,
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
                                    width: 200,
                                    child: Center(
                                      child: Text(
                                        tasksCubit.tasksList[index].title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: Center(
                                      child: Text(
                                          tasksCubit.tasksList[index]
                                                  .description ??
                                              "",
                                          // softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                          ],

                        ),
                        trailing: Checkbox(
                              value: tasksCubit.tasksList[index].isDone,
                              onChanged: (val) {
                                tasksCubit.changeIsDoneOnMainPageEvent(
                                    index, val ?? false);
                              },
                              fillColor:
                                  MaterialStateProperty.all(Colors.purple),
                            ),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) {
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
                icon: Icon(Icons.table_rows_sharp),
                label: 'Tasks',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: 'Done',
              ),
            ],
          ),
        );
      },
    );
  }
}
