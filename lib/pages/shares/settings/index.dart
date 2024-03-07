import 'package:flutter/material.dart';
import 'package:ourhome/components/layout/share_scaffold.dart';

class ShareSettingsScreen extends StatefulWidget {
  final String shareId;
  const ShareSettingsScreen({super.key, required this.shareId});

  @override
  State<ShareSettingsScreen> createState() => _ShareSettingsScreenState();
}

class _ShareSettingsScreenState extends State<ShareSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ShareScaffold(
      shareId: widget.shareId,
      bodyBuilder: (share) => const Text('settings'),
    );
  }
}
