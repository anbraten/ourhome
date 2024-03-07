import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/components/layout/share_scaffold.dart';
import 'package:ourhome/types/post.dart';
import 'package:pocketbase/pocketbase.dart';

class ShareFinancesScreen extends StatefulWidget {
  final String shareId;
  const ShareFinancesScreen({super.key, required this.shareId});

  @override
  State<ShareFinancesScreen> createState() => _ShareFinancesScreenState();
}

class _ShareFinancesScreenState extends State<ShareFinancesScreen> {
  Map<String, Post> posts = {};

  _loadPosts() async {
    var response = await Api.of(context).pb.collection('posts').getList();
    var data = response.items;
    Map<String, Post> posts = {};

    for (var post in data) {
      posts[post.id] = Post.fromRecordModel(post);
    }

    setState(() {
      this.posts = posts;
    });
  }

  _setPost(Post post) {
    setState(() {
      posts.update(post.id, (value) => post, ifAbsent: () => post);
    });
  }

  _deletePost(Post post) {
    setState(() {
      posts.remove(post.id);
    });
  }

  @override
  initState() {
    super.initState();
    _loadPosts();

    var api = Api.of(context);
    api.pb.collection('posts').subscribe('*', (RecordSubscriptionEvent event) {
      if (event.record == null) {
        throw Exception('Record is null');
      }
      if (event.action == 'create' || event.action == 'update') {
        _setPost(Post.fromRecordModel(event.record!));
      }
      if (event.action == 'delete') {
        _deletePost(Post.fromRecordModel(event.record!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShareScaffold(
      shareId: widget.shareId,
      bodyBuilder: (share) => Padding(
        padding: const EdgeInsets.all(1),
        child: RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.greenAccent,
          strokeWidth: 2.0,
          onRefresh: () => _loadPosts(),
          child: ListView.builder(
            itemCount: share.members.length,
            itemBuilder: (context, index) {
              var member = share.members.elementAt(index);
              return Text(member);
            },
          ),
        ),
      ),
    );
  }
}
