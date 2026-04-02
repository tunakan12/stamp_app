import 'package:flutter/material.dart';

import '../../app/constants/app_spacing.dart';
import '../../shared/utils/date_formatter.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_card.dart';
import '../auth/presentation/auth_controller.dart';
import '../stamp/presentation/stamp_controller.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({
    super.key,
    required this.authController,
    required this.stampController,
  });

  final AuthController authController;
  final StampController stampController;

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
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
        final tickets = widget.stampController.tickets;
        return AppScaffold(
          title: 'チケット',
          currentIndex: 2,
          body: ListView(
            children: [
              SectionCard(
                child: Text('所持チケット: ${tickets.where((ticket) => !ticket.isUsed).length}枚'),
              ),
              if (tickets.isEmpty)
                const SectionCard(
                  child: Text('所持チケットがありません。特典交換でチケットを入手できます。'),
                ),
              ...tickets.map(
                (ticket) => SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ticket.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(ticket.description),
                      const SizedBox(height: AppSpacing.xs),
                      Text('交換日: ${DateFormatter.short(ticket.exchangedAt)}'),
                      if (ticket.usedAt != null)
                        Text('使用日: ${DateFormatter.short(ticket.usedAt!)}'),
                      const SizedBox(height: AppSpacing.sm),
                      PrimaryButton(
                        label: ticket.isUsed ? '使用済み' : 'このチケットを使う',
                        isLoading: widget.stampController.isLoading,
                        onPressed: ticket.isUsed
                            ? null
                            : () async {
                                final shouldUseTicket = await _confirmTicketUsage();
                                if (!shouldUseTicket) return;
                                await widget.stampController.useTicket(
                                  userId: widget.authController.currentUser!.id,
                                  ticketId: ticket.id,
                                );
                                if (!mounted) return;
                                final msg = widget.stampController.errorMessage ?? 'チケットを使用しました';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(msg)),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _confirmTicketUsage() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('本当に使用しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('使用する'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
