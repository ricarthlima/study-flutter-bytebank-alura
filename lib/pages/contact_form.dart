import 'package:flutter/material.dart';
import 'package:flutter_persistence_alura/database/dao/contact_dao.dart';
import 'package:flutter_persistence_alura/models/contact.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Full name"),
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(labelText: "Account number"),
                style: TextStyle(fontSize: 24.0),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  final String name = _nameController.text;
                  final int? accountNumber =
                      int.tryParse(_accountNumberController.text);
                  final contact = Contact(0, name, accountNumber!);

                  _dao.save(contact).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text("Create"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
