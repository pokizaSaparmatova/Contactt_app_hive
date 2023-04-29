import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ContactModel.dart';
import 'di.dart';
import 'home_page_provider.dart';

class HivePage extends StatefulWidget {
  const HivePage({Key? key}) : super(key: key);

  @override
  State<HivePage> createState() => _HivePageState();
}

class _HivePageState extends State<HivePage> {
  late List<ContactModel> list;
  var nameController = TextEditingController();
  var numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Scaffold");
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts"), centerTitle: true),
      body: Builder(builder: (context) {
        print("Builder");
        list = context.watch<HomePageProvider>().list;
        if (list != null) {
          return Scaffold(
              body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              print("ListView");
              return GestureDetector(
                onTap: () {
                  print("tap");
                  _showDialog(index, list[index], (index, contact) {
                    context.read<HomePageProvider>().updateContact(index, contact);
                  });
                },
                onLongPress: () {
                  print("deleted");
                  context.read<HomePageProvider>().deleteContact(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(list[index].name),
                          const SizedBox(height: 8),
                          Text(list[index].number),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ));
        } else {
          return const Text("No ari yet");
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("floating button tapping");
          _showBottomSheet((contact) {
            context.read<HomePageProvider>().addContact(contact);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showBottomSheet(Function(ContactModel contact) onTap) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) => di.get<HomePageProvider>(),
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Add contact", style: TextStyle(fontSize: 20, color: Colors.green)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: numberController,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: () {
                        // onTap(ContactModel(nameController.text, numberController.text));
                        context.read<HomePageProvider>().addContact(ContactModel(nameController.text, numberController.text));
                        print("bottom sheet");
                        nameController.clear();
                        numberController.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Add"))
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showDialog(int index, ContactModel contact, Function(int index, ContactModel contact) onTap) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          nameController.text = contact.name;
          numberController.text = contact.number;
          return AlertDialog(
            content: SizedBox(
              height: 200,
              child: Column(
                children: [
                  const Text("Update contact", style: TextStyle(fontSize: 20, color: Colors.green)),
                  const SizedBox(height: 20),
                  TextField(controller: nameController),
                  const SizedBox(height: 20),
                  TextField(controller: numberController),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    onTap(index, ContactModel(nameController.text, numberController.text));
                    print("dialog");
                    nameController.clear();
                    numberController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Update")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }
}
