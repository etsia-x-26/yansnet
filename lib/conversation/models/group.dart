import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

/// Modèle représentant un groupe de conversation
@freezed
class Group with _$Group {
  const factory Group({
    required int id,
    required String name,
    required String description,
    required String profileImageUrl,
    required int createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Group;

  /// Crée un Group depuis un JSON
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}