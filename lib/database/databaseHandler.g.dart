// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'databaseHandler.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class User extends DataClass implements Insertable<User> {
  final int id;
  final String userName;
  final String fullName;
  final String email;
  final String password;
  User(
      {required this.id,
      required this.userName,
      required this.fullName,
      required this.email,
      required this.password});
  factory User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return User(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      userName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_name'])!,
      fullName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}full_name'])!,
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email'])!,
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      userName: Value(userName),
      fullName: Value(fullName),
      email: Value(email),
      password: Value(password),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
    };
  }

  User copyWith(
          {int? id,
          String? userName,
          String? fullName,
          String? email,
          String? password}) =>
      User(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(userName.hashCode,
          $mrjc(fullName.hashCode, $mrjc(email.hashCode, password.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.password == this.password);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String> password;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String userName,
    required String fullName,
    required String email,
    required String password,
  })  : userName = Value(userName),
        fullName = Value(fullName),
        email = Value(email),
        password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? password,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? userName,
      Value<String>? fullName,
      Value<String>? email,
      Value<String>? password}) {
    return UsersCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _userNameMeta = const VerificationMeta('userName');
  late final GeneratedColumn<String?> userName =
      GeneratedColumn<String?>('user_name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 6,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: true,
          $customConstraints: 'UNIQUE');
  final VerificationMeta _fullNameMeta = const VerificationMeta('fullName');
  late final GeneratedColumn<String?> fullName =
      GeneratedColumn<String?>('full_name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 6,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: true);
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  late final GeneratedColumn<String?> email = GeneratedColumn<String?>(
      'email', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  late final GeneratedColumn<String?> password =
      GeneratedColumn<String?>('password', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 6,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userName, fullName, email, password];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    return User.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }
}

class Dosimeter extends DataClass implements Insertable<Dosimeter> {
  final int id;
  final String name;
  final String color;
  final double totalDose;
  Dosimeter(
      {required this.id,
      required this.name,
      required this.color,
      required this.totalDose});
  factory Dosimeter.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Dosimeter(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      color: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color'])!,
      totalDose: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total_dose'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['total_dose'] = Variable<double>(totalDose);
    return map;
  }

  DosimetersCompanion toCompanion(bool nullToAbsent) {
    return DosimetersCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      totalDose: Value(totalDose),
    );
  }

  factory Dosimeter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Dosimeter(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      totalDose: serializer.fromJson<double>(json['totalDose']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'totalDose': serializer.toJson<double>(totalDose),
    };
  }

  Dosimeter copyWith(
          {int? id, String? name, String? color, double? totalDose}) =>
      Dosimeter(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        totalDose: totalDose ?? this.totalDose,
      );
  @override
  String toString() {
    return (StringBuffer('Dosimeter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('totalDose: $totalDose')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(color.hashCode, totalDose.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dosimeter &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.totalDose == this.totalDose);
}

class DosimetersCompanion extends UpdateCompanion<Dosimeter> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  final Value<double> totalDose;
  const DosimetersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.totalDose = const Value.absent(),
  });
  DosimetersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String color,
    required double totalDose,
  })  : name = Value(name),
        color = Value(color),
        totalDose = Value(totalDose);
  static Insertable<Dosimeter> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<double>? totalDose,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (totalDose != null) 'total_dose': totalDose,
    });
  }

  DosimetersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? color,
      Value<double>? totalDose}) {
    return DosimetersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      totalDose: totalDose ?? this.totalDose,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (totalDose.present) {
      map['total_dose'] = Variable<double>(totalDose.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DosimetersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('totalDose: $totalDose')
          ..write(')'))
        .toString();
  }
}

