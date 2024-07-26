import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ArtfolioApp());
}

class ArtfolioApp extends StatelessWidget {
  const ArtfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/artwork-details': (context) => const ArtworkDetailsScreen(),
        '/artist-profile': (context) => const ArtistProfileScreen(),
        '/upload': (context) => const UploadScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/search': (context) => const SearchScreen(),
        '/user-profile': (context) => const UserProfileScreen(),
        '/create-user': (context) => const CreateUserScreen(),
        '/edit-user': (context) => const EditUserScreen(),
        '/image-labeling': (context) => const ImageLabelingScreen(),
      },
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artfolio Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHomeButton(
              context,
              'Go to Gallery',
              '/gallery',
              Icons.photo_library,
            ),
            _buildHomeButton(
              context,
              'Upload Artwork',
              '/upload',
              Icons.upload_file,
            ),
            _buildHomeButton(
              context,
              'Search Artworks',
              '/search',
              Icons.search,
            ),
            _buildHomeButton(
              context,
              'My Profile',
              '/user-profile',
              Icons.person,
            ),
            _buildHomeButton(
              context,
              'Image Labeling',
              '/image-labeling',
              Icons.image,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context, String text, String route, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

// Unsplash API service
class UnsplashService {
  final String accessKey = '2kl7V9U_ChdXGwHaFObSfuoC7okVNfxMaVNlSpvxj6M';
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

// Gallery Screen with Unsplash API integration
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final UnsplashService _unsplashService = UnsplashService();
  List<dynamic> _photos = [];
  bool _isLoading = true;
  String _query = 'art';

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    try {
      final photos = await _unsplashService.fetchPhotos(_query);
      setState(() {
        _photos = photos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching photos: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchPhotos(String query) {
    setState(() {
      _query = query;
      _isLoading = true;
    });
    _fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PhotoSearchDelegate(
                  onSearch: _searchPhotos,
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                final photo = _photos[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/artwork-details'),
                    child: CachedNetworkImage(
                      imageUrl: photo['urls']['small'],
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Search Delegate for Photo Search
class PhotoSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;

  PhotoSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

// Artwork Details Screen
class ArtworkDetailsScreen extends StatelessWidget {
  const ArtworkDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Artwork Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Artwork Description',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/feedback'),
              child: const Text('Leave Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}

// Artist Profile Screen
class ArtistProfileScreen extends StatelessWidget {
  const ArtistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Artist Biography',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Upload Screen
class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Artwork'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Tags',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}

// Feedback Screen
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Leave a comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Screen
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for artworks or artists',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
              },
            ),
          ),
        ),
      ),
    );
  }
}

// User Profile Screen
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'User Bio',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/edit-user'),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

// Create User Screen
class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// Edit User Screen
class EditUserScreen extends StatelessWidget {
  const EditUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

// Image Labeling Screen
class ImageLabelingScreen extends StatefulWidget {
  const ImageLabelingScreen({super.key});

  @override
  _ImageLabelingScreenState createState() => _ImageLabelingScreenState();
}

class _ImageLabelingScreenState extends State<ImageLabelingScreen> {
  File? _image;
  final picker = ImagePicker();
  List<String> _labels = [];

  final String apiKey = '7c0a46f3dcb442cd5d099a5dce54360d8536adb7';

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _analyzeImage(_image!);
    }
  }

  Future<void> _analyzeImage(File image) async {
    final url =
        'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

    final imageBytes = image.readAsBytesSync();
    final base64Image = base64Encode(imageBytes);

    final body = json.encode({
      "requests": [
        {
          "image": {
            "content": base64Image,
          },
          "features": [
            {
              "type": "LABEL_DETECTION",
              "maxResults": 10,
            },
          ],
        },
      ],
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _labels = _parseLabels(responseData);
      });
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  List<String> _parseLabels(Map<String, dynamic> responseData) {
    final labels = <String>[];
    final labelAnnotations = responseData['responses'][0]['labelAnnotations'];
    for (var label in labelAnnotations) {
      labels.add(label['description']);
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Labeling'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image == null
                ? const Text('No image selected.')
                : Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.file(_image!),
                  ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            ..._labels.map((label) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(label, style: TextStyle(fontSize: 16)),
            )),
          ],
        ),
      ),
    );
  }
}
