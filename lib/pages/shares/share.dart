import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';

import 'package:ourhome/components/pinboard_cards/card.dart';
import 'package:ourhome/types/post.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/auth.dart';
import 'package:ourhome/types/share.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ourhome/components/expense/create.dart';
import 'package:ourhome/helpers/post_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  AnimationController? animationController;
  Animation<double>? animation;
  OverlayEntry? overlayEntry;
  GlobalKey globalKey = GlobalKey();

  _showOverLay() async {
    RenderBox? renderBox =
        globalKey.currentContext!.findRenderObject() as RenderBox?;
    Offset offset = renderBox!.localToGlobal(Offset.zero);

    OverlayState? overlayState = Overlay.of(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: screenHeight - offset.dy - renderBox.size.height,
        height: screenHeight * 0.3,
        left: 0,
        width: screenWidth,
        child: ScaleTransition(
          scale: animation!,
          child: Material(
            type: MaterialType.transparency,
            child: Card(
              shadowColor: Colors.transparent,
              color: Colors.grey,
              child: GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: List.from(postTypes)
                    .map(
                      (e) => TextButton(
                        onPressed: () async {
                          // TODO: run action for specific postType
                          var user = AuthState.of(context).user;
                          await Api.of(context)
                              .pb
                              .collection('posts')
                              .create(body: {
                            'type': 'expense',
                            'share': widget.shareId,
                            'author': user?.id,
                            'data':
                                '{"title": "Cleaning materials", "date": "2023-09-21T07:03:45.292Z", "amount": 10, "currency": "EUR", "paidBy": "Ich", "paidFor": ["Ich", "Du"]}',
                          });

                          await animationController!.reverse();
                          overlayEntry!.remove();
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: e["color"] as Color?,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                e["icon"] as IconData?,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            Text(
                              e["text"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
    animationController!.addListener(() {
      overlayState.setState(() {});
    });
    animationController!.forward();
    overlayState.insert(overlayEntry!);

    // await Future.delayed(const Duration(seconds: 5))
    //     .whenComplete(() => animationController!.reverse())
    //     .whenComplete(() => overlayEntry!.remove());
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
        return CreateEntry(shareId: widget.shareId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder<Share>(
      future: () async {
        var response = await Api.of(context)
            .pb
            .collection('shares')
            .getOne(widget.shareId);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('lastOpenedShare', response.id);

        return Share.fromRecordModel(response);
      }(),
      builder: (_, data) {
        final share = data.data;
        if (share == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(share.name),
            backgroundColor: Colors.greenAccent,
            actions: [
              IconButton(
                key: globalKey,
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showCreateDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await AuthState.of(context).logout();
                  AppRouter.router.go('/auth/login');
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(1),
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.white,
              backgroundColor: Colors.greenAccent,
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
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              // setState(() {
              //   currentPageIndex = index;
              // });
            },
            // selectedIndex: currentPageIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.push_pin),
                label: 'Pinboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.money),
                label: 'Finances',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}