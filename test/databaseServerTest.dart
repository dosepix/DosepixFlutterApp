import 'dart:io';

import 'package:test/test.dart';
import 'package:dosepix/databaseServer/databaseHandler.dart';

void main() {
  DoseDatabase doseDatabase = DoseDatabase();

  group('User', ()
  {
    test('Get all users from database', () {
      return doseDatabase.usersDao.getUsers().then((value) {
        print(value);
      });
    });

    test('Stream users from database', () {
      return doseDatabase.usersDao.watchUsers().listen(expectAsync1((value) => print(value), count: 1));
    });

    test('Get user from id', () {
      return doseDatabase.usersDao.getUserById(40).then((value) {
        print(value);
      });
    });

    test('Create new user', ()
    {
      final UsersCompanion user = UsersCompanion.insert(
          userName: "FlutterTest",
          fullName: "FlutterTestFull",
          email: "test@flutter.com",
          password: "madewithflutter");
      return doseDatabase.usersDao.insertUser(user).then((value) {});
    });
  });

  group('Dosimeter', () {
    test('Create new dosimeter', () {
      return doseDatabase.dosimetersDao.insertDosimeter(
        DosimetersCompanion.insert(
            name: "TestDosimeter",
            color: "testColor",
            totalDose: 9999.0,
        )
      );
    });
  });

  group('Point', () {
    test('Create points', () {
      return doseDatabase.pointsDao.insertPoint(
        PointsCompanion.insert(measurementId: 1, time: 10, dose: 3.0)
      );
    });

    test('Load points of measurement of id', () {
      return doseDatabase.pointsDao.loadDataPointsOfMeasurementId(1).listen(
        expectAsync1((value) => print(value), count: 1)
      );
    });

    test('Load measurements with important points', () {
      return doseDatabase.pointsDao.measurementsWithImportantPoints(fromUser: 1).listen(
        expectAsync1((value) => print(value), count: 1)
      );
    });
  });
}
