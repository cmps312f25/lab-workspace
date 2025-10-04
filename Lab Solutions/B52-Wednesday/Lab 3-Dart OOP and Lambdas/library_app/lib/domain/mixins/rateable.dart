mixin Rateable {
  final List<double> _ratings = [9.0];

  void rate(double rating) => _ratings.add(rating);

  double get averageRating => _ratings.isEmpty
      ? 0.0
      : _ratings.fold(0.0, (acc, curr) => acc + curr) / _ratings.length;
}
