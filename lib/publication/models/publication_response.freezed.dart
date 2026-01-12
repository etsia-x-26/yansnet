// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publication_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PublicationResponse _$PublicationResponseFromJson(Map<String, dynamic> json) {
  return _PublicationResponse.fromJson(json);
}

/// @nodoc
mixin _$PublicationResponse {
  List<Publication> get content => throw _privateConstructorUsedError;
  int get pageNumber => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get last => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PublicationResponseCopyWith<PublicationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicationResponseCopyWith<$Res> {
  factory $PublicationResponseCopyWith(
          PublicationResponse value, $Res Function(PublicationResponse) then) =
      _$PublicationResponseCopyWithImpl<$Res, PublicationResponse>;
  @useResult
  $Res call(
      {List<Publication> content,
      int pageNumber,
      int pageSize,
      int totalElements,
      int totalPages,
      bool last});
}

/// @nodoc
class _$PublicationResponseCopyWithImpl<$Res, $Val extends PublicationResponse>
    implements $PublicationResponseCopyWith<$Res> {
  _$PublicationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? pageNumber = null,
    Object? pageSize = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? last = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as List<Publication>,
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      last: null == last
          ? _value.last
          : last // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PublicationResponseImplCopyWith<$Res>
    implements $PublicationResponseCopyWith<$Res> {
  factory _$$PublicationResponseImplCopyWith(_$PublicationResponseImpl value,
          $Res Function(_$PublicationResponseImpl) then) =
      __$$PublicationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Publication> content,
      int pageNumber,
      int pageSize,
      int totalElements,
      int totalPages,
      bool last});
}

