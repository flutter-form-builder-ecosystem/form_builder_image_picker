import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

import 'image_source_option.dart';
import 'image_source_sheet.dart';

/// Field for picking image(s) from Gallery or Camera.
///
/// Field value is a list of objects.
///
/// the widget can internally handle displaying objects of type [XFile],[Uint8List],[String] (for an image url),[ImageProvider] (for any flutter image), [Widget] (for any widget)
/// and appends [XFile] to the list for picked images.
///
/// if you want to use a different object (e.g. a class from the backend that has imageId and imageUrl)
/// you need to implement [displayCustomType]
class FormBuilderImagePicker extends FormBuilderFieldDecoration<List<dynamic>> {
  /// set to true to insert an [InputDecorator] which displays labels, borders, etc...
  ///
  /// when [maxImages] == 1, it's better to set this to false
  final bool showDecoration;

  /// set to true to let images decide their own width
  ///
  /// when [maxImages] == 1, it's better to set this to true
  final bool previewAutoSizeWidth;

  /// the width of image previews, also see [previewAutoSizeWidth]
  final double previewWidth;

  /// the height of image previews
  final double previewHeight;

  /// margins between image previews
  final EdgeInsetsGeometry? previewMargin;

  /// May be supplied for a fully custom display of the image preview
  final Widget Function(BuildContext, List<Widget> children, Widget? addButton)?
  previewBuilder;

  /// placeholder image displayed when picking a new image
  final ImageProvider? placeholderImage;

  /// placeholder widget displayed when picking a new image
  final Widget? placeholderWidget;

  /// Field icon
  final IconData? icon;

  /// Field icon color
  final Color? iconColor;

  /// Field background color
  final Color? backgroundColor;

  /// Optional maximum height of image; see [ImagePicker].
  final double? maxHeight;

  /// Optional maximum width of image; see [ImagePicker].
  final double? maxWidth;

  /// The imageQuality argument modifies the quality of the image, ranging from
  /// 0-100 where 100 is the original/max quality. If imageQuality is null, the
  /// image with the original quality will be returned. See [ImagePicker].
  final int? imageQuality;

  /// Use preferredCameraDevice to specify the camera to use when the source is
  /// `ImageSource.camera`. The preferredCameraDevice is ignored when source is
  /// `ImageSource.gallery`. It is also ignored if the chosen camera is not
  /// supported on the device. Defaults to `CameraDevice.rear`. See [ImagePicker].
  final CameraDevice preferredCameraDevice;

  /// use this to get an image from a custom object to either [Uint8List] or [XFile] or [String] (url) or [ImageProvider]
  ///
  /// ```dart
  /// (obj) => obj is MyApiFileClass ? obj.imageUrl : obj;
  /// ```
  final dynamic Function(dynamic obj)? displayCustomType;

  final void Function(Image)? onImage;

  /// maximum images to pick
  ///
  /// also see [showDecoration],[previewAutoSizeWidth]
  final int? maxImages;

  final Widget Function(BuildContext context, Widget displayImage)?
  transformImageWidget;

  /// Icon for camera option on bottom sheet
  final Widget cameraIcon;

  /// Icon for gallery option on bottom sheet
  final Widget galleryIcon;

  /// Label for camera option on bottom sheet
  final Widget cameraLabel;

  /// Label for gallery option on bottom sheet
  final Widget galleryLabel;
  final EdgeInsets bottomSheetPadding;
  final bool preventPop;

  /// fit for each image
  final BoxFit fit;

  /// The sources available to pick from.
  /// Either [ImageSourceOption.gallery], [ImageSourceOption.camera] or both.
  final List<ImageSourceOption> availableImageSources;

  ///A callback that returns a  pickup options
  ///ListTile(inside Wrap) by Default
  ///use optionsBuilder to return a widget of your choice
  final ValueChanged<ImageSourceBottomSheet>? onTap;

  /// use this callback if you want custom view for options
  /// call cameraPicker() to picks image from camera
  /// call galleryPicker() to picks image from gallery
  final Widget Function(
    FutureVoidCallBack cameraPicker,
    FutureVoidCallBack galleryPicker,
  )?
  optionsBuilder;

