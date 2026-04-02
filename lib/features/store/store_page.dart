import 'package:flutter/material.dart';

import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/section_card.dart';
import 'store_repository.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key, required this.storeRepository});

  final StoreRepository storeRepository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storeRepository.fetchAll(),
      builder: (context, snapshot) {
        final stores = snapshot.data ?? [];
        return AppScaffold(
          title: '店舗一覧',
          currentIndex: 3,
          body: ListView(
            children: stores
                .map(
                  (store) => SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(store.name),
                      subtitle: Text('${store.description}\n${store.location}'),
                      leading: const CircleAvatar(child: Icon(Icons.storefront)),
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
