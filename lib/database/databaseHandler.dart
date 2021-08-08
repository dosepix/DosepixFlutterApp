import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'dart:io';
part 'databaseHandler.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().withLength(min: 6).customConstraint('UNIQUE')();
  TextColumn get fullName => text().withLength(min: 6)();
  TextColumn get email => text().withLength()();
  TextColumn get password => text().withLength(min: 6)();
}

class Dosimeters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 6).customConstraint('UNIQUE')();
  TextColumn get color => text().withLength()();
  RealColumn get totalDose => real()();
}

class Measurements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().customConstraint('REFERENCES users(id)')();
  IntColumn get dosimeterId => integer().customConstraint('REFERENCES dosimeters(id')();
}

class Points extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get measurementId => integer().customConstraint('REFERENCES measurements(id)')();
  IntColumn get time => integer()();
  RealColumn get dose => real()();
}

@UseDao(tables: [Users])
class UsersDao extends DatabaseAccessor<DoseDatabase> with _$UsersDaoMixin {
  UsersDao(DoseDatabase db) : super(db);

  Stream<List<User>> watchUsers() => select(users).watch();
  Future<List<User>> getUsers() => select(users).get();
  Future<void> insertUser(Insertable<User> user) => into(users).insert(user);
  Future<void> updateUser(Insertable<User> user) => update(users).replace(user);
  Future<void> deleteUser(Insertable<User> user) => delete(users).delete(user);
}

@UseDao(tables: [Dosimeters])
class DosimetersDao extends DatabaseAccessor<DoseDatabase> with _$DosimetersDaoMixin {
  DosimetersDao(DoseDatabase db) : super(db);
}

@UseDao(tables: [Measurements, Users, Dosimeters])
class MeasurementsDao extends DatabaseAccessor<DoseDatabase> with _$MeasurementsDaoMixin {
  MeasurementsDao(DoseDatabase db) : super(db);
}

// Specify name and location of database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
   final dbFolder = await getApplicationDocumentsDirectory();
   final file = File(p.join(dbFolder.path, 'db.sqlite'));
   return VmDatabase(file);
  });
}

@UseMoor(tables: [Users, Dosimeters, Measurements, Points],
         daos: [UsersDao, DosimetersDao])
class DoseDatabase extends _$DoseDatabase {
  DoseDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

