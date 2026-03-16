// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expense {

 String? get id; String get vehicleId; String get userId; DateTime get date; ExpenseType get type; double get amount; int get odometer; String? get description; double? get liters; double? get pricePerLiter; bool get isCash;// Nuevo campo para trackear pago en efectivo
 String get category;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.description, description) || other.description == description)&&(identical(other.liters, liters) || other.liters == liters)&&(identical(other.pricePerLiter, pricePerLiter) || other.pricePerLiter == pricePerLiter)&&(identical(other.isCash, isCash) || other.isCash == isCash)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,userId,date,type,amount,odometer,description,liters,pricePerLiter,isCash,category);

@override
String toString() {
  return 'Expense(id: $id, vehicleId: $vehicleId, userId: $userId, date: $date, type: $type, amount: $amount, odometer: $odometer, description: $description, liters: $liters, pricePerLiter: $pricePerLiter, isCash: $isCash, category: $category)';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 String? id, String vehicleId, String userId, DateTime date, ExpenseType type, double amount, int odometer, String? description, double? liters, double? pricePerLiter, bool isCash, String category
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? vehicleId = null,Object? userId = null,Object? date = null,Object? type = null,Object? amount = null,Object? odometer = null,Object? description = freezed,Object? liters = freezed,Object? pricePerLiter = freezed,Object? isCash = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ExpenseType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,odometer: null == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,liters: freezed == liters ? _self.liters : liters // ignore: cast_nullable_to_non_nullable
as double?,pricePerLiter: freezed == pricePerLiter ? _self.pricePerLiter : pricePerLiter // ignore: cast_nullable_to_non_nullable
as double?,isCash: null == isCash ? _self.isCash : isCash // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String vehicleId,  String userId,  DateTime date,  ExpenseType type,  double amount,  int odometer,  String? description,  double? liters,  double? pricePerLiter,  bool isCash,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.vehicleId,_that.userId,_that.date,_that.type,_that.amount,_that.odometer,_that.description,_that.liters,_that.pricePerLiter,_that.isCash,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String vehicleId,  String userId,  DateTime date,  ExpenseType type,  double amount,  int odometer,  String? description,  double? liters,  double? pricePerLiter,  bool isCash,  String category)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.vehicleId,_that.userId,_that.date,_that.type,_that.amount,_that.odometer,_that.description,_that.liters,_that.pricePerLiter,_that.isCash,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String vehicleId,  String userId,  DateTime date,  ExpenseType type,  double amount,  int odometer,  String? description,  double? liters,  double? pricePerLiter,  bool isCash,  String category)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.vehicleId,_that.userId,_that.date,_that.type,_that.amount,_that.odometer,_that.description,_that.liters,_that.pricePerLiter,_that.isCash,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense implements Expense {
  const _Expense({this.id, required this.vehicleId, required this.userId, required this.date, required this.type, required this.amount, required this.odometer, this.description, this.liters = 0.0, this.pricePerLiter = 0.0, this.isCash = false, required this.category});
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override final  String? id;
@override final  String vehicleId;
@override final  String userId;
@override final  DateTime date;
@override final  ExpenseType type;
@override final  double amount;
@override final  int odometer;
@override final  String? description;
@override@JsonKey() final  double? liters;
@override@JsonKey() final  double? pricePerLiter;
@override@JsonKey() final  bool isCash;
// Nuevo campo para trackear pago en efectivo
@override final  String category;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.odometer, odometer) || other.odometer == odometer)&&(identical(other.description, description) || other.description == description)&&(identical(other.liters, liters) || other.liters == liters)&&(identical(other.pricePerLiter, pricePerLiter) || other.pricePerLiter == pricePerLiter)&&(identical(other.isCash, isCash) || other.isCash == isCash)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vehicleId,userId,date,type,amount,odometer,description,liters,pricePerLiter,isCash,category);

@override
String toString() {
  return 'Expense(id: $id, vehicleId: $vehicleId, userId: $userId, date: $date, type: $type, amount: $amount, odometer: $odometer, description: $description, liters: $liters, pricePerLiter: $pricePerLiter, isCash: $isCash, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 String? id, String vehicleId, String userId, DateTime date, ExpenseType type, double amount, int odometer, String? description, double? liters, double? pricePerLiter, bool isCash, String category
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? vehicleId = null,Object? userId = null,Object? date = null,Object? type = null,Object? amount = null,Object? odometer = null,Object? description = freezed,Object? liters = freezed,Object? pricePerLiter = freezed,Object? isCash = null,Object? category = null,}) {
  return _then(_Expense(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ExpenseType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,odometer: null == odometer ? _self.odometer : odometer // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,liters: freezed == liters ? _self.liters : liters // ignore: cast_nullable_to_non_nullable
as double?,pricePerLiter: freezed == pricePerLiter ? _self.pricePerLiter : pricePerLiter // ignore: cast_nullable_to_non_nullable
as double?,isCash: null == isCash ? _self.isCash : isCash // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