  final WidgetBuilder? loadingWidget;

  final Clip? optionsClipBehavior;

  FormBuilderImagePicker({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration = const InputDecoration(),
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    this.loadingWidget,
    this.transformImageWidget,
    this.showDecoration = true,
    this.placeholderWidget,
    this.previewAutoSizeWidth = true,
    this.previewBuilder,
    this.fit = BoxFit.cover,
    this.preventPop = false,
    this.displayCustomType,
    this.previewWidth = 130,
    this.previewHeight = 130,
    this.previewMargin,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.onImage,
    this.maxImages,
    this.cameraIcon = const Icon(Icons.camera_enhance),
    this.galleryIcon = const Icon(Icons.image),
    this.cameraLabel = const Text('Camera'),
    this.galleryLabel = const Text('Gallery'),
    this.bottomSheetPadding = EdgeInsets.zero,
    this.placeholderImage,
    this.onTap,
    this.optionsBuilder,
    this.optionsClipBehavior,
    this.availableImageSources = const [
      ImageSourceOption.camera,
      ImageSourceOption.gallery,
    ],
  }) : assert(maxImages == null || maxImages >= 0),
       super(
         builder: (FormFieldState<List<dynamic>?> field) {
           final state = field as FormBuilderImagePickerState;
           final theme = Theme.of(state.context);
           final disabledColor = theme.disabledColor;
           final primaryColor = theme.primaryColor;
           final value = state.effectiveValue;
           final canUpload = state.enabled && !state.hasMaxImages;

           /// how many items to display in the list view (including upload btn)
           final itemCount = value.length + (canUpload ? 1 : 0);

           Widget addButtonBuilder(BuildContext context) => GestureDetector(
             key: UniqueKey(),
             child:
                 placeholderWidget ??
                 SizedBox(
                   width: previewWidth,
                   child:
                       placeholderImage != null
                           ? Image(image: placeholderImage)
                           : Container(
                             color:
                                 (state.enabled
                                     ? backgroundColor ??
                                         primaryColor.withAlpha(50)
                                     : disabledColor),
                             child: Icon(
                               icon ?? Icons.camera_enhance,
                               color:
                                   state.enabled
                                       ? iconColor ?? primaryColor
                                       : disabledColor,
                             ),
                           ),
                 ),
             onTap: () async {
               final remainingImages =
                   maxImages == null ? null : maxImages - value.length;

               final imageSourceSheet = ImageSourceBottomSheet(
                 maxHeight: maxHeight,
                 maxWidth: maxWidth,
                 preventPop: preventPop,
                 remainingImages: remainingImages,
                 imageQuality: imageQuality,
                 preferredCameraDevice: preferredCameraDevice,
                 bottomSheetPadding: bottomSheetPadding,
                 cameraIcon: cameraIcon,
                 cameraLabel: cameraLabel,
                 galleryIcon: galleryIcon,
                 galleryLabel: galleryLabel,
                 optionsBuilder: optionsBuilder,
                 availableImageSources: availableImageSources,
                 onImageSelected: (image) {
                   state.focus();
                   field.didChange([...value, ...image]);
                   Navigator.pop(state.context);
                 },
               );
               onTap != null
                   ? onTap(imageSourceSheet)
                   : await showModalBottomSheet<void>(
                     context: state.context,
                     clipBehavior: optionsClipBehavior,
                     builder: (_) {
                       return imageSourceSheet;
                     },
                   );
             },
           );

           Widget itemBuilder(BuildContext context, dynamic item, int index) {
             bool checkIfItemIsCustomType(dynamic e) =>
                 !(e is XFile ||
                     e is String ||
                     e is Uint8List ||
                     e is ImageProvider ||
                     e is Widget);

             final itemCustomType = checkIfItemIsCustomType(item);
             var displayItem = item;
             if (itemCustomType && displayCustomType != null) {
               displayItem = displayCustomType(item);
             }
             assert(
               !checkIfItemIsCustomType(displayItem),
               'Display item must be of type [Uint8List], [XFile], [String] (url), [ImageProvider] or [Widget]. '
               'Consider using displayCustomType to handle the type: ${displayItem.runtimeType}',
             );

             final displayWidget =
                 displayItem is Widget
                     ? displayItem
                     : displayItem is ImageProvider
                     ? Image(image: displayItem, fit: fit)
                     : displayItem is Uint8List
                     ? Image.memory(displayItem, fit: fit)
                     : displayItem is String
                     ? Image.network(displayItem, fit: fit)
                     : XFileImage(
                       file: displayItem,
                       fit: fit,
                       loadingWidget: loadingWidget,
                     );
             return Stack(
               key: ObjectKey(item),
               children: <Widget>[
                 transformImageWidget?.call(context, displayWidget) ??
                     displayWidget,
                 if (state.enabled)
                   PositionedDirectional(
                     top: 0,
                     end: 0,
                     child: InkWell(
                       onTap: () {
                         state.focus();
                         field.didChange(value.toList()..removeAt(index));
                       },
                       child: Container(
                         margin: const EdgeInsets.all(3),
                         decoration: BoxDecoration(
                           color: Colors.grey.withValues(alpha: .7),
                           shape: BoxShape.circle,
                         ),
                         alignment: Alignment.center,
                         height: 22,
                         width: 22,
                         child: const Icon(
                           Icons.close,
                           size: 18,
                           color: Colors.white,
                         ),
                       ),
                     ),
                   ),
               ],
             );
           }

           if (previewBuilder != null) {
             return Builder(
               builder: (context) {
                 final widgets =
                     value
                         .mapIndexed((i, v) => itemBuilder(context, v, i))
                         .toList();

                 return previewBuilder(
                   context,
                   widgets,
                   canUpload ? addButtonBuilder(context) : null,
                 );
               },
             );
           }

           final child = SizedBox(
             height: previewHeight,
             child:
                 itemCount == 0
                     ? null //empty list
                     : itemCount ==
                         1 //has a single item,
                     ? canUpload
                         ? addButtonBuilder(state.context) //upload button
                         : SizedBox(
                           width: previewAutoSizeWidth ? null : previewWidth,
                           child: itemBuilder(state.context, value.first, 0),
                         )
                     : ListView.builder(
                       itemExtent: previewAutoSizeWidth ? null : previewWidth,
                       scrollDirection: Axis.horizontal,
                       itemCount: itemCount,
                       itemBuilder: (context, index) {
                         return Container(
                           margin: previewMargin,
                           child: Builder(
                             builder: (context) {
                               if (index < value.length) {
                                 final item = value[index];
                                 return itemBuilder(context, item, index);
                               }
                               return addButtonBuilder(context);
                             },
                           ),
                         );
                       },
                     ),
           );
           return showDecoration
               ? InputDecorator(decoration: state.decoration, child: child)
               : child;
         },
       );

