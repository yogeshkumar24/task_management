class TaskModel {
  String? sId;
  String? title;
  String? description;
  String? dueDate;
  String? priority;
  String? selectedStatus;
  String? assignedUser;
  int? iV;

  TaskModel(
      {this.sId,
        this.title,
        this.description,
        this.dueDate,
        this.priority,
        this.selectedStatus,
        this.assignedUser,
        this.iV});

  TaskModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    dueDate = json['dueDate'];
    priority = json['priority'];
    selectedStatus = json['selectedStatus'];
    assignedUser = json['assignedUser'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['dueDate'] = dueDate;
    data['priority'] = priority;
    data['selectedStatus'] = selectedStatus;
    data['assignedUser'] = assignedUser;
    data['__v'] = iV;
    return data;
  }
}
