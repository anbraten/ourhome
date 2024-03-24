import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/components/layout/share_scaffold.dart';
import 'package:ourhome/components/pinboard_cards/card.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/types/post.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ourhome/types/post_type.dart';

class ShareScreen extends StatefulWidget {
  final String shareId;
  const ShareScreen({super.key, required this.shareId});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen>
    with TickerProviderStateMixin {
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

  AnimationController? animationController;
  Animation<double>? animation;
  OverlayEntry? overlayEntry;
  GlobalKey globalKey = GlobalKey();

  @override
  initState() {
    super.initState();
    _loadPosts();

    var api = Api.of(context);
    api.pb.collection('posts').subscribe('*', (RecordSubscriptionEvent event) {
      if (event.record == null) {
        return;
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

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.2, 1.0, curve: Curves.ease)));
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreatePost(shareId: widget.shareId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ShareScaffold(
      shareId: widget.shareId,
      actions: [
        PopupMenuButton<String>(
          onSelected: (String choice) {},
          itemBuilder: (BuildContext context) {
            return {'Logout', 'Settings'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add post',
        shape: const CircleBorder(),
        onPressed: () {
          _showCreateDialog(context);
        },
        child: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
      ),
      bodyBuilder: (share) => Padding(
        padding: const EdgeInsets.all(1),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.green[300],
          strokeWidth: 2.0,
          onRefresh: () => _loadPosts(),
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts.values.elementAt(index);

              return GestureDetector(
                onLongPressStart: (LongPressStartDetails details) {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      size.width - details.globalPosition.dx,
                      size.height - details.globalPosition.dy,
                    ),
                    items: <PopupMenuEntry>[
                      PopupMenuItem(
                        value: index,
                        onTap: () async {
                          await Api.of(context)
                              .pb
                              .collection('posts')
                              .delete(post.id);
                        },
                        child: const ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        ),
                      )
                    ],
                  );
                },
                child: PinboardCard(post: post),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CreatePost extends StatelessWidget {
  final String shareId;

  const CreatePost({super.key, required this.shareId});

  @override
  Widget build(BuildContext context) => Dialog(
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create new',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            AppRouter.router.pop();
                          },
                        ),
                      ]),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Adjust the number of items per row
                  ),
                  itemCount: postTypes.length,
                  itemBuilder: (context, index) {
                    var e = postTypes[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: e.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(e.icon, size: 48, color: Colors.white),
                            const SizedBox(height: 8),
                            Text(
                              e.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        onPressed: () {
                          var url = '/shares/$shareId/create/${e.type}';
                          AppRouter.router
                              .pop(); // Close the dialog before navigating
                          AppRouter.router.go(url);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
