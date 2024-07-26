import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  final String accessKey = '2kl7V9U_ChdXGwHaFObSfuoC7okVNfxMaVNlSpvxj6M'; // Replace with your Unsplash Access Key
  final String baseUrl = 'https://api.unsplash.com';

  Future<List<dynamic>> fetchPhotos(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/photos?query=$query'),
      headers: {
        'Authorization': 'Client-ID $accessKey',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
