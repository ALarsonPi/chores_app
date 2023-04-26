import 'package:flutter/material.dart';

class RoleInfoWidget extends StatelessWidget {
  const RoleInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.preview_rounded),
          iconColor: Theme.of(context).colorScheme.primary,
          title: const Text("Viewer"),
          subtitle: const Text("Can see chart, but can't change chart"),
        ),
        ListTile(
          leading: const Icon(Icons.edit_document),
          iconColor: Theme.of(context).colorScheme.primary,
          title: const Text("Editor"),
          subtitle: const Text("Can edit chart, but can't add other users"),
        ),
        ListTile(
          leading: const Icon(Icons.add_business_rounded),
          iconColor: Theme.of(context).colorScheme.primary,
          title: const Text("Owner"),
          subtitle:
              const Text("Can edit chart, add more users, and delete chart"),
        ),
      ],
    );
  }
}
