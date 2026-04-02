import 'package:flutter/material.dart';

import '../../../shared/utils/date_formatter.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_card.dart';
import '../../auth/presentation/auth_controller.dart';
import 'stamp_controller.dart';

class StampHistoryPage extends StatefulWidget {
  const StampHistoryPage({
    super.key,
    required this.authController,
    required this.stampController,
  });

  final AuthController authController;
  final StampController stampController;

  @override
  State<StampHistoryPage> createState() => _StampHistoryPageState();
}

class _StampHistoryPageState extends State<StampHistoryPage> {
  @override
  void initState() {
    super.initState();
    widget.stampController.load(widget.authController.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.stampController,
      builder: (context, _) {
        return AppScaffold(
          title: 'スタンプ履歴',
          body: ListView(
            children: [
              SectionCard(
                child: Column(
                  children: widget.stampController.logs
                      .map(
                        (log) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(log.storeName),
                          subtitle: Text('${log.message}\n${DateFormatter.short(log.createdAt)}'),
                          trailing: Text(
                            log.amount > 0 ? '+${log.amount}' : '${log.amount}',
                            style: TextStyle(
                              color: log.amount > 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
