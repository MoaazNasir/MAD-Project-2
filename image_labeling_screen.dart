import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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

  // Your hardcoded API key here
  final String apiKey = '7c0a46f3dcb442cd5d099a5dce54360d8536adb7';

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _analyzeImage(_image!);
    }
  }

  Future<void> _analyzeImage(File image) async {
    try {
      final url =
          'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

      final imageBytes = await image.readAsBytes();
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
        // Print the error message from the API response
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  List<String> _parseLabels(Map<String, dynamic> responseData) {
    final labels = <String>[];
    if (responseData['responses'] != null &&
        responseData['responses'][0]['labelAnnotations'] != null) {
      final labelAnnotations = responseData['responses'][0]['labelAnnotations'];
      for (var label in labelAnnotations) {
        labels.add(label['description']);
      }
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Labeling'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _image == null ? const Text('No image selected.') : Image.file(_image!),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Pick Image'),
            ),
            ..._labels.map((label) => Text(label)),
          ],
        ),
      ),
    );
  }
}

