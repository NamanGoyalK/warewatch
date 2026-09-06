import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warewatch/core/theme/theme_cubit.dart';
import 'package:warewatch/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:warewatch/features/settings/presentation/widgets/theme_selector_card.dart';
import 'package:warewatch/features/settings/presentation/widgets/account_info_card.dart';
import 'package:warewatch/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeCubit Tests', () {
    test('initial state defaults to ThemeMode.system', () {
      final cubit = ThemeCubit();
      expect(cubit.state, equals(ThemeMode.system));
    });

    test('updates theme mode correctly', () async {
      final cubit = ThemeCubit();
      await cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state, equals(ThemeMode.dark));

      await cubit.setThemeMode(ThemeMode.light);
      expect(cubit.state, equals(ThemeMode.light));
    });
  });

  group('SettingsCubit Tests', () {
    test('initial state has default values', () {
      final cubit = SettingsCubit();
      expect(cubit.state.notificationsEnabled, isTrue);
      expect(cubit.state.soundAlertsEnabled, isTrue);
      expect(cubit.state.hapticsEnabled, isTrue);
      expect(cubit.state.lowLatencyStream, isFalse);
    });

    test('toggles preferences correctly', () async {
      final cubit = SettingsCubit();
      await cubit.toggleNotifications(false);
      expect(cubit.state.notificationsEnabled, isFalse);

      await cubit.toggleSound(false);
      expect(cubit.state.soundAlertsEnabled, isFalse);

      await cubit.toggleHaptics(false);
      expect(cubit.state.hapticsEnabled, isFalse);

      await cubit.toggleLowLatency(true);
      expect(cubit.state.lowLatencyStream, isTrue);
    });
  });

  group('AccountInfoCard Widget Tests', () {
    testWidgets('renders user profile details correctly', (tester) async {
      final testUser = UserEntity(
        uid: 'user_test_12345',
        email: 'operator@godrej.com',
        displayName: 'Operator Alpha',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AccountInfoCard(user: testUser)),
        ),
      );

      expect(find.text('Operator Alpha'), findsOneWidget);
      expect(find.text('operator@godrej.com'), findsOneWidget);
      expect(find.text('OA'), findsOneWidget);
      expect(find.text('OPERATOR ACTIVE'), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
    });
  });

  group('ThemeSelectorCard Widget Tests', () {
    testWidgets('renders theme options and allows selection', (tester) async {
      final themeCubit = ThemeCubit();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: themeCubit,
              child: const ThemeSelectorCard(),
            ),
          ),
        ),
      );

      expect(find.text('Interface Theme'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(themeCubit.state, equals(ThemeMode.dark));
    });
  });
}
