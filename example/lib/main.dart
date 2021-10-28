import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:form_builder_image_picker/form_builder_image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class ApiImage {
  final String imageUrl;
  final String id;
  ApiImage({
    required this.imageUrl,
    required this.id,
  });
}

class MyHomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FormBuilderImagePicker Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FormBuilderImagePicker(
                  name: 'photos',
                  displayCustomType: (obj) =>
                      obj is ApiImage ? obj.imageUrl : obj,
                  decoration: const InputDecoration(labelText: 'Pick Photos'),
                  maxImages: 5,
                  initialValue: [
                    'https://images.pexels.com/photos/7078045/pexels-photo-7078045.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                    Text('this is an image\nas a widget !'),
                    ApiImage(
                      id: 'whatever',
                      imageUrl:
                          'https://images.pexels.com/photos/8311418/pexels-photo-8311418.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() == true) {
                      print(_formKey.currentState!.value);
                    }
                  },
                ),
                ElevatedButton(
                  child: Text('Reset'),
                  onPressed: () {
                    _formKey.currentState?.reset();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
