import 'package:flutter/material.dart';

import '../../shared/utils/date_formatter.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/section_card.dart';
import '../auth/presentation/auth_controller.dart';
import 'notification_repository.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({
    super.key,
    required this.authController,
    required this.notificationRepository,
  });

  final AuthController authController;
  final NotificationRepository notificationRepository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: notificationRepository.fetchAll(authController.currentUser!.id),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        return AppScaffold(
          title: 'お知らせ',
          body: ListView(
            children: items
                .map(
                  (item) => SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.title),
                      subtitle: Text('${item.body}\n${DateFormatter.short(item.createdAt)}'),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
