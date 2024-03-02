import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageNetWorkCustom extends StatelessWidget {
  ImageNetWorkCustom({
    Key? key,
    required this.link,
    required this.pathAssetImg,
    required this.widgetLoading,
    this.height = 150,
    this.width = 100,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);
  final String link;
  double height;
  double width;
  final String pathAssetImg;
  BoxFit boxFit;
  final Widget widgetLoading;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      link,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return SizedBox(
            height: height,
            width: width,
            child: widgetLoading,
          );
        }
      },
      errorBuilder: (context, url, error) => Image.asset(
        pathAssetImg,
        fit: boxFit,
        height: height,
        width: width,
      ),
      fit: boxFit,
      height: height,
      width: width,
    );
  }
}
