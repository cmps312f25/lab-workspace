enum ReviewRating {
  one(1.0),
  two(2.0),
  three(3.0),
  four(4.0),
  five(5.0);

  const ReviewRating(this.value);
  final double value;

  static ReviewRating fromDouble(double value) {
    return ReviewRating.values.firstWhere(
      (rating) => rating.value == value,
      orElse: () => ReviewRating.three,
    );
  }

  static ReviewRating fromInt(int value) {
    return ReviewRating.values.firstWhere(
      (rating) => rating.value == value.toDouble(),
      orElse: () => ReviewRating.three,
    );
  }
}
