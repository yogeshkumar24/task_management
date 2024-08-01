import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/dashboard/data/model/task_model.dart';
import 'package:task_management/dashboard/ui/create_task_screen.dart';
import 'package:task_management/dashboard/view_model/task_provider.dart';
import 'package:task_management/shared/constants/string_const.dart';
import 'package:task_management/shared/widget/custom_app_bar.dart';

class TaskDetails extends StatelessWidget {
  TaskModel taskModel;

  TaskDetails({required this.taskModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: StringConstant.taskDetails,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskModel.title!),
            Text(taskModel.description!),
            Text("Assigned to: ${taskModel.assignedUser}"),
            Text("Due Date: ${taskModel.dueDate!.substring(0, 10)}"),
            Text("Priority: ${taskModel.priority}"),
            Text("Status: ${taskModel.selectedStatus}"),
            const SizedBox(
              height: 20,
            ),
            taskModel.selectedStatus == "Done"
                ? const Text("This Task is Complete")
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              isUpdate: true,
                              taskModel: taskModel,
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(StringConstant.editTask),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Consumer<TaskProvider>(
              builder: (BuildContext context, taskProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool value = await taskProvider.deleteTask(
                          context, taskModel.sId!);
                      if (value) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: taskProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(StringConstant.deleteTask),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
