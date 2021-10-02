import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Camera Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  _captureImage() async {
    XFile? capturedImage = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = capturedImage != null ? File(capturedImage.path) : null;
    });
  }

  _pickFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          _imageFile == null
              ? Image.network(
                  "https://via.placeholder.com/300",
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  _imageFile!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera),
                    label: const Text('Take a Picture'),
                    onPressed: _captureImage,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.perm_media_outlined),
                    label: const Text('Pick from Gallery'),
                    onPressed: _pickFromGallery,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
