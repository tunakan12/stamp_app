import 'package:flutter_test/flutter_test.dart';

import 'package:stamp_app/main.dart' as app;

void main() {
  testWidgets('Splash screen is shown on startup', (WidgetTester tester) async {
    app.main();
    await tester.pump();

    expect(find.text('Stamp App'), findsOneWidget);
  });
}
