class Validator {
  Validator._();

  static String? requiredField(
    String? value, {
    String message = 'Khong duoc de trong.',
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? positivePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Khong duoc de trong.';
    }

    final price = double.tryParse(value.trim());
    if (price == null || price <= 0) {
      return 'Gia phai > 0.';
    }

    return null;
  }

  static double parsePrice(String value) {
    return double.parse(value.trim());
  }
}
