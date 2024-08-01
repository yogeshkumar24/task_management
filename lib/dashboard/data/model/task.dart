// class Task {
//   String? id;
//   String? title;
//   String? description;
//   String? dueDate;
//   String? priority;
//   String? selectedStatus;
//   String? assignedUser;
//
//   Task({
//     this.id,
//     this.title,
//     this.description,
//     this.dueDate,
//     this.priority,
//     this.selectedStatus,
//     this.assignedUser,
//   });
//
//   // Method to create a Task object from JSON
//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       title: json['title'] as String?,
//       description: json['description'] as String?,
//       dueDate: json['dueDate'] as String?,
//       priority: json['priority'] as String?,
//       selectedStatus: json['selectedStatus'] as String?,
//       assignedUser: json['assignedUser'] as String?,
//     );
//   }
//
//   // Method to convert a Task object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'dueDate': dueDate,
//       'priority': priority,
//       'selectedStatus': selectedStatus,
//       'assignedUser': assignedUser,
//     };
//   }
// }
