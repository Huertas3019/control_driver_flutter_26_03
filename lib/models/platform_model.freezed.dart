// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Platform {

 String? get id; String get userId; String get name;
/// Create a copy of Platform
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformCopyWith<Platform> get copyWith => _$PlatformCopyWithImpl<Platform>(this as Platform, _$identity);

  /// Serializes this Platform to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Platform&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name);

@override
String toString() {
  return 'Platform(id: $id, userId: $userId, name: $name)';
}


}

/// @nodoc
abstract mixin class $PlatformCopyWith<$Res>  {
  factory $PlatformCopyWith(Platform value, $Res Function(Platform) _then) = _$PlatformCopyWithImpl;
@useResult
$Res call({
 String? id, String userId, String name
});




}
/// @nodoc
class _$PlatformCopyWithImpl<$Res>
    implements $PlatformCopyWith<$Res> {
  _$PlatformCopyWithImpl(this._self, this._then);

  final Platform _self;
  final $Res Function(Platform) _then;

/// Create a copy of Platform
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Platform].
extension PlatformPatterns on Platform {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Platform value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Platform() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Platform value)  $default,){
final _that = this;
switch (_that) {
case _Platform():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Platform value)?  $default,){
final _that = this;
switch (_that) {
case _Platform() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String userId,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Platform() when $default != null:
return $default(_that.id,_that.userId,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String userId,  String name)  $default,) {final _that = this;
switch (_that) {
case _Platform():
return $default(_that.id,_that.userId,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String userId,  String name)?  $default,) {final _that = this;
switch (_that) {
case _Platform() when $default != null:
return $default(_that.id,_that.userId,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Platform implements Platform {
  const _Platform({this.id, required this.userId, required this.name});
  factory _Platform.fromJson(Map<String, dynamic> json) => _$PlatformFromJson(json);

@override final  String? id;
@override final  String userId;
@override final  String name;

/// Create a copy of Platform
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformCopyWith<_Platform> get copyWith => __$PlatformCopyWithImpl<_Platform>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Platform&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name);

@override
String toString() {
  return 'Platform(id: $id, userId: $userId, name: $name)';
}


}

/// @nodoc
abstract mixin class _$PlatformCopyWith<$Res> implements $PlatformCopyWith<$Res> {
  factory _$PlatformCopyWith(_Platform value, $Res Function(_Platform) _then) = __$PlatformCopyWithImpl;
@override @useResult
$Res call({
 String? id, String userId, String name
});




}
/// @nodoc
class __$PlatformCopyWithImpl<$Res>
    implements _$PlatformCopyWith<$Res> {
  __$PlatformCopyWithImpl(this._self, this._then);

  final _Platform _self;
  final $Res Function(_Platform) _then;

/// Create a copy of Platform
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? name = null,}) {
  return _then(_Platform(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
