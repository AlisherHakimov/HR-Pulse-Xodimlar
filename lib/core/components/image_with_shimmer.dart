import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hr_plus/core/resources/colors.dart';
import 'package:shimmer/shimmer.dart';


class ImageWithShimmer extends StatefulWidget {
  const ImageWithShimmer({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final double? borderRadius;
  final BoxFit? fit;

  @override
  State<ImageWithShimmer> createState() => _ImageWithShimmerState();
}

class _ImageWithShimmerState extends State<ImageWithShimmer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.imageUrl),
              fit: widget.fit ?? BoxFit.cover,
              onError: (exception, stackTrace) => Icon(Icons.error),
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.cover,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Container(
                height: widget.height,
                width: widget.width,
                color: AppColors.primary,
              ),
            ),
            errorWidget: (_, __, ___) => SizedBox(
              height: widget.height,
              width: widget.width,
              child: Icon(
                Icons.image,
                size: (widget.height ?? 100) / 2,
                color: AppColors.woodSmoke100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
