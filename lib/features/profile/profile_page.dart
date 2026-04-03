import 'package:flutter/material.dart';

import '../../app/router/app_router.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/primary_button.dart';
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
      currentIndex: 4,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFEEF2FF),
                      child: Icon(Icons.person, color: Color(0xFF4F46E5)),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'アカウント情報',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '名前',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: user?.email ?? '',
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: '保存',
                  onPressed: _save,
                  isLoading: _isSaving,
                ),
                const SizedBox(height: 10),
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
