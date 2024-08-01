import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/dashboard/data/model/task_model.dart';
import 'package:task_management/dashboard/ui/create_task_screen.dart';
import 'package:task_management/dashboard/ui/task_details.dart';
import 'package:task_management/dashboard/view_model/task_provider.dart';
import 'package:task_management/profile/ui/profile.dart';
import 'package:task_management/shared/constants/string_const.dart';
import 'package:task_management/shared/log.dart';
import 'package:task_management/shared/widget/custom_app_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    Future.delayed(Duration.zero, () async {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTaskScreen(),
              ));
        },
      ),
      appBar: CustomAppBar(
        title: StringConstant.allTask,
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ));
            },
            icon: const Icon(Icons.person),
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Consumer<TaskProvider>(builder: (context, taskProvider, child) {
            return taskProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : taskProvider.getTaskList.isEmpty
                    ? const Center(
                        child: Text(StringConstant.addNewTask),
                      )
                    : ListView.separated(
                        itemCount: taskProvider.getTaskList.length,
                        itemBuilder: (context, index) {
                          TaskModel taskModel = taskProvider.getTaskList[index];
                          return InkWell(
                            onTap: () {
                              Log.d(taskModel.sId);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetails(taskModel: taskModel),
                                  ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(taskModel.title ?? "No title"),
                                Text(taskModel.description ?? 'No Description'),
                                Text(
                                    "Assigned to: ${taskModel.assignedUser ?? 'Unassigned'}"),
                                Text(
                                    "Due Date: ${taskModel.dueDate!.substring(0, 10)}"),
                                Text(
                                    "Priority: ${taskModel.priority ?? 'No Priority'}"),
                                Text(
                                    "Status: ${taskModel.selectedStatus ?? 'No Status'}"),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      );
          })),
    );
  }
}
