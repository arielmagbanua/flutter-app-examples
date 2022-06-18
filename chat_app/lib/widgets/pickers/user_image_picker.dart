import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// User image picker widget class
class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  /// Receives the function [imagePickFn] reference.
  /// This enables widget users to listen for picked image.
  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  late File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();

    final selectedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 150,
    );

    if (selectedImage != null) {
      setState(() {
        // set picked image variable this will update the preview
        _pickedImage = File(selectedImage.path);
      });
    }

    // call the image picked function
    widget.imagePickFn(_pickedImage!);
  }

  @override
  void initState() {
    super.initState();
    _pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: FileImage(_pickedImage!),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
