import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_on.freezed.dart';
part 'add_on.g.dart';

@freezed
class AddOn with _$AddOn {
  const factory AddOn({
    required String name,
    required double price,
    @JsonKey(name: 'is_free') @Default(false) bool isFree,
    String? description,
  }) = _AddOn;

  factory AddOn.fromJson(Map<String, dynamic> json) => _$AddOnFromJson(json);
} 