class $DosimetersTable extends Dosimeters
    with TableInfo<$DosimetersTable, Dosimeter> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DosimetersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name =
      GeneratedColumn<String?>('name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 6,
          ),
          typeName: 'TEXT',
          requiredDuringInsert: true,
          $customConstraints: 'UNIQUE');
  final VerificationMeta _colorMeta = const VerificationMeta('color');
  late final GeneratedColumn<String?> color = GeneratedColumn<String?>(
      'color', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _totalDoseMeta = const VerificationMeta('totalDose');
  late final GeneratedColumn<double?> totalDose = GeneratedColumn<double?>(
      'total_dose', aliasedName, false,
      typeName: 'REAL', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, color, totalDose];
  @override
  String get aliasedName => _alias ?? 'dosimeters';
  @override
  String get actualTableName => 'dosimeters';
  @override
  VerificationContext validateIntegrity(Insertable<Dosimeter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('total_dose')) {
      context.handle(_totalDoseMeta,
          totalDose.isAcceptableOrUnknown(data['total_dose']!, _totalDoseMeta));
    } else if (isInserting) {
      context.missing(_totalDoseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dosimeter map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Dosimeter.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DosimetersTable createAlias(String alias) {
    return $DosimetersTable(_db, alias);
  }
}

class Measurement extends DataClass implements Insertable<Measurement> {
  final int id;
  final String name;
  final int userId;
  final int dosimeterId;
  final double totalDose;
  Measurement(
      {required this.id,
      required this.name,
      required this.userId,
      required this.dosimeterId,
      required this.totalDose});
  factory Measurement.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Measurement(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      userId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      dosimeterId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dosimeter_id'])!,
      totalDose: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}total_dose'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['user_id'] = Variable<int>(userId);
    map['dosimeter_id'] = Variable<int>(dosimeterId);
    map['total_dose'] = Variable<double>(totalDose);
    return map;
  }

  MeasurementsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementsCompanion(
      id: Value(id),
      name: Value(name),
      userId: Value(userId),
      dosimeterId: Value(dosimeterId),
      totalDose: Value(totalDose),
    );
  }

  factory Measurement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Measurement(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      userId: serializer.fromJson<int>(json['userId']),
      dosimeterId: serializer.fromJson<int>(json['dosimeterId']),
      totalDose: serializer.fromJson<double>(json['totalDose']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'userId': serializer.toJson<int>(userId),
      'dosimeterId': serializer.toJson<int>(dosimeterId),
      'totalDose': serializer.toJson<double>(totalDose),
    };
  }

  Measurement copyWith(
          {int? id,
          String? name,
          int? userId,
          int? dosimeterId,
          double? totalDose}) =>
      Measurement(
        id: id ?? this.id,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        dosimeterId: dosimeterId ?? this.dosimeterId,
        totalDose: totalDose ?? this.totalDose,
      );
  @override
  String toString() {
    return (StringBuffer('Measurement(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('userId: $userId, ')
          ..write('dosimeterId: $dosimeterId, ')
          ..write('totalDose: $totalDose')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(userId.hashCode,
              $mrjc(dosimeterId.hashCode, totalDose.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Measurement &&
          other.id == this.id &&
          other.name == this.name &&
          other.userId == this.userId &&
          other.dosimeterId == this.dosimeterId &&
          other.totalDose == this.totalDose);
}

class MeasurementsCompanion extends UpdateCompanion<Measurement> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> userId;
  final Value<int> dosimeterId;
  final Value<double> totalDose;
  const MeasurementsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.userId = const Value.absent(),
    this.dosimeterId = const Value.absent(),
    this.totalDose = const Value.absent(),
  });
  MeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int userId,
    required int dosimeterId,
    required double totalDose,
  })  : name = Value(name),
        userId = Value(userId),
        dosimeterId = Value(dosimeterId),
        totalDose = Value(totalDose);
  static Insertable<Measurement> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? userId,
    Expression<int>? dosimeterId,
    Expression<double>? totalDose,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (userId != null) 'user_id': userId,
      if (dosimeterId != null) 'dosimeter_id': dosimeterId,
      if (totalDose != null) 'total_dose': totalDose,
    });
  }

  MeasurementsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? userId,
      Value<int>? dosimeterId,
      Value<double>? totalDose}) {
    return MeasurementsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      dosimeterId: dosimeterId ?? this.dosimeterId,
      totalDose: totalDose ?? this.totalDose,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (dosimeterId.present) {
      map['dosimeter_id'] = Variable<int>(dosimeterId.value);
    }
    if (totalDose.present) {
      map['total_dose'] = Variable<double>(totalDose.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('userId: $userId, ')
          ..write('dosimeterId: $dosimeterId, ')
          ..write('totalDose: $totalDose')
          ..write(')'))
        .toString();
  }
}

