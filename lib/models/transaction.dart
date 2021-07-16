import 'contact.dart';

class Transaction {
  final String id;
  double value;
  Contact contact;

  Transaction(this.id, this.value, this.contact);

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        value = json['value'],
        contact = Contact.fromJson(json['contact']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['contact'] = this.contact.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }
}
