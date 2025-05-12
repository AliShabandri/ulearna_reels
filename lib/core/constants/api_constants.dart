class ApiConstants {
  static const String baseUrl = 'https://backend-cj4o057m.fctl.app';
  static const String reelsEndpoint = '/bytes/scroll';

  static String getReelsUrl({
    required int page,
    required int limit,
    required String country,
  }) {
    return '$baseUrl$reelsEndpoint?page=$page&limit=$limit';
  }
}
