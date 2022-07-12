# Form Builder Image Picker

Field for picking image(s) from Gallery or Camera for flutter_form_builder package

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
