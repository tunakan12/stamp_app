import 'package:flutter/material.dart';

import '../../app/constants/app_spacing.dart';
import '../../app/router/app_router.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_card.dart';
import '../auth/presentation/auth_controller.dart';
import 'profile_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.authController,
    required this.profileRepository,
  });

  final AuthController authController;
  final ProfileRepository profileRepository;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.authController.currentUser?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final user = widget.authController.currentUser!;
    final updated = await widget.profileRepository.updateName(
      email: user.email,
      name: _nameController.text.trim(),
    );
    widget.authController
      ..logout()
      ..login(email: updated.email, password: 'password123');
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロフィールを保存しました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authController.currentUser;
    return AppScaffold(
      title: 'プロフィール',
      currentIndex: 3,
      body: ListView(
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 28, child: Icon(Icons.person)),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '名前'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(user?.email ?? ''),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: '保存',
                  onPressed: _save,
                  isLoading: _isSaving,
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () async {
                    await widget.authController.logout();
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (_) => false,
                    );
                  },
                  child: const Text('ログアウト'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
