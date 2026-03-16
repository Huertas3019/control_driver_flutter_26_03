// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Income {

 String? get id; String get vehicleId; String get userId; DateTime get date; String get platform; int get initialOdometer; int? get finalOdometer; double? get subtotalEarning; double? get extraEarning; double get fuelCostForDay; int get kilometersDriven; double get totalEarning; bool get isCompleted;
/// Create a copy of Income
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeCopyWith<Income> get copyWith => _$IncomeCopyWithImpl<Income>(this as Income, _$identity);

  /// Serializes this Income to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Income&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.initialOdometer, initialOdometer) || other.initialOdometer == initialOdometer)&&(identical(other.finalOdometer, finalOdometer) || other.finalOdometer == finalOdometer)&&(identical(other.subtotalEarning, subtotalEarning) || other.subtotalEarning == subtotalEarning)&&(identical(other.extraEarning, extraEarning) || other.extraEarning == extraEarning)&&(identical(other.fuelCostForDay, fuelCostForDay) || other.fuelCostForDay == fuelCostForDay)&&(identical(other.kilometersDriven, kilometersDriven) || other.kilometersDriven == kilometersDriven)&&(identical(other.totalEarning, totalEarning) || other.totalEarning == totalEarning)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,userId,date,platform,initialOdometer,finalOdometer,subtotalEarning,extraEarning,fuelCostForDay,kilometersDriven,totalEarning,isCompleted);

