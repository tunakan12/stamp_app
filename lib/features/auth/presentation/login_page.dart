import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_card.dart';
import 'auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.authController});

  final AuthController authController;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: 'demo@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isRegister = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = _isRegister
        ? await widget.authController.register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          )
        : await widget.authController.login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (widget.authController.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.authController.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _isRegister ? '新規登録' : 'ログイン',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (_isRegister) ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: '名前'),
                          validator: (v) => Validators.requiredText(v, '名前'),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'メールアドレス'),
                        validator: Validators.email,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'パスワード'),
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AnimatedBuilder(
                        animation: widget.authController,
                        builder: (_, __) => PrimaryButton(
                          label: _isRegister ? '登録する' : 'ログインする',
                          onPressed: _submit,
                          isLoading: widget.authController.isLoading,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: () => setState(() => _isRegister = !_isRegister),
                        child: Text(_isRegister ? 'ログインへ戻る' : '新規登録はこちら'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text('デモアカウント: demo@example.com / password123'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
