void main() {
  String imageFile = "documents/me/cat.jpeg";
  final fileName =
      '${DateTime.now().millisecondsSinceEpoch}_${imageFile.split('/').last}';

  print(fileName);
}