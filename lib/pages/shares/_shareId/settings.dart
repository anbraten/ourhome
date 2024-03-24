import 'package:flutter/material.dart';
import 'package:ourhome/components/layout/share_scaffold.dart';
import 'package:ourhome/states/app_state.dart';

class ShareSettingsScreen extends StatefulWidget {
  final String shareId;
  const ShareSettingsScreen({super.key, required this.shareId});

  @override
  State<ShareSettingsScreen> createState() => _ShareSettingsScreenState();
}

class _ShareSettingsScreenState extends State<ShareSettingsScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    var appState = AppState.of(context);
    var members = appState.shareMembers;
    return ShareScaffold(
      shareId: widget.shareId,
      bodyBuilder: (share) => Padding(
        padding: const EdgeInsets.all(1),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.green[300],
          strokeWidth: 2.0,
          onRefresh: () => appState.loadShare(widget.shareId),
          child: ListView.builder(
            itemCount: members?.length,
            itemBuilder: (context, index) {
              var member = members?.elementAt(index);

              Widget avatar = member?.avatarWidget ??
                  const Center(child: CircularProgressIndicator());

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      avatar,
                      Text(member?.name ?? "",
                          style: const TextStyle(fontSize: 20)),
                    ],
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
