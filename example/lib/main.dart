import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class ApiImage {
  final String imageUrl;
  final String id;

  ApiImage({required this.imageUrl, required this.id});
}

class MyHomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FormBuilderImagePicker Example')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FormBuilderImagePicker(
                    name: 'photos',
                    displayCustomType: (obj) =>
                        obj is ApiImage ? obj.imageUrl : obj,
                    decoration: const InputDecoration(labelText: 'Pick Photos'),
                    maxImages: 5,
                    previewAutoSizeWidth: true,
                    previewMargin: const EdgeInsetsDirectional.only(end: 8),
                    fit: BoxFit.cover,
                    optionsClipBehavior: Clip.hardEdge,
                    initialValue: [
                      'https://images.pexels.com/photos/7078045/pexels-photo-7078045.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                      const Text('this is an image\nas a widget !'),
                      ApiImage(
                        id: 'whatever',
                        imageUrl:
                            'https://images.pexels.com/photos/8311418/pexels-photo-8311418.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260',
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  FormBuilderImagePicker(
                    name: 'singlePhotoWithDecoration',
                    displayCustomType: (obj) =>
                        obj is ApiImage ? obj.imageUrl : obj,
                    decoration: const InputDecoration(
                      labelText: 'Pick Single Photo With Decoration Visible',
                    ),
                    showDecoration: true,
                    maxImages: 1,
                    previewAutoSizeWidth: true,
                    initialValue: const [
                      'https://images.pexels.com/photos/7078045/pexels-photo-7078045.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Single Photo with no decoration, and previewAutoSizeWidth=true',
                  ),
                  FormBuilderImagePicker(
                    name: 'singlePhoto',
                    displayCustomType: (obj) =>
                        obj is ApiImage ? obj.imageUrl : obj,
                    // decoration: const InputDecoration(
                    //   labelText: 'Pick Photos',
                    // ),
                    showDecoration: false,
                    maxImages: 1,
                    previewAutoSizeWidth: true,
                    initialValue: const [
                      'https://images.pexels.com/photos/7078045/pexels-photo-7078045.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Single Photo similar to CircleAvatar, using transformImageWidget',
                  ),
                  FormBuilderImagePicker(
                    name: 'singleAvatarPhoto',
                    displayCustomType: (obj) =>
                        obj is ApiImage ? obj.imageUrl : obj,
                    decoration: const InputDecoration(labelText: 'Pick Photos'),
                    transformImageWidget: (context, displayImage) => Card(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox.expand(child: displayImage),
                    ),
                    showDecoration: false,
                    maxImages: 1,
                    previewAutoSizeWidth: false,
                    initialValue: const [
                      'https://images.pexels.com/photos/7078045/pexels-photo-7078045.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                    ],
                  ),
                  const SizedBox(height: 15),
                  FormBuilderImagePicker(
                    name: 'fieldCustomization',
                    decoration: const InputDecoration(labelText: 'Pick Photos'),
                    previewAutoSizeWidth: true,
                    fit: BoxFit.cover,
                    backgroundColor: Colors.black54,
                    iconColor: Colors.white,
                    icon: Icons.ac_unit_rounded,
                  ),
                  const SizedBox(height: 15),
                  FormBuilderImagePicker(
                    name: 'onlyCamera',
                    decoration: const InputDecoration(
                      labelText: 'Pick Photos (only from camera)',
                    ),
                    availableImageSources: const [ImageSourceOption.camera],
                  ),
                  const SizedBox(height: 15),
                  FormBuilderImagePicker(
                    name: 'onlyGallery',
                    decoration: const InputDecoration(
                      labelText: 'Pick Photos (only from gallery)',
                    ),
                    availableImageSources: const [ImageSourceOption.gallery],
                  ),
                  FormBuilderImagePicker(
                    decoration: const InputDecoration(
                      labelText: 'Pick Photos (with custom view)',
                    ),
                    name: 'CupertinoActionSheet',
                    optionsBuilder: (cameraPicker, galleryPicker) =>
                        CupertinoActionSheet(
                          title: const Text('Image'),
                          message: const Text(
                            'Pick an image from given options',
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                              isDefaultAction: true,
                              onPressed: () {
                                cameraPicker();
                              },
                              child: const Text('Camera'),
                            ),
                            CupertinoActionSheetAction(
                              isDefaultAction: true,
                              onPressed: () {
                                galleryPicker();
                              },
                              child: const Text('Gallery'),
                            ),
                          ],
                        ),
                    onTap: (child) => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => child,
                    ),
                  ),
                  FormBuilderImagePicker(
                    name: 'customPreview',
                    maxImages: null,
                    previewBuilder: (context, images, addButton) =>
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 130,
                            maxHeight: 500,
                          ),
                          child: GridView.extent(
                            maxCrossAxisExtent: 130,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: [...images, ?addButton],
                          ),
                        ),
                  ),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() == true) {
                        debugPrint(_formKey.currentState!.value.toString());
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Reset'),
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
