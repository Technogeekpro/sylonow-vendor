// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VendorNotification _$VendorNotificationFromJson(Map<String, dynamic> json) {
  return _VendorNotification.fromJson(json);
}

/// @nodoc
mixin _$VendorNotification {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_id')
  String get vendorId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'booking', 'payment', 'system', 'promotion'
  String? get actionData =>
      throw _privateConstructorUsedError; // JSON string for additional action data
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VendorNotificationCopyWith<VendorNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorNotificationCopyWith<$Res> {
  factory $VendorNotificationCopyWith(
          VendorNotification value, $Res Function(VendorNotification) then) =
      _$VendorNotificationCopyWithImpl<$Res, VendorNotification>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      String title,
      String message,
      String type,
      String? actionData,
      String? imageUrl,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$VendorNotificationCopyWithImpl<$Res, $Val extends VendorNotification>
    implements $VendorNotificationCopyWith<$Res> {
  _$VendorNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? actionData = freezed,
    Object? imageUrl = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      actionData: freezed == actionData
          ? _value.actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VendorNotificationImplCopyWith<$Res>
    implements $VendorNotificationCopyWith<$Res> {
  factory _$$VendorNotificationImplCopyWith(_$VendorNotificationImpl value,
          $Res Function(_$VendorNotificationImpl) then) =
      __$$VendorNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vendor_id') String vendorId,
      String title,
      String message,
      String type,
      String? actionData,
      String? imageUrl,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$VendorNotificationImplCopyWithImpl<$Res>
    extends _$VendorNotificationCopyWithImpl<$Res, _$VendorNotificationImpl>
    implements _$$VendorNotificationImplCopyWith<$Res> {
  __$$VendorNotificationImplCopyWithImpl(_$VendorNotificationImpl _value,
      $Res Function(_$VendorNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? title = null,
    Object? message = null,
    Object? type = null,
    Object? actionData = freezed,
    Object? imageUrl = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VendorNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      actionData: freezed == actionData
          ? _value.actionData
          : actionData // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorNotificationImpl implements _VendorNotification {
  const _$VendorNotificationImpl(
      {required this.id,
      @JsonKey(name: 'vendor_id') required this.vendorId,
      required this.title,
      required this.message,
      required this.type,
      this.actionData,
      this.imageUrl,
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$VendorNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorNotificationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vendor_id')
  final String vendorId;
  @override
  final String title;
  @override
  final String message;
  @override
  final String type;
// 'booking', 'payment', 'system', 'promotion'
  @override
  final String? actionData;
// JSON string for additional action data
  @override
  final String? imageUrl;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VendorNotification(id: $id, vendorId: $vendorId, title: $title, message: $message, type: $type, actionData: $actionData, imageUrl: $imageUrl, isRead: $isRead, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.actionData, actionData) ||
                other.actionData == actionData) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, vendorId, title, message,
      type, actionData, imageUrl, isRead, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorNotificationImplCopyWith<_$VendorNotificationImpl> get copyWith =>
      __$$VendorNotificationImplCopyWithImpl<_$VendorNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorNotificationImplToJson(
      this,
    );
  }
}

abstract class _VendorNotification implements VendorNotification {
  const factory _VendorNotification(
          {required final String id,
          @JsonKey(name: 'vendor_id') required final String vendorId,
          required final String title,
          required final String message,
          required final String type,
          final String? actionData,
          final String? imageUrl,
          @JsonKey(name: 'is_read') final bool isRead,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$VendorNotificationImpl;

  factory _VendorNotification.fromJson(Map<String, dynamic> json) =
      _$VendorNotificationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vendor_id')
  String get vendorId;
  @override
  String get title;
  @override
  String get message;
  @override
  String get type;
  @override // 'booking', 'payment', 'system', 'promotion'
  String? get actionData;
  @override // JSON string for additional action data
  String? get imageUrl;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$VendorNotificationImplCopyWith<_$VendorNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
