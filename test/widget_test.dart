// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_library/main.dart';

void main() {
  testWidgets('MyApp widget test', (WidgetTester tester) async {
    print('Starting MyApp widget test...');
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    print('MyApp widget created successfully');

    // Verify that the app initializes without errors
    expect(find.byType(MyApp), findsOneWidget);
    print('MyApp widget found in widget tree');
    
    // Since AuthWrapper will show LoginScreen initially (no user logged in)
    // We can test that the authentication flow is working
    await tester.pumpAndSettle();
    print('Widget tree settled after pump');
    
    // The app should display some content (either login screen or dashboard)
    expect(find.byType(MaterialApp), findsOneWidget);
    print('MaterialApp widget found - test completed successfully');
  });
}
