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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
  List<Map> postTypes = [
    {
      "icon": Icons.home,
      "color": Colors.green,
      "text": "Horst",
    },
    {
      "icon": Icons.settings,
      "color": Colors.blueGrey,
      "text": "Horst",
    },
    {
      "icon": Icons.location_city,
      "color": Colors.purple,
      "text": "Horst",
    },
    {
      "icon": Icons.home,
      "color": Colors.green,
      "text": "Horst",
    },
    {
      "icon": Icons.settings,
      "color": Colors.blueGrey,
      "text": "Horst",
    },
    {
      "icon": Icons.location_city,
      "color": Colors.purple,
      "text": "Horst",
    },
    {
      "icon": Icons.home,
      "color": Colors.green,
      "text": "Horst",
    },
    {
      "icon": Icons.settings,
      "color": Colors.blueGrey,
      "text": "Horst",
    },
    {
      "icon": Icons.location_city,
      "color": Colors.purple,
      "text": "Horst",
    },
  ];

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
                shrinkWrap: false,
                children: List.from(postTypes)
                    .map(
                      (e) => TextButton(
                        onPressed: () {
                          animationController!.reverse();
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
                            const Text(
                              "Horst",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
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
        curve: Interval(0.2, 1.0, curve: Curves.ease)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Home'),
        backgroundColor: Colors.greenAccent,
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
          backgroundColor: Colors.greenAccent,
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
        key: globalKey,
        onPressed: () async {
          var user = AuthState.of(context).user;
          var shareId = "q3wx3fdcvo8zw1q"; // TODO: get share id
          // await Api.of(context).pb.collection('posts').create(body: {
          //   'type': 'expense',
          //   'share': shareId,
          //   'author': user?.id,
          //   'data':
          //       '{"title": "Putzmittel", "date": "2023-09-21T07:03:45.292Z", "amount": 10, "currency": "EUR", "paidBy": "Ich", "paidFor": ["Ich", "Du"]}',
          // });
          _showOverLay();
        },
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
