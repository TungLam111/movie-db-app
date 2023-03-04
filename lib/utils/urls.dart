class Urls {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'e0173a3f2740a8da9dcca7500919fe89';

  /// Image
  static const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';
  static String imageUrl(String path) => '$baseImageUrl$path';

  static const int kConnectionTimeOutInMilliSecond = 30000;
  static const int kReceivingTimeOutInMilliSecond = 30000;
}
