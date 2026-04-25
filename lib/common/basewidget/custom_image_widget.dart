import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;
  const CustomImageWidget({super.key, required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder});

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null && placeholder!.isNotEmpty) {
      return Image.asset(placeholder!, height: height, width: width, fit: fit ?? BoxFit.cover);
    }
    return Container(
      height: height,
      width: width,
      color: Theme.of(context).hintColor.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: Theme.of(context).hintColor.withOpacity(0.4),
          size: (height != null && height! < 40) ? 16 : 32,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image.contains('status: 404') || image.endsWith('null') || image.endsWith('def.png') || image == 'null') {
      return _buildPlaceholder(context);
    }
    return CachedNetworkImage(
      placeholder: (context, url) => _buildPlaceholder(context),
      imageUrl: image, fit: fit ?? BoxFit.cover,
      height: height, width: width,
      errorWidget: (c, o, s) => _buildPlaceholder(context),
    );
  }
}
