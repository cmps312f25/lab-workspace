import 'package:flutter/material.dart';
import '../../../../core/services/data_service.dart';
import '../../domain/entities/audiobook.dart';
import '../../domain/entities/book.dart';
import '../../domain/entities/library_item.dart';

class LibraryItemDetailsScreen extends StatelessWidget {
  final String itemId;

  const LibraryItemDetailsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    // TODO: Build item details screen showing all item information
    final item = DataService().getItem(itemId);

    if (item == null) {
      return const Scaffold(
        body: Center(child: Text('Item not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Title: ${item.title}'),
          Text('Type: ${item.getItemType()}'),
          Text('Category: ${item.category}'),
          Text('Year: ${item.publishedYear}'),
          Text('Available: ${item.isAvailable}'),
          const SizedBox(height: 10),
          Text('Authors: ${item.authors.map((a) => a.name).join(', ')}'),
          const SizedBox(height: 10),
          if (item is Book) ...[
            Text('ISBN: ${item.isbn}'),
            Text('Pages: ${item.pageCount}'),
            Text('Publisher: ${item.publisher}'),
          ],
          if (item is AudioBook) ...[
            Text('Duration: ${item.duration} hours'),
            Text('Narrator: ${item.narrator}'),
            Text('File Size: ${item.fileSize} MB'),
          ],
          if (item.description != null) ...[
            const SizedBox(height: 10),
            Text('Description: ${item.description}'),
          ],
          const SizedBox(height: 10),
          Text('Rating: ${item.getAverageRating()} (${item.getReviewCount()} reviews)'),
        ],
      ),
    );
  }
}
