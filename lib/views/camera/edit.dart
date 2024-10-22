import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as img;

import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:cs4900/main.dart';
import 'filters.dart';

class EditScreen extends StatelessWidget {
  final String imagePath;

  EditScreen({super.key, required this.imagePath});

  final List<List<double>> filters = [GREYSCALE, GALAXY, AGED];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Filters'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width,
            maxHeight: size.width,
          ),
          child: PageView.builder(
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return ColorFiltered(
                  colorFilter: ColorFilter.matrix(filters[index]),
                  child: Image.file(File(imagePath),
                      width: 600, fit: BoxFit.cover),
                );
              }),
        ),
      ),
    );
  }
}



// Image.file(File(imagePath)),