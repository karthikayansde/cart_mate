import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'dart:typed_data';

class NetworkImageCommon extends StatelessWidget {
  final double? height;
  final double? width;
  final String URL;
  final BoxFit? fit;
  final String defaultImage;

  const NetworkImageCommon({
    super.key,
    this.height,
    this.width,
    required this.URL,
    this.fit,
    required this.defaultImage,
  });

  @override
  Widget build(BuildContext context) {
    // Use CachedNetworkImage to automatically handle caching.
    return CachedNetworkImage(
      // The URL of the image to load.
      imageUrl: URL,
      // Constrain the size of the image widget.
      height: height,
      width: width,
      // How the image should be inscribed into the box.
      fit: fit,
      // A widget to show while the image is loading from the network.
      placeholder: (context, url) => Image.asset(
        defaultImage,
        fit: fit,
      ),
      // A widget to show if an error occurs while loading the image.
      errorWidget: (context, url, error) => Image.asset(
        defaultImage,
        fit: fit,
      ),
      // Optional: Control the fade-in duration after the image is loaded.
      fadeInDuration: const Duration(milliseconds: 150),
    );
  }
}


class Base64ImageCommon extends StatelessWidget {
  final String? base64String;
  final BoxFit? fit;
  final String defaultImage;

  const Base64ImageCommon({
    super.key,
    required this.base64String,
    this.fit,
    required this.defaultImage,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the Base64 string is not null or empty
    if (base64String != null && base64String!.isNotEmpty) {
      try {
        // Decode the Base64 string into a Uint8List
        final Uint8List imageBytes = base64.decode(base64String!);

        // Use Image.memory to display the decoded image bytes
        return Image.memory(
          imageBytes,
          fit: fit,
        );
      } catch (e) {
        // Handle any decoding errors by falling back to the default image
        debugPrint('Error decoding base64 image: $e');
      }
    }

    // Fallback to the default image if the base64 string is null, empty, or decoding failed
    return Image.asset(
      defaultImage,
      fit: fit,
    );
  }
}
