abstract class Payable {
  /// Computes total outstanding fees
  double calculateFees();

  /// Processes payment, returns success status
  bool payFees(double amount);
}
