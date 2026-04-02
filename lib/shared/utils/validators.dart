class Validators {
  static String? requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$labelを入力してください';
    }
    return null;
  }

  static String? email(String? value) {
    final required = requiredText(value, 'メールアドレス');
    if (required != null) return required;
    if (!value!.contains('@')) return 'メールアドレスの形式が不正です';
    return null;
  }

  static String? password(String? value) {
    final required = requiredText(value, 'パスワード');
    if (required != null) return required;
    if (value!.length < 8) return 'パスワードは8文字以上にしてください';
    return null;
  }
}
