// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resource_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ResourcePage {
  List<StudyResource> get items => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Create a copy of ResourcePage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResourcePageCopyWith<ResourcePage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResourcePageCopyWith<$Res> {
  factory $ResourcePageCopyWith(
          ResourcePage value, $Res Function(ResourcePage) then) =
      _$ResourcePageCopyWithImpl<$Res, ResourcePage>;
  @useResult
  $Res call({List<StudyResource> items, int page, bool hasMore});
}

/// @nodoc
class _$ResourcePageCopyWithImpl<$Res, $Val extends ResourcePage>
    implements $ResourcePageCopyWith<$Res> {
  _$ResourcePageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResourcePage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<StudyResource>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResourcePageImplCopyWith<$Res>
    implements $ResourcePageCopyWith<$Res> {
  factory _$$ResourcePageImplCopyWith(
          _$ResourcePageImpl value, $Res Function(_$ResourcePageImpl) then) =
      __$$ResourcePageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StudyResource> items, int page, bool hasMore});
}

/// @nodoc
class __$$ResourcePageImplCopyWithImpl<$Res>
    extends _$ResourcePageCopyWithImpl<$Res, _$ResourcePageImpl>
    implements _$$ResourcePageImplCopyWith<$Res> {
  __$$ResourcePageImplCopyWithImpl(
      _$ResourcePageImpl _value, $Res Function(_$ResourcePageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResourcePage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? hasMore = null,
  }) {
    return _then(_$ResourcePageImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<StudyResource>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ResourcePageImpl implements _ResourcePage {
  const _$ResourcePageImpl(
      {required final List<StudyResource> items,
      required this.page,
      required this.hasMore})
      : _items = items;

  final List<StudyResource> _items;
  @override
  List<StudyResource> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int page;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'ResourcePage(items: $items, page: $page, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResourcePageImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), page, hasMore);

  /// Create a copy of ResourcePage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResourcePageImplCopyWith<_$ResourcePageImpl> get copyWith =>
      __$$ResourcePageImplCopyWithImpl<_$ResourcePageImpl>(this, _$identity);
}

abstract class _ResourcePage implements ResourcePage {
  const factory _ResourcePage(
      {required final List<StudyResource> items,
      required final int page,
      required final bool hasMore}) = _$ResourcePageImpl;

  @override
  List<StudyResource> get items;
  @override
  int get page;
  @override
  bool get hasMore;

  /// Create a copy of ResourcePage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResourcePageImplCopyWith<_$ResourcePageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
