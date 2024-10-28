import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cs4900/models/image.dart';
import 'package:cs4900/models/user.dart';

class PhotoDisplayComponent extends StatelessWidget {
  final String imageId;

  const PhotoDisplayComponent({super.key, required this.imageId});

  Future<Map<String, dynamic>> buildFutureElements() async {
    ImageInformation imageInfo = ImageInformation(imageId);
    Map<String, dynamic>? imageData = await imageInfo.getImageInformation();
    UserInformation authorInformation = await imageInfo.getAuthorInformation();

    log("Image Data = " + imageData.toString());
    Map<String, dynamic> resultData = <String, dynamic> {
      "ImageID": imageId,
      "ImageURL": imageData!["url"],
      "AuthorUsername": await authorInformation.getUsername(),
      "AuthorProfilePicture": await authorInformation.getProfilePicture(),
      "Likes": imageData["likes"].toString(),
      "Comments": imageData["Comments"] ?? [],
    };
    log("Result data = " + resultData.toString());
    return resultData;
  }

  Widget buildWidget(Map<String, dynamic> data) {
    log("widget data = ");
    log(data.toString());
    Center authorInformation = Center(child: ListTile(
        leading: ClipOval(
          child: SizedBox(
            width: 35, height: 35,
            child: Image.network(data["AuthorProfilePicture"] ?? ""),
          ),
        ),
      title: Text(
          data["AuthorUsername"] ?? "???",
          style: const TextStyle(fontSize: 13, color: Colors.white),
      ),
    ),);

    Container top = Container(
      width: 375, height: 54,
      color: const Color.fromRGBO(18, 25, 33, 1),
      child: authorInformation,
    );

    Container middle = Container(
      width: 375, height: 375,
      child: Image.network(data["ImageURL"] ?? "", fit: BoxFit.cover)
    );

    IconButton likeButton = IconButton(
        icon: const Icon(
          Icons.favorite_outline,
          size: 25,
          color: Colors.white,
        ),
        onPressed: () {}
    );

    IconButton commentButton = IconButton(
      icon: Image.asset(
        'assets/images/comment.webp',
        height: 28,
      ),
      onPressed: () {}
    );

    IconButton shareButton = IconButton(
      icon: Image.asset(
        'assets/images/send.png',
        height: 25,
      ),
      onPressed: () {

      }
    );

    Container bottom = Container(
      width: 375,
      color: const Color.fromRGBO(18, 25, 33, 1),
      child: Column(
        children: [
          SizedBox(width: 14),
          Row(
            children: [
              SizedBox(width: 14),
              likeButton,
              SizedBox(width: 17),
              commentButton,
              SizedBox(width: 17),
              shareButton,
            ],
          )
        ],
      ),
    );

    return Column(
      children: [
        top,
        middle,
        bottom
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingState = const SizedBox(width: 375, height: 429, child: Center(child: CircularProgressIndicator()));

    FutureBuilder<Map<String, dynamic>> builder = FutureBuilder<Map<String, dynamic>> (
      future: buildFutureElements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          log("snapshot.data = " + snapshot.data.toString());
          log("snapshot required data" + snapshot.requireData.toString());
          if (snapshot.data == null) {

            log("Error snapshot data is null");
            return loadingState;
          }
          return buildWidget(snapshot.data!);
        }
        else { return loadingState; }
      });

    return Container(
      child: builder,
    );
  }


}