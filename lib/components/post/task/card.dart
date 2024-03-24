import 'package:flutter/material.dart';
import 'package:ourhome/components/post/task/types.dart';
import 'package:ourhome/components/post/types.dart';
import 'package:ourhome/states/app_state.dart';
import 'package:ourhome/types/post.dart';

class TaskCard extends StatelessWidget {
  final Post post;
  final TaskData taskData;

  const TaskCard({super.key, required this.post, required this.taskData});

  factory TaskCard.fromPost(Post post) {
    return TaskCard(
      post: post,
      taskData: TaskData.fromJson(post.data),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = AppState.of(context);
    var author = appState.shareMembers
        ?.firstWhere((element) => element.id == post.authorId);

    return Card(
      color: postTypes.firstWhere((element) => element.type == post.type).color,
      child: ListTile(
        textColor: Colors.white,
        title: Text(author?.name ?? '---'),
        subtitle: Text(taskData.tasks
            .map((e) => "${e.completed ? '[x]' : '[ ]'} ${e.title}")
            .join('\n')),
      ),
    );
  }
}
