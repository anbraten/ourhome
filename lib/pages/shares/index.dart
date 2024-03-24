import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/auth.dart';
import 'package:ourhome/types/share.dart';
import 'package:pocketbase/pocketbase.dart';

class SharesListScreen extends StatefulWidget {
  const SharesListScreen({super.key});

  @override
  State<SharesListScreen> createState() => _SharesListState();
}

class _SharesListState extends State<SharesListScreen>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Map<String, Share> shares = {};

  _loadShares() async {
    var response = await Api.of(context).pb.collection('shares').getList();
    var data = response.items;
    Map<String, Share> shares = {};

    for (var share in data) {
      shares[share.id] = Share.fromRecordModel(share);
    }

    setState(() {
      this.shares = shares;
    });
  }

  _setShare(Share share) {
    setState(() {
      shares.update(share.id, (value) => share, ifAbsent: () => share);
    });
  }

  _deleteShare(Share share) {
    setState(() {
      shares.remove(share.id);
    });
  }

  @override
  initState() {
    super.initState();
    _loadShares();

    var api = Api.of(context);
    api.pb.collection('shares').subscribe('*', (RecordSubscriptionEvent event) {
      if (event.record == null) {
        throw Exception('Record is null');
      }
      if (event.action == 'create' || event.action == 'update') {
        _setShare(Share.fromRecordModel(event.record!));
      }
      if (event.action == 'delete') {
        _deleteShare(Share.fromRecordModel(event.record!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shares'),
        actions: [
          PopupMenuButton<String>(onSelected: (String choice) async {
            if (choice == 'Logout') {
              await AuthState.of(context).logout();
              AppRouter.router.go('/auth/login');
            }
          }, itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  )),
            ];
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add share',
        shape: const CircleBorder(),
        onPressed: () {
          AppRouter.router.go('/shares/create');
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.green[300],
          strokeWidth: 2.0,
          onRefresh: () => _loadShares(),
          child: ListView.builder(
            itemCount: shares.length,
            itemBuilder: (context, index) {
              var share = shares.values.elementAt(index);
              return GestureDetector(
                onTap: () {
                  AppRouter.router.go('/shares/${share.id}');
                },
                child: Card(
                  child: ListTile(
                    title: Text(share.name),
                    subtitle: Text('${share.members.length} members'),
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
