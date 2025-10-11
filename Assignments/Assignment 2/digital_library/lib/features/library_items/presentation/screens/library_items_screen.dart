import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/entities/library_item.dart';

class LibraryItemsScreen extends StatefulWidget {
  const LibraryItemsScreen({super.key});

  @override
  State<LibraryItemsScreen> createState() => _LibraryItemsScreenState();
}

class _LibraryItemsScreenState extends State<LibraryItemsScreen> {
  final _dataService = DataService();
  List<LibraryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _items = _dataService.getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Build library items screen with search bar and list
    // Use DataService().searchItems(query) for search
    // Navigate to item details on tap

    return Scaffold(
      body: Column(
        children: [
          const Text('[Search Bar]'),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.authors.map((a) => a.name).join(', ')),
                  trailing: Text(item.isAvailable ? 'Available' : 'Unavailable'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
