import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool notificationsEnabled;
  final bool soundAlertsEnabled;
  final bool hapticsEnabled;
  final bool lowLatencyStream;
  final String streamQuality;

  const SettingsState({
    this.notificationsEnabled = true,
    this.soundAlertsEnabled = true,
    this.hapticsEnabled = true,
    this.lowLatencyStream = false,
    this.streamQuality = 'Auto',
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? soundAlertsEnabled,
    bool? hapticsEnabled,
    bool? lowLatencyStream,
    String? streamQuality,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundAlertsEnabled: soundAlertsEnabled ?? this.soundAlertsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      lowLatencyStream: lowLatencyStream ?? this.lowLatencyStream,
      streamQuality: streamQuality ?? this.streamQuality,
    );
  }

  @override
  List<Object?> get props => [
        notificationsEnabled,
        soundAlertsEnabled,
        hapticsEnabled,
        lowLatencyStream,
        streamQuality,
      ];
}
