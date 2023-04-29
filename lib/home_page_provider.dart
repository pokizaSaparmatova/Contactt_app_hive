import 'package:flutter/cupertino.dart';
import 'ContactModel.dart';
import 'hive.dart';
import 'di.dart';

class HomePageProvider extends ChangeNotifier {
  final hive = di.get<HiveHelper>();
  late List<ContactModel> list = hive.getContacts();

  void deleteContact(int index) {
    hive.deleteContact(index);
    getContactList();
    notifyListeners();
  }

  void updateContact(int index, ContactModel contact) {
    hive.updateContact(index, contact);
    getContactList();
    notifyListeners();
  }

  void addContact(ContactModel contact) {
    hive.saveContact(contact);
    list = hive.getContacts();
    notifyListeners();
  }

  void getContactList() {
    list = hive.getContacts();
    notifyListeners();
  }
}
