enum BookingStatus {
  pending('pending'),
  confirmed('confirmed'),
  attended('attended'),
  cancelled('cancelled');

  const BookingStatus(this.value);
  final String value;

  static BookingStatus fromString(String value) {
    return BookingStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => BookingStatus.pending,
    );
  }
}
