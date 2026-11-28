import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// One experience entry, matching ExperienceSerializer in the Django repo.
@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    required this.title,
    required this.description,
    required this.startedAt,
    this.category = 'full-time',
    this.thumbnail = '',
    this.endedAt,
    this.id,
    this.categoryDisplay = '',
    this.starCount = 0,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  // The server makes these, so they are never sent in a POST.
  @JsonKey(includeToJson: false)
  final String? id;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String categoryDisplay;
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;

  final String title;
  final String description;

  // Django stores the value (like "full-time"), not the label.
  @JsonKey(defaultValue: 'full-time')
  final String category;

  // Optional in Django, so null from the API becomes an empty string.
  @JsonKey(defaultValue: '')
  final String thumbnail;

  final DateTime startedAt;

  // null means the experience is still ongoing.
  final DateTime? endedAt;

  /// Text like "2025-08-01 to 2026-01-31", or "2025-08-01 to now" if ongoing.
  String get period {
    final end = endedAt == null ? 'now' : formatDate(endedAt!);
    return '${formatDate(startedAt)} to $end';
  }

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}

/// Formats a date as YYYY-MM-DD in the phone's local time.
String formatDate(DateTime date) {
  final local = date.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}