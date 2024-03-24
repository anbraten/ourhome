import 'package:flutter/material.dart';
import 'package:ourhome/components/note/types.dart';
import 'package:ourhome/states/app_state.dart';
import 'package:ourhome/types/post_type.dart';
import 'package:ourhome/types/post.dart';

class NoteCard extends StatelessWidget {
  final Post post;
  final NoteData noteData;

  const NoteCard({super.key, required this.post, required this.noteData});

  factory NoteCard.fromPost(Post post) {
    return NoteCard(
      post: post,
      noteData: NoteData.fromJson(post.data),
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
        subtitle: Text(noteData.message),
      ),
    );
  }
}
