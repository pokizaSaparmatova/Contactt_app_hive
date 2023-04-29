import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'ContactModel.dart';

class HiveHelper {
  late final Box _box;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init("${dir.path}ari");
    _box = await Hive.openBox("ariii");
  }

  Future<void> saveContact(ContactModel contact) async {
    await _box.add(jsonEncode(contact.toJson()));
  }

  Future<void> deleteContact(int index) async {
    await _box.deleteAt(index);
  }

  Future<void> updateContact(int index, ContactModel contact) async {
    await _box.putAt(index, jsonEncode(contact.toJson()));
  }

  List<ContactModel> getContacts() {
    final list = <ContactModel>[];
    for (int i = 0; i < _box.length; i++) {
      list.add(ContactModel.fromJson(jsonDecode(_box.getAt(i))));
      print("hive item: ${list[i].name}");
    }
    return list;
  }

}