/// @nodoc
class __$$PublicationResponseImplCopyWithImpl<$Res>
    extends _$PublicationResponseCopyWithImpl<$Res, _$PublicationResponseImpl>
    implements _$$PublicationResponseImplCopyWith<$Res> {
  __$$PublicationResponseImplCopyWithImpl(_$PublicationResponseImpl _value,
      $Res Function(_$PublicationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? pageNumber = null,
    Object? pageSize = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? last = null,
  }) {
    return _then(_$PublicationResponseImpl(
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as List<Publication>,
      pageNumber: null == pageNumber
          ? _value.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      last: null == last
          ? _value.last
          : last // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicationResponseImpl implements _PublicationResponse {
  const _$PublicationResponseImpl(
      {required final List<Publication> content,
      required this.pageNumber,
      required this.pageSize,
      required this.totalElements,
      required this.totalPages,
      required this.last})
      : _content = content;

  factory _$PublicationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicationResponseImplFromJson(json);

  final List<Publication> _content;
  @override
  List<Publication> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  final int pageNumber;
  @override
  final int pageSize;
  @override
  final int totalElements;
  @override
  final int totalPages;
  @override
  final bool last;

  @override
  String toString() {
    return 'PublicationResponse(content: $content, pageNumber: $pageNumber, pageSize: $pageSize, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicationResponseImpl &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.last, last) || other.last == last));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_content),
      pageNumber,
      pageSize,
      totalElements,
      totalPages,
      last);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicationResponseImplCopyWith<_$PublicationResponseImpl> get copyWith =>
      __$$PublicationResponseImplCopyWithImpl<_$PublicationResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicationResponseImplToJson(
      this,
    );
  }
}

abstract class _PublicationResponse implements PublicationResponse {
  const factory _PublicationResponse(
      {required final List<Publication> content,
      required final int pageNumber,
      required final int pageSize,
      required final int totalElements,
      required final int totalPages,
      required final bool last}) = _$PublicationResponseImpl;

  factory _PublicationResponse.fromJson(Map<String, dynamic> json) =
      _$PublicationResponseImpl.fromJson;

  @override
  List<Publication> get content;
  @override
  int get pageNumber;
  @override
  int get pageSize;
  @override
  int get totalElements;
  @override
  int get totalPages;
  @override
  bool get last;
  @override
  @JsonKey(ignore: true)
  _$$PublicationResponseImplCopyWith<_$PublicationResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Publication _$PublicationFromJson(Map<String, dynamic> json) {
  return _Publication.fromJson(json);
}

/// @nodoc
mixin _$Publication {
  int get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;
  Channel get channel => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  int get totalLikes => throw _privateConstructorUsedError;
  int get totalComments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PublicationCopyWith<Publication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicationCopyWith<$Res> {
  factory $PublicationCopyWith(
          Publication value, $Res Function(Publication) then) =
      _$PublicationCopyWithImpl<$Res, Publication>;
  @useResult
  $Res call(
      {int id,
      String content,
      DateTime createdAt,
      User user,
      Channel channel,
      DateTime? deletedAt,
      int totalLikes,
      int totalComments});

  $UserCopyWith<$Res> get user;
  $ChannelCopyWith<$Res> get channel;
}

/// @nodoc
class _$PublicationCopyWithImpl<$Res, $Val extends Publication>
    implements $PublicationCopyWith<$Res> {
  _$PublicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
    Object? user = null,
    Object? channel = null,
    Object? deletedAt = freezed,
    Object? totalLikes = null,
    Object? totalComments = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as Channel,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalLikes: null == totalLikes
          ? _value.totalLikes
          : totalLikes // ignore: cast_nullable_to_non_nullable
              as int,
      totalComments: null == totalComments
          ? _value.totalComments
          : totalComments // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ChannelCopyWith<$Res> get channel {
    return $ChannelCopyWith<$Res>(_value.channel, (value) {
      return _then(_value.copyWith(channel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PublicationImplCopyWith<$Res>
    implements $PublicationCopyWith<$Res> {
  factory _$$PublicationImplCopyWith(
          _$PublicationImpl value, $Res Function(_$PublicationImpl) then) =
      __$$PublicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String content,
      DateTime createdAt,
      User user,
      Channel channel,
      DateTime? deletedAt,
      int totalLikes,
      int totalComments});

  @override
  $UserCopyWith<$Res> get user;
  @override
  $ChannelCopyWith<$Res> get channel;
}

/// @nodoc
class __$$PublicationImplCopyWithImpl<$Res>
    extends _$PublicationCopyWithImpl<$Res, _$PublicationImpl>
    implements _$$PublicationImplCopyWith<$Res> {
  __$$PublicationImplCopyWithImpl(
      _$PublicationImpl _value, $Res Function(_$PublicationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
    Object? user = null,
    Object? channel = null,
    Object? deletedAt = freezed,
    Object? totalLikes = null,
    Object? totalComments = null,
  }) {
    return _then(_$PublicationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as Channel,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalLikes: null == totalLikes
          ? _value.totalLikes
          : totalLikes // ignore: cast_nullable_to_non_nullable
              as int,
      totalComments: null == totalComments
          ? _value.totalComments
          : totalComments // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PublicationImpl implements _Publication {
  const _$PublicationImpl(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.user,
      required this.channel,
      this.deletedAt,
      this.totalLikes = 0,
      this.totalComments = 0});

  factory _$PublicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicationImplFromJson(json);

  @override
  final int id;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final User user;
  @override
  final Channel channel;
  @override
  final DateTime? deletedAt;
  @override
  @JsonKey()
  final int totalLikes;
  @override
  @JsonKey()
  final int totalComments;

  @override
  String toString() {
    return 'Publication(id: $id, content: $content, createdAt: $createdAt, user: $user, channel: $channel, deletedAt: $deletedAt, totalLikes: $totalLikes, totalComments: $totalComments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.totalLikes, totalLikes) ||
                other.totalLikes == totalLikes) &&
            (identical(other.totalComments, totalComments) ||
                other.totalComments == totalComments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, content, createdAt, user,
      channel, deletedAt, totalLikes, totalComments);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicationImplCopyWith<_$PublicationImpl> get copyWith =>
      __$$PublicationImplCopyWithImpl<_$PublicationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicationImplToJson(
      this,
    );
  }
}

abstract class _Publication implements Publication {
  const factory _Publication(
      {required final int id,
      required final String content,
      required final DateTime createdAt,
      required final User user,
      required final Channel channel,
      final DateTime? deletedAt,
      final int totalLikes,
      final int totalComments}) = _$PublicationImpl;

  factory _Publication.fromJson(Map<String, dynamic> json) =
      _$PublicationImpl.fromJson;

  @override
  int get id;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  User get user;
  @override
  Channel get channel;
  @override
  DateTime? get deletedAt;
  @override
  int get totalLikes;
  @override
  int get totalComments;
  @override
  @JsonKey(ignore: true)
  _$$PublicationImplCopyWith<_$PublicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int? get id => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool? get isBlocked => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  String? get batch => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  int get totalFollowers => throw _privateConstructorUsedError;
  int get totalFollowing => throw _privateConstructorUsedError;
  int get totalPosts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int? id,
      String? password,
      bool? isActive,
      String? category,
      bool? isBlocked,
      String? department,
      String? batch,
      String? email,
      String? phoneNumber,
      int totalFollowers,
      int totalFollowing,
      int totalPosts});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? password = freezed,
    Object? isActive = freezed,
    Object? category = freezed,
    Object? isBlocked = freezed,
    Object? department = freezed,
    Object? batch = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? totalFollowers = null,
    Object? totalFollowing = null,
    Object? totalPosts = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isBlocked: freezed == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      batch: freezed == batch
          ? _value.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      totalFollowers: null == totalFollowers
          ? _value.totalFollowers
          : totalFollowers // ignore: cast_nullable_to_non_nullable
              as int,
      totalFollowing: null == totalFollowing
          ? _value.totalFollowing
          : totalFollowing // ignore: cast_nullable_to_non_nullable
              as int,
      totalPosts: null == totalPosts
          ? _value.totalPosts
          : totalPosts // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? password,
      bool? isActive,
      String? category,
      bool? isBlocked,
      String? department,
      String? batch,
      String? email,
      String? phoneNumber,
      int totalFollowers,
      int totalFollowing,
      int totalPosts});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? password = freezed,
    Object? isActive = freezed,
    Object? category = freezed,
    Object? isBlocked = freezed,
    Object? department = freezed,
    Object? batch = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
    Object? totalFollowers = null,
    Object? totalFollowing = null,
    Object? totalPosts = null,
  }) {
    return _then(_$UserImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isBlocked: freezed == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      batch: freezed == batch
          ? _value.batch
          : batch // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      totalFollowers: null == totalFollowers
          ? _value.totalFollowers
          : totalFollowers // ignore: cast_nullable_to_non_nullable
              as int,
      totalFollowing: null == totalFollowing
          ? _value.totalFollowing
          : totalFollowing // ignore: cast_nullable_to_non_nullable
              as int,
      totalPosts: null == totalPosts
          ? _value.totalPosts
          : totalPosts // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {this.id,
      this.password,
      this.isActive,
      this.category,
      this.isBlocked,
      this.department,
      this.batch,
      this.email,
      this.phoneNumber,
      this.totalFollowers = 0,
      this.totalFollowing = 0,
      this.totalPosts = 0});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final int? id;
  @override
  final String? password;
  @override
  final bool? isActive;
  @override
  final String? category;
  @override
  final bool? isBlocked;
  @override
  final String? department;
  @override
  final String? batch;
  @override
  final String? email;
  @override
  final String? phoneNumber;
  @override
  @JsonKey()
  final int totalFollowers;
  @override
  @JsonKey()
  final int totalFollowing;
  @override
  @JsonKey()
  final int totalPosts;

  @override
  String toString() {
    return 'User(id: $id, password: $password, isActive: $isActive, category: $category, isBlocked: $isBlocked, department: $department, batch: $batch, email: $email, phoneNumber: $phoneNumber, totalFollowers: $totalFollowers, totalFollowing: $totalFollowing, totalPosts: $totalPosts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.batch, batch) || other.batch == batch) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.totalFollowers, totalFollowers) ||
                other.totalFollowers == totalFollowers) &&
            (identical(other.totalFollowing, totalFollowing) ||
                other.totalFollowing == totalFollowing) &&
            (identical(other.totalPosts, totalPosts) ||
                other.totalPosts == totalPosts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      password,
      isActive,
      category,
      isBlocked,
      department,
      batch,
      email,
      phoneNumber,
      totalFollowers,
      totalFollowing,
      totalPosts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {final int? id,
      final String? password,
      final bool? isActive,
      final String? category,
      final bool? isBlocked,
      final String? department,
      final String? batch,
      final String? email,
      final String? phoneNumber,
      final int totalFollowers,
      final int totalFollowing,
      final int totalPosts}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  int? get id;
  @override
  String? get password;
  @override
  bool? get isActive;
  @override
  String? get category;
  @override
  bool? get isBlocked;
  @override
  String? get department;
  @override
  String? get batch;
  @override
  String? get email;
  @override
  String? get phoneNumber;
  @override
  int get totalFollowers;
  @override
  int get totalFollowing;
  @override
  int get totalPosts;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return _Channel.fromJson(json);
}

/// @nodoc
mixin _$Channel {
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get totalFollowers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChannelCopyWith<Channel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelCopyWith<$Res> {
  factory $ChannelCopyWith(Channel value, $Res Function(Channel) then) =
      _$ChannelCopyWithImpl<$Res, Channel>;
  @useResult
  $Res call({int? id, String? title, String? description, int totalFollowers});
}

/// @nodoc
class _$ChannelCopyWithImpl<$Res, $Val extends Channel>
    implements $ChannelCopyWith<$Res> {
  _$ChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? totalFollowers = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      totalFollowers: null == totalFollowers
          ? _value.totalFollowers
          : totalFollowers // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChannelImplCopyWith<$Res> implements $ChannelCopyWith<$Res> {
  factory _$$ChannelImplCopyWith(
          _$ChannelImpl value, $Res Function(_$ChannelImpl) then) =
      __$$ChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? title, String? description, int totalFollowers});
}

/// @nodoc
class __$$ChannelImplCopyWithImpl<$Res>
    extends _$ChannelCopyWithImpl<$Res, _$ChannelImpl>
    implements _$$ChannelImplCopyWith<$Res> {
  __$$ChannelImplCopyWithImpl(
      _$ChannelImpl _value, $Res Function(_$ChannelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? totalFollowers = null,
  }) {
    return _then(_$ChannelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      totalFollowers: null == totalFollowers
          ? _value.totalFollowers
          : totalFollowers // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChannelImpl implements _Channel {
  const _$ChannelImpl(
      {this.id, this.title, this.description, this.totalFollowers = 0});

  factory _$ChannelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChannelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey()
  final int totalFollowers;

  @override
  String toString() {
    return 'Channel(id: $id, title: $title, description: $description, totalFollowers: $totalFollowers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.totalFollowers, totalFollowers) ||
                other.totalFollowers == totalFollowers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, description, totalFollowers);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelImplCopyWith<_$ChannelImpl> get copyWith =>
      __$$ChannelImplCopyWithImpl<_$ChannelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChannelImplToJson(
      this,
    );
  }
}

abstract class _Channel implements Channel {
  const factory _Channel(
      {final int? id,
      final String? title,
      final String? description,
      final int totalFollowers}) = _$ChannelImpl;

  factory _Channel.fromJson(Map<String, dynamic> json) = _$ChannelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get title;
  @override
  String? get description;
  @override
  int get totalFollowers;
  @override
  @JsonKey(ignore: true)
  _$$ChannelImplCopyWith<_$ChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
