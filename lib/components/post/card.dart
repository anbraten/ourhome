import 'package:flutter/material.dart';
import 'package:ourhome/components/post/types.dart';
import 'package:ourhome/states/app_state.dart';
import 'package:ourhome/types/post.dart';

class PinboardCard extends StatelessWidget {
  final Post post;

  const PinboardCard({Key? key, required this.post});

  @override
  Widget build(BuildContext context) {
    var postType = postTypes.firstWhere((element) => element.type == post.type);

    if (postType.createCard != null) {
      return postType.createCard!(post);
    }

    var appState = AppState.of(context);
    var author = appState.shareMembers
        ?.firstWhere((element) => element.id == post.authorId);

    return Card(
      child: ListTile(
        textColor: Colors.white,
        title: Text('${post.type} by ${author?.name ?? '---'} ${post.id}'),
        subtitle: Text(post.data.toString()),
      ),
    );
  }
}
