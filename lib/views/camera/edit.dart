import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as img;

import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:cs4900/main.dart';

class EditScreen extends StatelessWidget {
  final String imagePath;

  EditScreen({super.key, required this.imagePath});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Filters'), 
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Image.file(File(imagePath)),
        ],
      ),
    );
  }
}