  @override
  FormBuilderImagePickerState createState() => FormBuilderImagePickerState();
}

class FormBuilderImagePickerState
    extends
        FormBuilderFieldDecorationState<FormBuilderImagePicker, List<dynamic>> {
  List<dynamic> get effectiveValue =>
      value?.where((element) => element != null).toList() ?? [];

  bool get hasMaxImages {
    final ev = effectiveValue;
    return widget.maxImages != null && ev.length >= widget.maxImages!;
  }
}

class XFileImage extends StatefulWidget {
  const XFileImage({
    super.key,
    required this.file,
    this.fit,
    this.loadingWidget,
  });
  final XFile file;
  final BoxFit? fit;
  final WidgetBuilder? loadingWidget;

  @override
  State<XFileImage> createState() => _XFileImageState();
}

class _XFileImageState extends State<XFileImage> {
  final _memoizer = AsyncMemoizer<Uint8List>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _memoizer.runOnce(widget.file.readAsBytes),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return widget.loadingWidget?.call(context) ??
              const Center(child: CircularProgressIndicator());
        }
        return Image.memory(data, fit: widget.fit);
      },
    );
  }
}

extension _ListExtension<E> on List<E> {
  Iterable<R> mapIndexed<R>(R Function(int index, E element) convert) sync* {
    for (var index = 0; index < length; index++) {
      yield convert(index, this[index]);
    }
  }
}
