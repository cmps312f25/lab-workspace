enum SessionStatus {
  open('open'),
  closed('closed'),
  cancelled('cancelled');

  const SessionStatus(this.value);
  final String value;

  static SessionStatus fromString(String value) {
    return SessionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => SessionStatus.open,
    );
  }
}
