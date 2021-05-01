import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class UserProfileImage extends StatelessWidget {
  final double radius;
  final String profileImageUrl;
  final File image;
  const UserProfileImage({
    Key key,
    @required this.radius,
    @required this.profileImageUrl,
    this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      radius: radius,
      backgroundImage: image != null
          ? FileImage(image)
          : profileImageUrl.isNotEmpty
              ? CachedNetworkImageProvider(profileImageUrl)
              : null,
      child: profileImageUrl.isEmpty ? _noProfileIcon() : null,
    );
  }

  Icon _noProfileIcon() {
    if (image == null && profileImageUrl.isEmpty) {
      return Icon(
        Icons.account_circle,
        size: radius * 2,
        color: Colors.grey[400],
      );
    }
    return null;
  }
}
