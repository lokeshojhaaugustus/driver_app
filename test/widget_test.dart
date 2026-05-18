import 'package:flutter_test/flutter_test.dart';

import 'package:driver_app/main.dart';

void main() {
  testWidgets('shows login screen when logged out', (tester) async {
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    await tester.pump();

    expect(find.text('Sign Up'), findsOneWidget);
  });
}
