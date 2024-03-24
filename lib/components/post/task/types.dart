class Task {
  final String title;
  final bool completed;

  Task({
    required this.title,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      completed: json['completed'],
    );
  }

  toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}

class TaskData {
  final String assignedTo;
  final List<Task> tasks;

  TaskData({
    required this.assignedTo,
    required this.tasks,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      assignedTo: json['assignedTo'],
      tasks: json['tasks'].map<Task>((task) => Task.fromJson(task)).toList(),
    );
  }

  toJson() {
    return {
      'assignedTo': assignedTo,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}
