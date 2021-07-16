import 'package:flutter_persistence_alura/models/contact.dart';
import 'package:sqflite/sqflite.dart';

import '../app_database.dart';

class ContactDao {
  static const String tableSql = "CREATE TABLE $_tableName(" +
      "id INTEGER PRIMARY KEY, " +
      "name TEXT, " +
      "account_number INTEGER)";

  static const String _tableName = "contacts";
  static const String _id = "id";
  static const String _name = "name";
  static const String _accountNumber = "account_number";

  Future<int> save(Contact contact) async {
    Database db = await createDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() {
    return createDatabase().then((db) {
      return db.query(_tableName).then((maps) {
        final List<Contact> contacts = [];
        for (Map<String, dynamic> map in maps) {
          final Contact contact =
              Contact(map[_id], map[_name], map[_accountNumber]);
          contacts.add(contact);
        }
        return contacts;
      });
    });
  }
}
