import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  // Replace with your actual TMDb API key
  static const String _apiKey = 'f4e624d70e487c37b663c208deaf82c4';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search/multi?query=$query&include_adult=false&language=en-US&page=1&api_key=$_apiKey',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data.toString());
        final results = data['results'] as List;
        return results.map((json) => Movie.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your TMDb API key.');
      } else if (response.statusCode == 404) {
        throw Exception('No results found.');
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on http.ClientException {
      throw Exception('Network error. Please try again.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout. Please try again.');
      }
      rethrow;
    }
  }
}