import 'package:flutter/material.dart';
import 'package:ourhome/components/post/types.dart';

class PostCreate extends StatelessWidget {
  final String postType;
  final String shareId;

  const PostCreate({Key? key, required this.postType, required this.shareId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var postType =
        postTypes.firstWhere((element) => element.type == this.postType);

    if (postType.createForm != null) {
      return postType.createForm!(key: key!, shareId: shareId);
    }

    return Scaffold(
      body: Center(
        child: Text('No form found for post type $postType'),
      ),
    );
  }
}
