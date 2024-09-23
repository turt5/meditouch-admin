import 'package:hive/hive.dart';
import 'person.dart';

class DBHelper {
  static Box<Person>? _userBox;

  Future<void> initDb() async {
    Hive.registerAdapter(PersonAdapter()); // Register the adapter
    _userBox = await Hive.openBox<Person>('user');
  }

  Future<void> insertUser(Person person) async {
    await _userBox!.put('currentUser', person); // Use a constant key
  }

  Person? getUser() {
    return _userBox!.get('currentUser'); // Fetch the user with the constant key
  }

  Future<void> deleteUser() async {
    await _userBox!.delete('currentUser'); // Delete the user with the constant key
  }
}
