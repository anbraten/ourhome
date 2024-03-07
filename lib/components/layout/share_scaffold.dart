import 'package:flutter/material.dart';
import 'package:ourhome/api.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/types/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareScaffold extends StatelessWidget {
  final String shareId;
  final Widget Function(Share) bodyBuilder;
  final List<Widget>? actions;
  const ShareScaffold({
    super.key,
    required this.shareId,
    required this.bodyBuilder,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Share>(
      future: () async {
        var response =
            await Api.of(context).pb.collection('shares').getOne(shareId);

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

        final routes = [
          '/shares/${share.id}',
          '/shares/${share.id}/finances',
          '/shares/${share.id}/settings',
        ];

        final r = AppRouter.router.routeInformationProvider.value.uri.path;
        var selectedIndex = routes.indexOf(r);
        if (selectedIndex == -1) {
          selectedIndex = 0;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(share.name),
            backgroundColor: Colors.greenAccent,
            actions: actions,
          ),
          body: bodyBuilder(share),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              AppRouter.router.replace(routes[index]);
            },
            selectedIndex: selectedIndex,
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
