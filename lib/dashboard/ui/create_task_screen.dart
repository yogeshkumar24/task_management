import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/dashboard/data/model/task_model.dart';
import 'package:task_management/dashboard/view_model/task_provider.dart';
import 'package:task_management/profile/data/model/user_model.dart';
import 'package:task_management/profile/view_model/profile_provider.dart';
import 'package:task_management/shared/shared.dart';
import 'package:task_management/shared/validators.dart';
import 'package:task_management/shared/widget/custom_app_bar.dart';
import 'package:task_management/shared/widget/custom_text_field.dart';

class CreateTaskScreen extends StatefulWidget {
  TaskModel? taskModel;
  bool isUpdate = false;

  CreateTaskScreen({this.taskModel, this.isUpdate = false, super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();
  final assignController = TextEditingController();

  @override
  void initState() {
    setValues();
    super.initState();
  }

  setValues() {
    if (widget.isUpdate) {
      TaskProvider provider = Provider.of<TaskProvider>(context, listen: false);
      titleController.text = widget.taskModel!.title ?? "";
      descriptionController.text = widget.taskModel!.description ?? "";
      dueDateController.text = widget.taskModel!.dueDate ?? "";
      //assignController.text = widget.taskModel!.assignedUser ?? "";
      provider.assignedUser = widget.taskModel!.assignedUser ?? "";
      provider.selectedPriority =
          widget.taskModel!.priority ?? provider.selectedPriority;
      provider.selectedStatus =
          widget.taskModel!.selectedStatus ?? provider.selectedStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: widget.isUpdate
              ? StringConstant.editTask
              : StringConstant.createTask,
        ),
        body: Consumer<TaskProvider>(
            builder: (BuildContext context, taskProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      StringConstant.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: titleController,
                      validator: (value) {
                        return Validator.nameValidator(
                            value, StringConstant.enterTitle);
                      },
                      hintText: StringConstant.title,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      StringConstant.description,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: descriptionController,
                      validator: (value) {
                        return Validator.nameValidator(
                            value, StringConstant.description);
                      },
                      hintText: StringConstant.description,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Due Date',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      readOnly: true,
                      controller: dueDateController,
                      hintText: 'YYYY-MM-DD',
                      onTap: () async {
                        await taskProvider.selectDate(context);
                        dueDateController.text =
                            taskProvider.selectedDate.toString();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a due date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Priority',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: taskProvider.selectedPriority,
                        items: <String>['Low', 'Medium', 'High']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: const Text('Select Priority'),
                        onChanged: (String? newValue) async {
                          if (newValue != null) {
                            await taskProvider.setPriority(newValue);
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                    const SizedBox(height: 20),
                    const Text(
                      StringConstant.assignUser,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Consumer<ProfileProvider>(builder:
                        (BuildContext context, profileProvider, child) {
                      return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: taskProvider.assignedUser,
                          items: profileProvider.userList.map((User user) {
                            return DropdownMenuItem<String>(
                              value: user.email,
                              child: Text(user.email ?? ''),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            taskProvider.updateUser(newValue);
                          },
                          hint: const Text(StringConstant.assignUser),
                          validator: (value) {
                            return Validator.nameValidator(
                                value, StringConstant.assignUser);
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))));
                    }),
                    const SizedBox(height: 20),
                    const Text(
                      StringConstant.status,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: taskProvider.selectedStatus,
                        items: <String>['To-Do', 'In Progress', 'Done']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          taskProvider.selectStatus(newValue!);
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            TaskModel newTask = TaskModel(
                              title: titleController.text,
                              description: descriptionController.text,
                              dueDate: dueDateController.text,
                              priority: taskProvider.selectedPriority,
                              selectedStatus: taskProvider.selectedStatus,
                              assignedUser: taskProvider.assignedUser,
                            );
                            if (widget.isUpdate) {
                              newTask.sId = widget.taskModel!.sId;
                              bool value = await taskProvider.updateTask(
                                  context, newTask, widget.taskModel!.sId!);
                              if (value) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              await taskProvider.createTask(context, newTask);
                            }
                          }
                        },
                        child: taskProvider.isLoading
                            ? const CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(widget.isUpdate
                                    ? StringConstant.editTask
                                    : StringConstant.createTask),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
