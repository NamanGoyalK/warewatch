import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const String _notificationsKey = 'pref_notifications';
  static const String _soundKey = 'pref_sound';
  static const String _hapticsKey = 'pref_haptics';
  static const String _lowLatencyKey = 'pref_low_latency';
  static const String _streamQualityKey = 'pref_stream_quality';

  SettingsCubit() : super(const SettingsState()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      emit(
        state.copyWith(
          notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
          soundAlertsEnabled: prefs.getBool(_soundKey) ?? true,
          hapticsEnabled: prefs.getBool(_hapticsKey) ?? true,
          lowLatencyStream: prefs.getBool(_lowLatencyKey) ?? false,
          streamQuality: prefs.getString(_streamQualityKey) ?? 'Auto',
        ),
      );
    } catch (_) {}
  }

  Future<void> toggleNotifications(bool value) async {
    emit(state.copyWith(notificationsEnabled: value));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, value);
    } catch (_) {}
  }

  Future<void> toggleSound(bool value) async {
    emit(state.copyWith(soundAlertsEnabled: value));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_soundKey, value);
    } catch (_) {}
  }

  Future<void> toggleHaptics(bool value) async {
    emit(state.copyWith(hapticsEnabled: value));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hapticsKey, value);
    } catch (_) {}
  }

  Future<void> toggleLowLatency(bool value) async {
    emit(state.copyWith(lowLatencyStream: value));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_lowLatencyKey, value);
    } catch (_) {}
  }

  Future<void> setStreamQuality(String quality) async {
    emit(state.copyWith(streamQuality: quality));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_streamQualityKey, quality);
    } catch (_) {}
  }
}
