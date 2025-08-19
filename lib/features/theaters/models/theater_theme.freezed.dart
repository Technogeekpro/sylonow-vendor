// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theater_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TheaterTheme _$TheaterThemeFromJson(Map<String, dynamic> json) {
  return _TheaterTheme.fromJson(json);
}

/// @nodoc
mixin _$TheaterTheme {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get primaryColor => throw _privateConstructorUsedError;
  String get secondaryColor => throw _privateConstructorUsedError;
  String get backgroundImageUrl => throw _privateConstructorUsedError;
  String get previewImageUrl => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TheaterThemeCopyWith<TheaterTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TheaterThemeCopyWith<$Res> {
  factory $TheaterThemeCopyWith(
          TheaterTheme value, $Res Function(TheaterTheme) then) =
      _$TheaterThemeCopyWithImpl<$Res, TheaterTheme>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String primaryColor,
      String secondaryColor,
      String backgroundImageUrl,
      String previewImageUrl,
      bool isActive});
}

/// @nodoc
class _$TheaterThemeCopyWithImpl<$Res, $Val extends TheaterTheme>
    implements $TheaterThemeCopyWith<$Res> {
  _$TheaterThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? backgroundImageUrl = null,
    Object? previewImageUrl = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundImageUrl: null == backgroundImageUrl
          ? _value.backgroundImageUrl
          : backgroundImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      previewImageUrl: null == previewImageUrl
          ? _value.previewImageUrl
          : previewImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TheaterThemeImplCopyWith<$Res>
    implements $TheaterThemeCopyWith<$Res> {
  factory _$$TheaterThemeImplCopyWith(
          _$TheaterThemeImpl value, $Res Function(_$TheaterThemeImpl) then) =
      __$$TheaterThemeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String primaryColor,
      String secondaryColor,
      String backgroundImageUrl,
      String previewImageUrl,
      bool isActive});
}

/// @nodoc
class __$$TheaterThemeImplCopyWithImpl<$Res>
    extends _$TheaterThemeCopyWithImpl<$Res, _$TheaterThemeImpl>
    implements _$$TheaterThemeImplCopyWith<$Res> {
  __$$TheaterThemeImplCopyWithImpl(
      _$TheaterThemeImpl _value, $Res Function(_$TheaterThemeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? primaryColor = null,
    Object? secondaryColor = null,
    Object? backgroundImageUrl = null,
    Object? previewImageUrl = null,
    Object? isActive = null,
  }) {
    return _then(_$TheaterThemeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      primaryColor: null == primaryColor
          ? _value.primaryColor
          : primaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryColor: null == secondaryColor
          ? _value.secondaryColor
          : secondaryColor // ignore: cast_nullable_to_non_nullable
              as String,
      backgroundImageUrl: null == backgroundImageUrl
          ? _value.backgroundImageUrl
          : backgroundImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      previewImageUrl: null == previewImageUrl
          ? _value.previewImageUrl
          : previewImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TheaterThemeImpl implements _TheaterTheme {
  const _$TheaterThemeImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.primaryColor,
      required this.secondaryColor,
      required this.backgroundImageUrl,
      required this.previewImageUrl,
      this.isActive = true});

  factory _$TheaterThemeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TheaterThemeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String primaryColor;
  @override
  final String secondaryColor;
  @override
  final String backgroundImageUrl;
  @override
  final String previewImageUrl;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'TheaterTheme(id: $id, name: $name, description: $description, primaryColor: $primaryColor, secondaryColor: $secondaryColor, backgroundImageUrl: $backgroundImageUrl, previewImageUrl: $previewImageUrl, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TheaterThemeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.primaryColor, primaryColor) ||
                other.primaryColor == primaryColor) &&
            (identical(other.secondaryColor, secondaryColor) ||
                other.secondaryColor == secondaryColor) &&
            (identical(other.backgroundImageUrl, backgroundImageUrl) ||
                other.backgroundImageUrl == backgroundImageUrl) &&
            (identical(other.previewImageUrl, previewImageUrl) ||
                other.previewImageUrl == previewImageUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      primaryColor,
      secondaryColor,
      backgroundImageUrl,
      previewImageUrl,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TheaterThemeImplCopyWith<_$TheaterThemeImpl> get copyWith =>
      __$$TheaterThemeImplCopyWithImpl<_$TheaterThemeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TheaterThemeImplToJson(
      this,
    );
  }
}

abstract class _TheaterTheme implements TheaterTheme {
  const factory _TheaterTheme(
      {required final String id,
      required final String name,
      required final String description,
      required final String primaryColor,
      required final String secondaryColor,
      required final String backgroundImageUrl,
      required final String previewImageUrl,
      final bool isActive}) = _$TheaterThemeImpl;

  factory _TheaterTheme.fromJson(Map<String, dynamic> json) =
      _$TheaterThemeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get primaryColor;
  @override
  String get secondaryColor;
  @override
  String get backgroundImageUrl;
  @override
  String get previewImageUrl;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$TheaterThemeImplCopyWith<_$TheaterThemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
