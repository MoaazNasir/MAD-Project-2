import 'package:flutter/material.dart';

void main() {
  runApp(ArtfolioApp());
}

class ArtfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/gallery': (context) => GalleryScreen(),
        '/artwork-details': (context) => ArtworkDetailsScreen(),
        '/artist-profile': (context) => ArtistProfileScreen(),
        '/upload': (context) => UploadScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/search': (context) => SearchScreen(),
        '/user-profile': (context) => UserProfileScreen(),
        '/create-user': (context) => CreateUserScreen(),
        '/edit-user': (context) => EditUserScreen(),
      },
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artfolio Home'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/gallery'),
            child: Text('Go to Gallery'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/upload'),
            child: Text('Upload Artwork'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/search'),
            child: Text('Search Artworks'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/user-profile'),
            child: Text('My Profile'),
          ),
        ],
      ),
    );
  }
}

// Gallery Screen
class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 10, // Replace with actual data length
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/artwork-details'),
            child: Card(
              child: Center(child: Text('Artwork $index')),
            ),
          );
        },
      ),
    );
  }
}

// Artwork Details Screen
class ArtworkDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artwork Details'),
      ),
      body: Column(
        children: [
          Text('Artwork Title'),
          Text('Artwork Description'),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/feedback'),
            child: Text('Leave Feedback'),
          ),
        ],
      ),
    );
  }
}

// Artist Profile Screen
class ArtistProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artist Profile'),
      ),
      body: Column(
        children: [
          Text('Artist Biography'),
          // Display artist's artworks here
        ],
      ),
    );
  }
}

// Upload Screen
class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Artwork'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Tags'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle upload
              },
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}

// Feedback Screen
class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Leave a comment'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle feedback submission
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// Search Screen
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: TextField(
        decoration: InputDecoration(
          hintText: 'Search for artworks or artists',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

// User Profile Screen
class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        children: [
          Text('User Name'),
          Text('User Bio'),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/edit-user'),
            child: Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}

// Create User Screen
class CreateUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // Handle user creation
                Navigator.pushNamed(context, '/');
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// Edit User Screen
class EditUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Bio'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle profile update
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
