extension StringExtension on String {
  String getExtension() {
    return split('.').last;
  }
}
