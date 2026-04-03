import 'package:flutter/material.dart';

void main() {
  runApp(const StampApp());
}

class StampApp extends StatelessWidget {
  const StampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'スタンプアプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<String> titles = const [
    'ホーム',
    '特典一覧',
    'チケット',
    '店舗一覧',
    'プロフィール',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeTab(),
      const RewardsTab(),
      const TicketsTab(),
      const StoresTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            fontSize: 18,
          ),
        ),
        leading: const SizedBox(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF475569),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.qr_code_2_rounded),
              label: const Text(
                'スタンプ取得',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE0E7FF),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 74,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            selectedIcon: Icon(Icons.card_giftcard),
            label: '特典',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'チケット',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: '店舗',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person),
            label: 'プロフィール',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x334F46E5),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'こんにちは、',
                  style: TextStyle(
                    color: Color(0xFFC7D2FE),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '島崎 裕也 さん',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '6',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        height: 0.9,
                      ),
                    ),
                    SizedBox(width: 8),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        '/ 8 スタンプ',
                        style: TextStyle(
                          color: Color(0xFFC7D2FE),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: const LinearProgressIndicator(
                    minHeight: 10,
                    value: 0.75,
                    backgroundColor: Color(0x33433B82),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      text: '次の特典まであと',
                      style: TextStyle(
                        color: Color(0xFFC7D2FE),
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: ' 2 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: '個'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'クイックメニュー'),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                QuickChip(label: '履歴を見る'),
                QuickChip(label: '特典を見る'),
                QuickChip(label: 'チケットを見る'),
                QuickChip(label: '店舗を見る'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionTitle(title: '最近の履歴'),
          const SizedBox(height: 12),
          const HistoryCard(
            icon: '📍',
            title: 'カフェABC',
            subtitle: 'QR読み取りでスタンプ獲得',
            date: '2026/04/03',
            time: '17:30',
          ),
          const SizedBox(height: 12),
          const HistoryCard(
            icon: '📍',
            title: 'カフェABC',
            subtitle: 'QR読み取りでスタンプ獲得',
            date: '2026/04/03',
            time: '17:30',
          ),
          const SizedBox(height: 12),
          const HistoryCard(
            icon: '🍜',
            title: 'ラーメンXYZ',
            subtitle: '会計スタンプ',
            date: '2026/04/03',
            time: '12:10',
          ),
        ],
      ),
    );
  }
}

class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: const [
          CountCard(
            label: '保有スタンプ',
            value: '6',
            unit: '個',
          ),
          SizedBox(height: 16),
          RewardCard(
            title: 'ドリンク1杯無料',
            description: '好きなドリンク1杯',
            requiredStamps: 5,
            enabled: true,
            buttonText: '交換する',
            accent: Color(0xFF4F46E5),
          ),
          SizedBox(height: 16),
          RewardCard(
            title: 'トッピング無料',
            description: '任意トッピング1つ無料',
            requiredStamps: 8,
            enabled: false,
            buttonText: 'スタンプ不足',
            accent: Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }
}

class TicketsTab extends StatelessWidget {
  const TicketsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: const [
          CountCard(
            label: '所持チケット',
            value: '1',
            unit: '枚',
          ),
          SizedBox(height: 16),
          TicketCard(
            title: 'ドリンク1杯無料',
            description: '好きなドリンク1杯',
            exchangedAt: '2026/04/03 17:31',
          ),
        ],
      ),
    );
  }
}

class StoresTab extends StatelessWidget {
  const StoresTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: const [
          StoreCard(
            name: 'カフェABC',
            description: '来店で1スタンプ',
            address: '東京都港区',
          ),
          SizedBox(height: 12),
          StoreCard(
            name: 'ラーメンXYZ',
            description: '会計ごとに1スタンプ',
            address: '東京都新宿区',
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: '島崎 裕也');
    final emailController = TextEditingController(text: 'demo@example.com');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0E7FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 42,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 28, color: Color(0xFFF1F5F9)),
                ],
              ),
              AppTextField(
                label: '名前',
                controller: nameController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'メールアドレス',
                controller: emailController,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF2FF),
                    foregroundColor: const Color(0xFF4338CA),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    '保存',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text(
                    'ログアウト',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF334155),
      ),
    );
  }
}

class QuickChip extends StatelessWidget {
  final String label;

  const QuickChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ActionChip(
        onPressed: () {},
        backgroundColor: const Color(0xFFEEF2FF),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        label: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4338CA),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String date;
  final String time;

  const HistoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$date\n$time',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const CountCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text.rich(
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Color(0xFF4F46E5),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final int requiredStamps;
  final bool enabled;
  final String buttonText;
  final Color accent;

  const RewardCard({
    super.key,
    required this.title,
    required this.description,
    required this.requiredStamps,
    required this.enabled,
    required this.buttonText,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.72,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: enabled ? const Color(0xFFC7D2FE) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            if (enabled)
              Container(
                width: 5,
                height: 170,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: '必要スタンプ: ',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: '$requiredStamps',
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: enabled
                              ? const Color(0xFFEEF2FF)
                              : const Color(0xFFF1F5F9),
                          foregroundColor: enabled
                              ? const Color(0xFF4338CA)
                              : const Color(0xFF94A3B8),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: enabled ? () {} : null,
                        child: Text(
                          buttonText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String title;
  final String description;
  final String exchangedAt;

  const TicketCard({
    super.key,
    required this.title,
    required this.description,
    required this.exchangedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFDE68A)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('☕️', style: TextStyle(fontSize: 28)),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 14),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE2E8F0),
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                child: Text(
                  '交換日: $exchangedAt',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'このチケットを使う',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: -8,
          top: 110,
          child: _ticketHole(),
        ),
        Positioned(
          right: -8,
          top: 110,
          child: _ticketHole(),
        ),
      ],
    );
  }

  Widget _ticketHole() {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final String name;
  final String description;
  final String address;

  const StoreCard({
    super.key,
    required this.name,
    required this.description,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: Color(0xFF6366F1),
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
