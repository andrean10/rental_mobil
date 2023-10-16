abstract class Validation {
  static String? formField({
    required String? value,
    required String titleField,
  }) {
    if (value != null && value.isEmpty) {
      return '$titleField harus di isi!';
    }
    return null;
  }
}
