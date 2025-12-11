import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.avatarUrl,
    required this.radius,
    this.borderColor,
  });

  final String avatarUrl;
  final double radius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    log(avatarUrl);

    final double borderWidth = borderColor != null ? 1.13 : 0.0;

    return CachedNetworkImage(
      imageUrl: avatarUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: radius * 2 + borderWidth * 2, // border uchun joy
          height: radius * 2 + borderWidth * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(width: borderWidth, color: borderColor!)
                : null,
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.transparent,
            backgroundImage: imageProvider,
          ),
        );
      },
      placeholder: (context, _) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[200]!,
        child: Container(
          width: radius * 2 + borderWidth * 2,
          height: radius * 2 + borderWidth * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: Colors.grey[300],
            border: borderColor != null
                ? Border.all(width: borderWidth, color: borderColor!)
                : null,
          ),
          child: CircleAvatar(radius: radius),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: radius * 2 + borderWidth * 2,
        height: radius * 2 + borderWidth * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
          border: borderColor != null
              ? Border.all(width: borderWidth, color: borderColor!)
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(borderWidth),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              color: Colors.grey.shade600,
              size: radius,
            ),
          ),
        ),
      ),
    );
  }
}
