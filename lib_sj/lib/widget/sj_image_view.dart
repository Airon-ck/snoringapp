import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lib_sj/common/app_setting.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/util/image_utils.dart';

class SjCommonImageView extends StatelessWidget {
  final String assetsName;
  final String? assetsSelectName;
  final Key? key;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  bool select = false;

  /**
   * isSjLib是否是当前lib_sj库下加载的assets文件
   */
  bool isSjLib = false;

  bool isAllPicName;

  /**
   * prefixPathName:前缀路径，用于展示非主lib下其他module下应用的图片时使用
   */
  final String? otherModuleName;

  int? cacheWidth;
  int? cacheHeight;

  final ImageFormat? format;

  SjCommonImageView(
    this.assetsName, {
    this.key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.cover,
    this.select = false,
    this.assetsSelectName,
    this.isSjLib = false,
    this.otherModuleName,
    this.cacheWidth,
    this.cacheHeight,
    this.format,
    this.isAllPicName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        !isAllPicName
            ? ImageUtils.getImgPath(
                select ? assetsSelectName ?? assetsName : assetsName,
                format: format ?? ImageFormat.png,
                isSjLib: isSjLib,
                otherModuleName: otherModuleName)
            : assetsName,
        key: key,
        color: color,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: (context, error, stackTrace) => SizedBox());
  }
}

class SjFilePathImageView extends StatelessWidget {
  final String pathName;
  final String? pathSelectName;
  final Key? key;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  bool select = false;

  int? cacheWidth;
  int? cacheHeight;

  SjFilePathImageView(
    this.pathName, {
    this.key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.cover,
    this.select = false,
    this.pathSelectName,
    this.cacheWidth,
    this.cacheHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(File(select ? pathSelectName ?? pathName : pathName),
        key: key,
        color: color,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        errorBuilder: (context, error, stackTrace) => SizedBox());
  }
}

/// 图片加载（支持本地与网络图片）
class SjLoadImage extends StatelessWidget {
  SjLoadImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.format = ImageFormat.png,
    // this.holderImg = 'ic_loadding',
    this.holderImg,
    this.errorImg,
    this.cacheWidth,
    this.cacheHeight,
    this.openNetLoadHolder = true,
  })  : assert(image != null, 'The [image] argument must not be null.'),
        super(key: key);

  final String? image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageFormat? format;
  final String? holderImg;
  final String? errorImg;
  final int? cacheWidth;
  final int? cacheHeight;

  /**
   * 网络加载图片时是否使用loading图片
   */
  final bool openNetLoadHolder;

  @override
  Widget build(BuildContext context) {
    if (image!.isEmpty || image!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image ?? '',
        placeholder: openNetLoadHolder &&
                holderImg != null &&
                holderImg!.isNotEmpty &&
                AppSetting.DefaultPicHolder.isNotEmpty
            ? (_, __) => SjCommonImageView(
                  holderImg ?? AppSetting.DefaultPicHolder,
                  height: height,
                  width: width,
                  fit: fit,
                )
            : null,
        errorWidget: errorImg != null && errorImg!.isNotEmpty
            ? (_, __, dynamic error) => SjCommonImageView(errorImg!,
                height: height, width: width, fit: fit)
            : AppSetting.picErrorHolder,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
      );
    } else {
      return image == null
          ? SizedBox()
          : SjCommonImageView(
              image!,
              height: height,
              width: width,
              fit: fit,
              format: format,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
            );
    }
  }

  static String getFullPath(String image, {String format = 'png'}) {
    if (!image.contains("/")) {
      image = "assets/images/$image";
    }
    if (!image.contains(".")) {
      image = "$image.$format";
    }
    return image;
  }

  static ImageProvider getImageProvider(String imageUrl,
      {String holderImg = 'none'}) {
    if (imageUrl.isEmpty) {
      return AssetImage(getFullPath(holderImg));
    }
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImageProvider(imageUrl);
    } else {
      return AssetImage(getFullPath(imageUrl));
    }
  }

  static Widget circleAvatar(String url, double radius,
      {holderImg = 'ic_placeholder.png'}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      foregroundImage: getImageProvider(url, holderImg: holderImg),
      // backgroundImage: getImageProvider(holderImg),
    );
  }
}

// class SjIconfontImage extends StatelessWidget {
//
//   final int codePoint;
//   final String? fontFamily;
//   final Color? color;
//   final double? size;
//
//   const SjIconfontImage({required this.codePoint, required this.fontFamily, this.color,this.size});
//
//   @override
//   Widget build(BuildContext context) {
//     return Icon(
//       IconData(codePoint, fontFamily: fontFamily),
//       color: color,
//       size: size,
//     );
//   }
//
// }

/// 加载本地资源图片
@deprecated
class SjLoadAssetImage extends StatelessWidget {
  const SjLoadAssetImage(this.image,
      {Key? key,
      this.width,
      this.height,
      this.cacheWidth,
      this.cacheHeight,
      this.fit,
      this.format = ImageFormat.png,
      this.color})
      : super(key: key);

  final String? image;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat? format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageUtils.getImgPath(image ?? '', format: format ?? ImageFormat.png),
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,

      /// 忽略图片语义
      excludeFromSemantics: true,
    );
  }
}
