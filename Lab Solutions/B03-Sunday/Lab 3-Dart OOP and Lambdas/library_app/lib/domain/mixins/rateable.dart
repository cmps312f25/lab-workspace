mixin Rateable {
  final List<double> _ratings = [];

  void rate(double rating) {
    _ratings.add(rating);
  }

  void get averageRating => _ratings.isEmpty
      ? 0
      : _ratings.fold(0.0, (a, b) => a + b) / _ratings.length;
}
