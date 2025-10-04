mixin Rateable {
  final List<double> _ratings = [];

  // add a rating

  void rate(double rating) {
    _ratings.add(rating);
  }

  double get averageRating => _ratings.length == 0.0
      ? 0.0
      : _ratings.fold(0.0, (acc, b) => acc + b) / _ratings.length;
}