@override
String toString() {
  return 'Income(id: $id, vehicleId: $vehicleId, userId: $userId, date: $date, platform: $platform, initialOdometer: $initialOdometer, finalOdometer: $finalOdometer, subtotalEarning: $subtotalEarning, extraEarning: $extraEarning, fuelCostForDay: $fuelCostForDay, kilometersDriven: $kilometersDriven, totalEarning: $totalEarning, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $IncomeCopyWith<$Res>  {
  factory $IncomeCopyWith(Income value, $Res Function(Income) _then) = _$IncomeCopyWithImpl;
@useResult
$Res call({
 String? id, String vehicleId, String userId, DateTime date, String platform, int initialOdometer, int? finalOdometer, double? subtotalEarning, double? extraEarning, double fuelCostForDay, int kilometersDriven, double totalEarning, bool isCompleted
});




}
/// @nodoc
class _$IncomeCopyWithImpl<$Res>
    implements $IncomeCopyWith<$Res> {
  _$IncomeCopyWithImpl(this._self, this._then);

  final Income _self;
  final $Res Function(Income) _then;

/// Create a copy of Income
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? vehicleId = null,Object? userId = null,Object? date = null,Object? platform = null,Object? initialOdometer = null,Object? finalOdometer = freezed,Object? subtotalEarning = freezed,Object? extraEarning = freezed,Object? fuelCostForDay = null,Object? kilometersDriven = null,Object? totalEarning = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,initialOdometer: null == initialOdometer ? _self.initialOdometer : initialOdometer // ignore: cast_nullable_to_non_nullable
as int,finalOdometer: freezed == finalOdometer ? _self.finalOdometer : finalOdometer // ignore: cast_nullable_to_non_nullable
as int?,subtotalEarning: freezed == subtotalEarning ? _self.subtotalEarning : subtotalEarning // ignore: cast_nullable_to_non_nullable
as double?,extraEarning: freezed == extraEarning ? _self.extraEarning : extraEarning // ignore: cast_nullable_to_non_nullable
as double?,fuelCostForDay: null == fuelCostForDay ? _self.fuelCostForDay : fuelCostForDay // ignore: cast_nullable_to_non_nullable
as double,kilometersDriven: null == kilometersDriven ? _self.kilometersDriven : kilometersDriven // ignore: cast_nullable_to_non_nullable
as int,totalEarning: null == totalEarning ? _self.totalEarning : totalEarning // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Income].
extension IncomePatterns on Income {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Income value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Income() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Income value)  $default,){
final _that = this;
switch (_that) {
case _Income():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Income value)?  $default,){
final _that = this;
switch (_that) {
case _Income() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String vehicleId,  String userId,  DateTime date,  String platform,  int initialOdometer,  int? finalOdometer,  double? subtotalEarning,  double? extraEarning,  double fuelCostForDay,  int kilometersDriven,  double totalEarning,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Income() when $default != null:
return $default(_that.id,_that.vehicleId,_that.userId,_that.date,_that.platform,_that.initialOdometer,_that.finalOdometer,_that.subtotalEarning,_that.extraEarning,_that.fuelCostForDay,_that.kilometersDriven,_that.totalEarning,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String vehicleId,  String userId,  DateTime date,  String platform,  int initialOdometer,  int? finalOdometer,  double? subtotalEarning,  double? extraEarning,  double fuelCostForDay,  int kilometersDriven,  double totalEarning,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _Income():
return $default(_that.id,_that.vehicleId,_that.userId,_that.date,_that.platform,_that.initialOdometer,_that.finalOdometer,_that.subtotalEarning,_that.extraEarning,_that.fuelCostForDay,_that.kilometersDriven,_that.totalEarning,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String vehicleId,  String userId,  DateTime date,  String platform,  int initialOdometer,  int? finalOdometer,  double? subtotalEarning,  double? extraEarning,  double fuelCostForDay,  int kilometersDriven,  double totalEarning,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _Income() when $default != null:
return $default(_that.id,_that.vehicleId,_that.userId,_that.date,_that.platform,_that.initialOdometer,_that.finalOdometer,_that.subtotalEarning,_that.extraEarning,_that.fuelCostForDay,_that.kilometersDriven,_that.totalEarning,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Income implements Income {
  const _Income({this.id, required this.vehicleId, required this.userId, required this.date, required this.platform, required this.initialOdometer, this.finalOdometer, this.subtotalEarning, this.extraEarning = 0.0, this.fuelCostForDay = 0.0, this.kilometersDriven = 0, this.totalEarning = 0.0, this.isCompleted = false});
  factory _Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);

@override final  String? id;
@override final  String vehicleId;
@override final  String userId;
@override final  DateTime date;
@override final  String platform;
@override final  int initialOdometer;
@override final  int? finalOdometer;
@override final  double? subtotalEarning;
@override@JsonKey() final  double? extraEarning;
@override@JsonKey() final  double fuelCostForDay;
@override@JsonKey() final  int kilometersDriven;
@override@JsonKey() final  double totalEarning;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of Income
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomeCopyWith<_Income> get copyWith => __$IncomeCopyWithImpl<_Income>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncomeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Income&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.initialOdometer, initialOdometer) || other.initialOdometer == initialOdometer)&&(identical(other.finalOdometer, finalOdometer) || other.finalOdometer == finalOdometer)&&(identical(other.subtotalEarning, subtotalEarning) || other.subtotalEarning == subtotalEarning)&&(identical(other.extraEarning, extraEarning) || other.extraEarning == extraEarning)&&(identical(other.fuelCostForDay, fuelCostForDay) || other.fuelCostForDay == fuelCostForDay)&&(identical(other.kilometersDriven, kilometersDriven) || other.kilometersDriven == kilometersDriven)&&(identical(other.totalEarning, totalEarning) || other.totalEarning == totalEarning)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,userId,date,platform,initialOdometer,finalOdometer,subtotalEarning,extraEarning,fuelCostForDay,kilometersDriven,totalEarning,isCompleted);

@override
String toString() {
  return 'Income(id: $id, vehicleId: $vehicleId, userId: $userId, date: $date, platform: $platform, initialOdometer: $initialOdometer, finalOdometer: $finalOdometer, subtotalEarning: $subtotalEarning, extraEarning: $extraEarning, fuelCostForDay: $fuelCostForDay, kilometersDriven: $kilometersDriven, totalEarning: $totalEarning, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$IncomeCopyWith<$Res> implements $IncomeCopyWith<$Res> {
  factory _$IncomeCopyWith(_Income value, $Res Function(_Income) _then) = __$IncomeCopyWithImpl;
@override @useResult
$Res call({
 String? id, String vehicleId, String userId, DateTime date, String platform, int initialOdometer, int? finalOdometer, double? subtotalEarning, double? extraEarning, double fuelCostForDay, int kilometersDriven, double totalEarning, bool isCompleted
});




}
/// @nodoc
class __$IncomeCopyWithImpl<$Res>
    implements _$IncomeCopyWith<$Res> {
  __$IncomeCopyWithImpl(this._self, this._then);

  final _Income _self;
  final $Res Function(_Income) _then;

/// Create a copy of Income
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? vehicleId = null,Object? userId = null,Object? date = null,Object? platform = null,Object? initialOdometer = null,Object? finalOdometer = freezed,Object? subtotalEarning = freezed,Object? extraEarning = freezed,Object? fuelCostForDay = null,Object? kilometersDriven = null,Object? totalEarning = null,Object? isCompleted = null,}) {
  return _then(_Income(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,initialOdometer: null == initialOdometer ? _self.initialOdometer : initialOdometer // ignore: cast_nullable_to_non_nullable
as int,finalOdometer: freezed == finalOdometer ? _self.finalOdometer : finalOdometer // ignore: cast_nullable_to_non_nullable
as int?,subtotalEarning: freezed == subtotalEarning ? _self.subtotalEarning : subtotalEarning // ignore: cast_nullable_to_non_nullable
as double?,extraEarning: freezed == extraEarning ? _self.extraEarning : extraEarning // ignore: cast_nullable_to_non_nullable
as double?,fuelCostForDay: null == fuelCostForDay ? _self.fuelCostForDay : fuelCostForDay // ignore: cast_nullable_to_non_nullable
as double,kilometersDriven: null == kilometersDriven ? _self.kilometersDriven : kilometersDriven // ignore: cast_nullable_to_non_nullable
as int,totalEarning: null == totalEarning ? _self.totalEarning : totalEarning // ignore: cast_nullable_to_non_nullable
as double,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
