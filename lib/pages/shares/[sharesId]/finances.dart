import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/components/expense/pinboard_card.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Map<String, Post> posts = {};

  _loadPosts() async {
    var response = await Api.of(context)
        .pb
        .collection('posts')
        .getList(filter: "share = '${widget.shareId}'");

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
      final post = Post.fromRecordModel(event.record!);
      if (post.share != widget.shareId) {
        return;
      }

      if (event.action == 'create' || event.action == 'update') {
        _setPost(post);
      }
      if (event.action == 'delete') {
        _deletePost(post);
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
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.green[300],
          strokeWidth: 2.0,
          onRefresh: () => _loadPosts(),
          child: ListView.builder(
            itemCount: share.members.length,
            itemBuilder: (context, index) {
              var member = share.members.elementAt(index);

              var expenses = posts.values
                  .where((post) {
                    return post.type == 'expense';
                  })
                  .toList()
                  .map((p) => ExpenseData.fromJson(p.data));

              var memberExpenses = expenses.where((expense) {
                return expense.paidBy != member;
              }).toList();

              var toPay = memberExpenses.fold(0.0, (prev, expense) {
                return prev - (expense.amount / expense.paidFor.length);
              });

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: () async {
                      return Api.of(context)
                          .pb
                          .collection('users')
                          .getOne(member);
                    }(),
                    builder: (_, data) {
                      final member = data.data;
                      Widget avatar = const Icon(Icons.person, size: 50);

                      if (member != null &&
                          member.getStringValue("avatar") != "") {
                        final avatarUrl =
                            "${Api.url}/api/files/${member.collectionId}/${member.id}/${member.getStringValue("avatar")}";
                        avatar = Image.network(avatarUrl,
                            width: 50, height: 50, fit: BoxFit.cover);
                      }

                      if (member == null) {
                        avatar =
                            const Center(child: CircularProgressIndicator());
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          avatar,
                          Text(member?.getStringValue("name") ?? "",
                              style: const TextStyle(fontSize: 20)),
                          Text("${toPay.toString()}€",
                              style: const TextStyle(fontSize: 20)),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
