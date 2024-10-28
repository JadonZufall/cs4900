import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs4900/views/camera/preview.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cs4900/main.dart';
import 'filters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';

class EditScreen extends StatelessWidget {
  final String imagePath;

  EditScreen({super.key, required this.imagePath});

  final List<List<double>> filters = [NOFILTER, GREYSCALE, GALAXY, AGED];
  final PageController _pageController = PageController();
  int _currentFilterIndex = 0;

  Future<String> _applyFilter(List<double> filter) async {
    final image = File(imagePath);
    final imageBytes = await image.readAsBytes();
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frameInfo = await codec.getNextFrame();
    final ui.Image img = frameInfo.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..colorFilter = ColorFilter.matrix(filter);

    canvas.drawImage(img, Offset.zero, paint);
    final picture = recorder.endRecording();
    final img2 = await picture.toImage(img.width, img.height);
    final byteData = await img2.toByteData(format: ui.ImageByteFormat.png);

    // Get the temporary directory to save the filtered image
    final directory = await getTemporaryDirectory();
    final tempFile = File('${directory.path}/filtered_image.png');

    // Write the filtered image bytes to the temp file
    await tempFile.writeAsBytes(byteData!.buffer.asUint8List());

    return tempFile.path; // Return the path of the saved image
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Filters'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: size.width,
                maxHeight: size.width,
              ),
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: filters.length,
                  onPageChanged: (index) {
                    _currentFilterIndex = index;
                  },
                  itemBuilder: (context, index) {
                    return ColorFiltered(
                      colorFilter: ColorFilter.matrix(filters[index]),
                      child: Image.file(File(imagePath),
                          width: 600, fit: BoxFit.cover),
                    );
                  }),
            ),
            ElevatedButton(
              onPressed: () async {
                final selectedFilter = filters[_currentFilterIndex];
                final filteredImagePath = await _applyFilter(selectedFilter);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PreviewPictureScreen(imagePath: filteredImagePath),
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
