# Form Builder Image Picker

[![Pub Version](https://img.shields.io/pub/v/form_builder_image_picker?logo=flutter&style=for-the-badge)](https://pub.dev/packages/form_builder_image_picker)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/flutter-form-builder-ecosystem/form_builder_image_picker/Base?logo=github&style=for-the-badge)](https://github.com/flutter-form-builder-ecosystem/form_builder_image_picker/actions/workflows/base.yaml)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/flutter-form-builder-ecosystem/form_builder_image_picker?logo=codefactor&style=for-the-badge)](https://www.codefactor.io/repository/github/flutter-form-builder-ecosystem/form_builder_image_picker)
[![Codecov](https://img.shields.io/codecov/c/github/flutter-form-builder-ecosystem/form_builder_image_picker?logo=codecov&style=for-the-badge)](https://codecov.io/gh/flutter-form-builder-ecosystem/form_builder_image_picker/)

Images picker field for FlutterFormBuilder. Get images from gallery or camera.

# Setup

Since this package makes use of [image_picker package](https://pub.dev/packages/image_picker), for platform specific setup, follow the instructions [here](https://github.com/flutter/plugins/tree/main/packages/image_picker/image_picker#installation)

## Usage

```dart
FormBuilder(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      FormBuilderImagePicker(
        name: 'photos',
        decoration: const InputDecoration(labelText: 'Pick Photos'),
        maxImages: 1,
      ),
      const SizedBox(height: 15),
      RaisedButton(onPressed: (){
        if(_formKey.currentState.saveAndValidate()){
          print(_formKey.currentState.value);
        }
      })
    ],
  ),
),
```

## Credits

<a href="https://github.com/flutter-form-builder-ecosystem/form_builder_image_picker/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutter-form-builder-ecosystem/form_builder_image_picker" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