class $MeasurementsTable extends Measurements
    with TableInfo<$MeasurementsTable, Measurement> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MeasurementsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<int?> userId = GeneratedColumn<int?>(
      'user_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES users(id)');
  final VerificationMeta _dosimeterIdMeta =
      const VerificationMeta('dosimeterId');
  late final GeneratedColumn<int?> dosimeterId = GeneratedColumn<int?>(
      'dosimeter_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES dosimeters(id)');
  final VerificationMeta _totalDoseMeta = const VerificationMeta('totalDose');
  late final GeneratedColumn<double?> totalDose = GeneratedColumn<double?>(
      'total_dose', aliasedName, false,
      typeName: 'REAL', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, userId, dosimeterId, totalDose];
  @override
  String get aliasedName => _alias ?? 'measurements';
  @override
  String get actualTableName => 'measurements';
  @override
  VerificationContext validateIntegrity(Insertable<Measurement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('dosimeter_id')) {
      context.handle(
          _dosimeterIdMeta,
          dosimeterId.isAcceptableOrUnknown(
              data['dosimeter_id']!, _dosimeterIdMeta));
    } else if (isInserting) {
      context.missing(_dosimeterIdMeta);
    }
    if (data.containsKey('total_dose')) {
      context.handle(_totalDoseMeta,
          totalDose.isAcceptableOrUnknown(data['total_dose']!, _totalDoseMeta));
    } else if (isInserting) {
      context.missing(_totalDoseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Measurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Measurement.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MeasurementsTable createAlias(String alias) {
    return $MeasurementsTable(_db, alias);
  }
}

class Point extends DataClass implements Insertable<Point> {
  final int id;
  final int measurementId;
  final int time;
  final double dose;
  Point(
      {required this.id,
      required this.measurementId,
      required this.time,
      required this.dose});
  factory Point.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Point(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      measurementId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}measurement_id'])!,
      time: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time'])!,
      dose: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dose'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['measurement_id'] = Variable<int>(measurementId);
    map['time'] = Variable<int>(time);
    map['dose'] = Variable<double>(dose);
    return map;
  }

  PointsCompanion toCompanion(bool nullToAbsent) {
    return PointsCompanion(
      id: Value(id),
      measurementId: Value(measurementId),
      time: Value(time),
      dose: Value(dose),
    );
  }

  factory Point.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Point(
      id: serializer.fromJson<int>(json['id']),
      measurementId: serializer.fromJson<int>(json['measurementId']),
      time: serializer.fromJson<int>(json['time']),
      dose: serializer.fromJson<double>(json['dose']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'measurementId': serializer.toJson<int>(measurementId),
      'time': serializer.toJson<int>(time),
      'dose': serializer.toJson<double>(dose),
    };
  }

  Point copyWith({int? id, int? measurementId, int? time, double? dose}) =>
      Point(
        id: id ?? this.id,
        measurementId: measurementId ?? this.measurementId,
        time: time ?? this.time,
        dose: dose ?? this.dose,
      );
  @override
  String toString() {
    return (StringBuffer('Point(')
          ..write('id: $id, ')
          ..write('measurementId: $measurementId, ')
          ..write('time: $time, ')
          ..write('dose: $dose')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(measurementId.hashCode, $mrjc(time.hashCode, dose.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Point &&
          other.id == this.id &&
          other.measurementId == this.measurementId &&
          other.time == this.time &&
          other.dose == this.dose);
}

class PointsCompanion extends UpdateCompanion<Point> {
  final Value<int> id;
  final Value<int> measurementId;
  final Value<int> time;
  final Value<double> dose;
  const PointsCompanion({
    this.id = const Value.absent(),
    this.measurementId = const Value.absent(),
    this.time = const Value.absent(),
    this.dose = const Value.absent(),
  });
  PointsCompanion.insert({
    this.id = const Value.absent(),
    required int measurementId,
    required int time,
    required double dose,
  })  : measurementId = Value(measurementId),
        time = Value(time),
        dose = Value(dose);
  static Insertable<Point> custom({
    Expression<int>? id,
    Expression<int>? measurementId,
    Expression<int>? time,
    Expression<double>? dose,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measurementId != null) 'measurement_id': measurementId,
      if (time != null) 'time': time,
      if (dose != null) 'dose': dose,
    });
  }

  PointsCompanion copyWith(
      {Value<int>? id,
      Value<int>? measurementId,
      Value<int>? time,
      Value<double>? dose}) {
    return PointsCompanion(
      id: id ?? this.id,
      measurementId: measurementId ?? this.measurementId,
      time: time ?? this.time,
      dose: dose ?? this.dose,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (measurementId.present) {
      map['measurement_id'] = Variable<int>(measurementId.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (dose.present) {
      map['dose'] = Variable<double>(dose.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointsCompanion(')
          ..write('id: $id, ')
          ..write('measurementId: $measurementId, ')
          ..write('time: $time, ')
          ..write('dose: $dose')
          ..write(')'))
        .toString();
  }
}

class $PointsTable extends Points with TableInfo<$PointsTable, Point> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PointsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _measurementIdMeta =
      const VerificationMeta('measurementId');
  late final GeneratedColumn<int?> measurementId = GeneratedColumn<int?>(
      'measurement_id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES measurements(id)');
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<int?> time = GeneratedColumn<int?>(
      'time', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _doseMeta = const VerificationMeta('dose');
  late final GeneratedColumn<double?> dose = GeneratedColumn<double?>(
      'dose', aliasedName, false,
      typeName: 'REAL', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, measurementId, time, dose];
  @override
  String get aliasedName => _alias ?? 'points';
  @override
  String get actualTableName => 'points';
  @override
  VerificationContext validateIntegrity(Insertable<Point> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('measurement_id')) {
      context.handle(
          _measurementIdMeta,
          measurementId.isAcceptableOrUnknown(
              data['measurement_id']!, _measurementIdMeta));
    } else if (isInserting) {
      context.missing(_measurementIdMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
          _doseMeta, dose.isAcceptableOrUnknown(data['dose']!, _doseMeta));
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Point map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Point.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PointsTable createAlias(String alias) {
    return $PointsTable(_db, alias);
  }
}

abstract class _$DoseDatabase extends GeneratedDatabase {
  _$DoseDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UsersTable users = $UsersTable(this);
  late final $DosimetersTable dosimeters = $DosimetersTable(this);
  late final $MeasurementsTable measurements = $MeasurementsTable(this);
  late final $PointsTable points = $PointsTable(this);
  late final UsersDao usersDao = UsersDao(this as DoseDatabase);
  late final DosimetersDao dosimetersDao = DosimetersDao(this as DoseDatabase);
  late final MeasurementsDao measurementsDao =
      MeasurementsDao(this as DoseDatabase);
  late final PointsDao pointsDao = PointsDao(this as DoseDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, dosimeters, measurements, points];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$UsersDaoMixin on DatabaseAccessor<DoseDatabase> {
  $UsersTable get users => attachedDatabase.users;
}
mixin _$DosimetersDaoMixin on DatabaseAccessor<DoseDatabase> {
  $DosimetersTable get dosimeters => attachedDatabase.dosimeters;
}
mixin _$MeasurementsDaoMixin on DatabaseAccessor<DoseDatabase> {
  $MeasurementsTable get measurements => attachedDatabase.measurements;
  $UsersTable get users => attachedDatabase.users;
  $DosimetersTable get dosimeters => attachedDatabase.dosimeters;
}
mixin _$PointsDaoMixin on DatabaseAccessor<DoseDatabase> {
  $PointsTable get points => attachedDatabase.points;
  $MeasurementsTable get measurements => attachedDatabase.measurements;
  $UsersTable get users => attachedDatabase.users;
}
