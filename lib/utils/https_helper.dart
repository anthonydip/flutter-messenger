// Helper function to encode query parameters into the Uri
// for GET requests
String encodeQueryParameters(Map<String, String> params) {
  return params.entries.map((entry) {
    final key = Uri.encodeComponent(entry.key);
    final value = Uri.encodeComponent(entry.value);
    return '$key=$value';
  }).join('&');
}