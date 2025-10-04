mixin Rateable {
  final List<double> _ratings = [];

  void rate(double rating) => _ratings.add(rating);

  // average rating

  double get averageRating => _ratings.isEmpty
      ? 0.0
      : _ratings.fold(0.0, (acc, curr) => acc + curr) / _ratings.length;
}
