import 'dart:io';

import 'package:cs4900/views/camera/preview.dart';
import 'package:cs4900/views/upload_type.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cs4900/views/camera/upload.dart';

class PickImageScreen extends StatefulWidget {
  final UploadType uploadType;

  PickImageScreen({super.key, required this.uploadType});

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImageScreen> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? const Text('No image selected')
                : Image.file(File(_image!.path)),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
              ),
              child: const Text(
                "Pick Image From Gallery",
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (_image != null)
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PreviewPictureScreen(
                            imagePath: _image!.path,
                            uploadType: UploadType.imageUpload,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
