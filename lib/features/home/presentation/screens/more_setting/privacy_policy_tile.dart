import 'package:avms/core/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyTile extends StatelessWidget {
  const PrivacyPolicyTile({super.key});

  static const policyUrl =
      'https://avms.egytwins.com/docs/privacy-policy.html';

  Future<void> _openPolicy(BuildContext context, bool arabic) async {
    var opened = false;
    try {
      opened = await launchUrl(Uri.parse(policyUrl),
          mode: LaunchMode.externalApplication);
    } catch (_) {
      // Keep the policy address accessible when no browser can open it.
    }
    if (opened || !context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(arabic ? 'سياسة الخصوصية' : 'Privacy policy'),
        content: const SelectableText(policyUrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(arabic ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arabic = Config.localeCode == 'ar';
    return ListTile(
      leading: const Icon(Icons.privacy_tip_outlined),
      title: Text(arabic ? 'سياسة الخصوصية' : 'Privacy policy'),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => _openPolicy(context, arabic),
    );
  }
}
