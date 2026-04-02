import 'package:flutter/material.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_card.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../store/store_repository.dart';
import 'stamp_controller.dart';

class StampScanPage extends StatefulWidget {
  const StampScanPage({
    super.key,
    required this.authController,
    required this.stampController,
  });

  final AuthController authController;
  final StampController stampController;

  @override
  State<StampScanPage> createState() => _StampScanPageState();
}

class _StampScanPageState extends State<StampScanPage> {
  final _storeRepository = StoreRepository.global;
  String? _selectedStoreId = 's1';

  @override
  Widget build(BuildContext context) {
    final stores = _storeRepository.fetchAllSync();
    return AnimatedBuilder(
      animation: widget.stampController,
      builder: (context, _) {
        return AppScaffold(
          title: 'スタンプ取得',
          body: ListView(
            children: [
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('デモ実装ではQRの代わりに店舗を選んで付与します。'),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      value: _selectedStoreId,
                      items: stores
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _selectedStoreId = value),
                      decoration: const InputDecoration(labelText: '店舗'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PrimaryButton(
                      label: 'スタンプを付与する',
                      isLoading: widget.stampController.isLoading,
                      onPressed: _selectedStoreId == null
                          ? null
                          : () async {
                              await widget.stampController.scanAndGrant(
                                userId: widget.authController.currentUser!.id,
                                storeId: _selectedStoreId!,
                              );
                              if (!mounted) return;
                              final message = widget.stampController.errorMessage == null
                                  ? 'スタンプを付与しました'
                                  : widget.stampController.errorMessage!;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
