// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Vehicle {

@JsonKey(includeIfNull: false) String? get id; String get userId; String get brand; String get model; int get year; String get licensePlate; double get fuelEfficiency; String? get nickname;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) Timestamp get createdAt;
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleCopyWith<Vehicle> get copyWith => _$VehicleCopyWithImpl<Vehicle>(this as Vehicle, _$identity);

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.licensePlate, licensePlate) || other.licensePlate == licensePlate)&&(identical(other.fuelEfficiency, fuelEfficiency) || other.fuelEfficiency == fuelEfficiency)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,brand,model,year,licensePlate,fuelEfficiency,nickname,createdAt);

@override
String toString() {
  return 'Vehicle(id: $id, userId: $userId, brand: $brand, model: $model, year: $year, licensePlate: $licensePlate, fuelEfficiency: $fuelEfficiency, nickname: $nickname, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $VehicleCopyWith<$Res>  {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) _then) = _$VehicleCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? id, String userId, String brand, String model, int year, String licensePlate, double fuelEfficiency, String? nickname,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) Timestamp createdAt
});




}
/// @nodoc
class _$VehicleCopyWithImpl<$Res>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._self, this._then);

  final Vehicle _self;
  final $Res Function(Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? brand = null,Object? model = null,Object? year = null,Object? licensePlate = null,Object? fuelEfficiency = null,Object? nickname = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,licensePlate: null == licensePlate ? _self.licensePlate : licensePlate // ignore: cast_nullable_to_non_nullable
as String,fuelEfficiency: null == fuelEfficiency ? _self.fuelEfficiency : fuelEfficiency // ignore: cast_nullable_to_non_nullable
as double,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}

}


/// Adds pattern-matching-related methods to [Vehicle].
extension VehiclePatterns on Vehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vehicle value)  $default,){
final _that = this;
switch (_that) {
case _Vehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vehicle value)?  $default,){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id,  String userId,  String brand,  String model,  int year,  String licensePlate,  double fuelEfficiency,  String? nickname, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  Timestamp createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.userId,_that.brand,_that.model,_that.year,_that.licensePlate,_that.fuelEfficiency,_that.nickname,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? id,  String userId,  String brand,  String model,  int year,  String licensePlate,  double fuelEfficiency,  String? nickname, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  Timestamp createdAt)  $default,) {final _that = this;
switch (_that) {
case _Vehicle():
return $default(_that.id,_that.userId,_that.brand,_that.model,_that.year,_that.licensePlate,_that.fuelEfficiency,_that.nickname,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? id,  String userId,  String brand,  String model,  int year,  String licensePlate,  double fuelEfficiency,  String? nickname, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  Timestamp createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.userId,_that.brand,_that.model,_that.year,_that.licensePlate,_that.fuelEfficiency,_that.nickname,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vehicle implements Vehicle {
  const _Vehicle({@JsonKey(includeIfNull: false) this.id, required this.userId, required this.brand, required this.model, required this.year, required this.licensePlate, required this.fuelEfficiency, this.nickname, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.createdAt});
  factory _Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

@override@JsonKey(includeIfNull: false) final  String? id;
@override final  String userId;
@override final  String brand;
@override final  String model;
@override final  int year;
@override final  String licensePlate;
@override final  double fuelEfficiency;
@override final  String? nickname;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  Timestamp createdAt;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleCopyWith<_Vehicle> get copyWith => __$VehicleCopyWithImpl<_Vehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.year, year) || other.year == year)&&(identical(other.licensePlate, licensePlate) || other.licensePlate == licensePlate)&&(identical(other.fuelEfficiency, fuelEfficiency) || other.fuelEfficiency == fuelEfficiency)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,brand,model,year,licensePlate,fuelEfficiency,nickname,createdAt);

@override
String toString() {
  return 'Vehicle(id: $id, userId: $userId, brand: $brand, model: $model, year: $year, licensePlate: $licensePlate, fuelEfficiency: $fuelEfficiency, nickname: $nickname, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$VehicleCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$VehicleCopyWith(_Vehicle value, $Res Function(_Vehicle) _then) = __$VehicleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? id, String userId, String brand, String model, int year, String licensePlate, double fuelEfficiency, String? nickname,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) Timestamp createdAt
});




}
/// @nodoc
class __$VehicleCopyWithImpl<$Res>
    implements _$VehicleCopyWith<$Res> {
  __$VehicleCopyWithImpl(this._self, this._then);

  final _Vehicle _self;
  final $Res Function(_Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? brand = null,Object? model = null,Object? year = null,Object? licensePlate = null,Object? fuelEfficiency = null,Object? nickname = freezed,Object? createdAt = null,}) {
  return _then(_Vehicle(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,licensePlate: null == licensePlate ? _self.licensePlate : licensePlate // ignore: cast_nullable_to_non_nullable
as String,fuelEfficiency: null == fuelEfficiency ? _self.fuelEfficiency : fuelEfficiency // ignore: cast_nullable_to_non_nullable
as double,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}


}

// dart format on
