import 'package:dtnd/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'app_dialog.dart';

class LoginFirstCatalog extends StatelessWidget {
  const LoginFirstCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      icon: const Icon(Icons.warning_amber_rounded),
      title: Text(S.of(context).login_required),
      content: Text(S.of(context).login_to_continue),
      actions: [
        InkWell(
            onTap: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel)),
        InkWell(
            onTap: () => Navigator.of(context).pop(true),
            child: const Text("OK"))
      ],
    );
  }
}
