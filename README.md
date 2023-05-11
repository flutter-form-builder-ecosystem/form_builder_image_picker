# Form Builder Image Picker

Images picker field for FlutterFormBuilder. Get images from gallery or camera.

[![Pub Version](https://img.shields.io/pub/v/form_builder_image_picker?logo=flutter&style=for-the-badge)](https://pub.dev/packages/form_builder_image_picker)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/flutter-form-builder-ecosystem/form_builder_image_picker/base.yaml?branch=main&logo=github&style=for-the-badge)](https://github.com/flutter-form-builder-ecosystem/form_builder_image_picker/actions/workflows/base.yaml)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/flutter-form-builder-ecosystem/form_builder_image_picker?logo=codefactor&style=for-the-badge)](https://www.codefactor.io/repository/github/flutter-form-builder-ecosystem/form_builder_image_picker)
[![Codecov](https://img.shields.io/codecov/c/github/flutter-form-builder-ecosystem/form_builder_image_picker?logo=codecov&style=for-the-badge)](https://codecov.io/gh/flutter-form-builder-ecosystem/form_builder_image_picker/)
___

- [Features](#features)
- [Use](#use)
  - [Setup](#setup)
  - [Basic use](#basic-use)
  - [Only specific pickers](#only-specific-pickers)
- [Support](#support)
  - [Contribute](#contribute)
  - [Questions and answers](#questions-and-answers)
  - [Donations](#donations)
- [Roadmap](#roadmap)
- [Ecosystem](#ecosystem)
- [Thanks to](#thanks-to)

## Features

- Pick image from gallery or camera
- Show images in form
- Support several images types: `Uint8List`, `XFile`, `String` (url) or `ImageProvider`

## Use

### Setup

Since this package makes use of [image_picker](https://pub.dev/packages/image_picker) package, for platform specific setup, follow the instructions [here](https://github.com/flutter/plugins/tree/main/packages/image_picker/image_picker#installation)

### Basic use

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
    ],
  ),
),
```

### Only specific pickers

```dart
FormBuilder(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      FormBuilderImagePicker(
        name: 'noCamera',
        availableImageSources: const [ImageSourceOption.gallery],
      ),
    ],
  ),
),
```

See [pub.dev example tab](https://pub.dev/packages/form_builder_image_picker/example) or [github code](example/lib/main.dart) for more details

## Support

### Contribute

You have some ways to contribute to this packages

- Beginner: Reporting bugs or request new features
- Intermediate: Implement new features (from issues or not) and created pull requests
- Advanced: Join to [organization](#ecosystem) like a member and help coding, manage issues, dicuss new features and other things

 See [contribution file](https://github.com/flutter-form-builder-ecosystem/.github/blob/main/CONTRIBUTING.md) for more details

### Questions and answers

You can question or search answers on [Github discussion](https://github.com/flutter-form-builder-ecosystem/form_builder_image_picker/discussions) or on [StackOverflow](https://stackoverflow.com/questions/tagged/flutter-form-builder)

### Donations

Donate or become a sponsor of Flutter Form Builder Ecosystem

[![Become a Sponsor](https://opencollective.com/flutter-form-builder-ecosystem/tiers/sponsor.svg?avatarHeight=56)](https://opencollective.com/flutter-form-builder-ecosystem)

## Roadmap

- Simplify the field form to minimal use case
- [Add visual examples](https://github.com/flutter-form-builder-ecosystem/form_builder_image_picker/issues/31) (images, gifs, videos, sample application)
- [Solve open issues](https://github.com/flutter-form-builder-ecosystem/form_builder_image_picker/issues), [prioritizing bugs](https://github.com/flutter-form-builder-ecosystem/form_builder_image_picker/labels/bug)

## Ecosystem

Take a look to [our awesome ecosystem](https://github.com/flutter-form-builder-ecosystem) and all packages in there

## Thanks to

[All constributors](https://github.com/flutter-form-builder-ecosystem/form_builder_image_picker/graphs/contributors)
