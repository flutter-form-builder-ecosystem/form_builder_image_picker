import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders material_ui decoration and validation error', (
    tester,
  ) async {
    final formKey = GlobalKey<FormBuilderState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormBuilder(
            key: formKey,
            child: FormBuilderImagePicker(
              name: 'photos',
              maxImages: 0,
              decoration: const InputDecoration(labelText: 'Pick Photos'),
              validator: (_) => 'Required',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(InputDecorator), findsOneWidget);
    expect(find.text('Pick Photos'), findsOneWidget);
    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('opens material_ui image source sheet', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormBuilder(child: FormBuilderImagePicker(name: 'photos')),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.camera_enhance).first);
    await tester.pumpAndSettle();

    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });
}
