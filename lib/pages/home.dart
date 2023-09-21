import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/components/pinboard_cards/card.dart';
import 'package:ourhome/components/pinboard_cards/post.dart';
import 'package:ourhome/states/auth.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // await AuthState.of(context).logout();
              // AppRouter.router.go(PAGES.login.screenPath);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.blue,
          strokeWidth: 2.0,
          onRefresh: () => _loadPosts(),
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts.values.elementAt(index);
              return PinboardCard(post: post);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var user = AuthState.of(context).user;
            var shareId = "q3wx3fdcvo8zw1q"; // TODO: get share id
            await Api.of(context).pb.collection('posts').create(body: {
              'type': 'expense',
              'share': shareId,
              'author': user?.id,
              'data':
                  '{"title": "Putzmittel", "date": "2023-09-21T07:03:45.292Z", "amount": 10, "currency": "EUR", "paidBy": "Ich", "paidFor": ["Ich", "Du"]}',
            });
          }),
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
            label: 'Pinnwand',
          ),
          NavigationDestination(
            icon: Icon(Icons.money),
            label: 'Finanzen',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
      ),
    );
  }
}
