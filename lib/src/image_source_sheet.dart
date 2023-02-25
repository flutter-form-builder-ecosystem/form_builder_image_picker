import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_source_option.dart';

typedef FutureVoidCallBack = Future<void> Function();

class ImageSourceBottomSheet extends StatefulWidget {
  /// Optional maximum height of image
  final double? maxHeight;

  /// Optional maximum width of image
  final double? maxWidth;

  /// The imageQuality argument modifies the quality of the image, ranging from
  /// 0-100 where 100 is the original/max quality. If imageQuality is null, the
  /// image with the original quality will be returned.
  final int? imageQuality;

  final int? remainingImages;

  /// Use preferredCameraDevice to specify the camera to use when the source is
  /// `ImageSource.camera`. The preferredCameraDevice is ignored when source is
  /// `ImageSource.gallery`. It is also ignored if the chosen camera is not
  /// supported on the device. Defaults to `CameraDevice.rear`.
  final CameraDevice preferredCameraDevice;

  /// Callback when an image is selected.
  final void Function(Iterable<XFile> files) onImageSelected;

  /// The sources to create ListTiles for.
  /// Either [ImageSourceOption.gallery], [ImageSourceOption.camera] or both.
  final List<ImageSourceOption> availableImageSources;

  final Widget? cameraIcon;
  final Widget? galleryIcon;
  final Widget? cameraLabel;
  final Widget? galleryLabel;
  final EdgeInsets? bottomSheetPadding;
  final bool preventPop;

  final Widget Function(
          FutureVoidCallBack cameraPicker, FutureVoidCallBack galleryPicker)?
      optionsBuilder;

  const ImageSourceBottomSheet({
    Key? key,
    this.remainingImages,
    this.preventPop = false,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    required this.onImageSelected,
    this.cameraIcon,
    this.galleryIcon,
    this.cameraLabel,
    this.galleryLabel,
    this.bottomSheetPadding,
    this.optionsBuilder,
    required this.availableImageSources,
  }) : super(key: key);

  @override
  ImageSourceBottomSheetState createState() => ImageSourceBottomSheetState();
}

class ImageSourceBottomSheetState extends State<ImageSourceBottomSheet> {
  bool _isPickingImage = false;

  Future<void> _onPickImage(ImageSource source) async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    final imagePicker = ImagePicker();
    try {
      if (source == ImageSource.camera || widget.remainingImages == 1) {
        final pickedFile = await imagePicker.pickImage(
          source: source,
          preferredCameraDevice: widget.preferredCameraDevice,
          maxHeight: widget.maxHeight,
          maxWidth: widget.maxWidth,
          imageQuality: widget.imageQuality,
        );
        _isPickingImage = false;
        if (pickedFile != null) {
          widget.onImageSelected([pickedFile]);
        }
      } else {
        final pickedFiles = await imagePicker.pickMultiImage(
          maxHeight: widget.maxHeight,
          maxWidth: widget.maxWidth,
          imageQuality: widget.imageQuality,
        );
        _isPickingImage = false;
        if (pickedFiles.isNotEmpty) {
          widget.onImageSelected(pickedFiles);
        }
      }
    } catch (e) {
      _isPickingImage = false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.optionsBuilder != null) {
      return widget.optionsBuilder!(
        () => _onPickImage(ImageSource.camera),
        () => _onPickImage(ImageSource.gallery),
      );
    }
    Widget res = Container(
      padding: widget.bottomSheetPadding,
      child: Wrap(
        children: <Widget>[
          if (widget.availableImageSources.contains(ImageSourceOption.camera))
            ListTile(
              leading: widget.cameraIcon,
              title: widget.cameraLabel,
              onTap: () => _onPickImage(ImageSource.camera),
            ),
          if (widget.availableImageSources.contains(ImageSourceOption.gallery))
            ListTile(
              leading: widget.galleryIcon,
              title: widget.galleryLabel,
              onTap: () => _onPickImage(ImageSource.gallery),
            ),
        ],
      ),
    );
    if (widget.preventPop) {
      res = WillPopScope(
        onWillPop: () async => !_isPickingImage,
        child: res,
      );
    }
    return res;
  }
}
