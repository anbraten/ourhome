import 'package:flutter/material.dart';
import 'package:ourhome/routes/router.dart';
import 'package:ourhome/states/app_state.dart';
import 'package:ourhome/types/share.dart';

class ShareScaffold extends StatelessWidget {
  final String shareId;
  final Widget Function(Share) bodyBuilder;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  const ShareScaffold({
    super.key,
    required this.shareId,
    required this.bodyBuilder,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Share>(
      future: AppState.of(context).loadShare(shareId),
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
            actions: actions,
          ),
          body: bodyBuilder(share),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              AppRouter.router.go(routes[index]);
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
