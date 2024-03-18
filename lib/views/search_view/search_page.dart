import 'package:flutter/material.dart';

import 'widgets/item_reponse_search_page.dart';
import 'widgets/item_search_page.dart';
import 'widgets/widget_select_website.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tìm kiếm'),
          actions: [
            WidgetSelectWebsite(),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            ItemSearchPage(),
            ReponseSearchPage(),
          ],
        ),
      ),
    );
  }
}