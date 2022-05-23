import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkBookImage extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final double? width;

  const NetworkBookImage(
      {Key? key, required this.imagePath, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CachedNetworkImage(
      imageUrl: imagePath ?? "",
      imageBuilder: (context, imageProvider) => Container(
        height: height ?? 150,
        width: width ?? 150,
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
      ),
      placeholder: (context, url) => Container(
        height: height ?? 150,
        width: width ?? 150,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset("assets/images/bg.png",
          fit: BoxFit.cover, width: width ?? 110, height: height ?? 150),
    );
  }
}
