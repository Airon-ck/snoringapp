import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lib_sj/common/app_setting.dart';
import 'package:lib_sj/lib_sj.dart';

import 'common_util/text_util.dart';
import 'dart:ui' as ui;

class ImageUtils {
  /**
   * isSjLib是否是当前lib_sj库下加载的assets文件
   * prefixPathName:前缀路径，用于展示非主lib下其他module下应用的图片时使用
   */
  static ImageProvider getAssetImage(String name,
      {ImageFormat format = ImageFormat.png,
      bool isSjLib = false,
      String? otherModuleName}) {
    return AssetImage(getImgPath(name,
        format: format, isSjLib: isSjLib, otherModuleName: otherModuleName));
  }

  /**
   * isSjLib是否是当前lib_sj库下加载的assets文件
   * prefixPathName:前缀路径，用于展示非主lib下其他module下应用的图片时使用
   * itemPathName:在assets下的文件夹名称
   */
  static String getImgPath(String name,
      {ImageFormat format = ImageFormat.png,
      bool isSjLib = false,
      String? otherModuleName,
      String? itemPathName}) {
    return '${otherModuleName != null && otherModuleName.isNotEmpty ? ('packages/${otherModuleName}/') : (isSjLib ? 'packages/${LibraryName}/' : '')}assets/${itemPathName ?? "images"}/${AppSetting.picPrefix}$name.${format.value}';
  }

  static ImageProvider getImageProvider(String imageUrl,
      {String holderImg = 'ic_app_logo'}) {
    if (TextUtil.isEmpty(imageUrl)) {
      return AssetImage(getImgPath(holderImg));
    }
    return CachedNetworkImageProvider(imageUrl);
  }

  //方法1：获取网络图片 返回ui.Image
  Future<ui.Image> getNetImage(String url, {width, height}) async {
    ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

//方法2.1：获取本地图片  返回ui.Image 需要传入BuildContext context
  Future<ui.Image> getAssetImage2(String asset, BuildContext context,
      {width, height}) async {
    ByteData data = await DefaultAssetBundle.of(context).load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

//方法2.2：获取本地图片 返回ui.Image 不需要传入BuildContext context
  Future<ui.Image> getAssetImageFrame(String asset, {width, height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}

enum ImageFormat { png, jpg, gif, webp }

extension ImageFormatExtension on ImageFormat {
  String get value => ['png', 'jpg', 'gif', 'webp'][index];
}
