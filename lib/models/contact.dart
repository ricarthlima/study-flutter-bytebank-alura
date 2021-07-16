class Contact {
  int id;
  String name;
  int accountNumber;

  Contact(this.id, this.name, this.accountNumber);

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, accountNumber: $accountNumber}';
  }

  Contact.fromJson(Map<String, dynamic> json)
      : this.id = ((json['id'] != null) ? json["id"] : 0),
        this.name = json['name'],
        this.accountNumber = json['accountNumber'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['accountNumber'] = this.accountNumber;
    return data;
  }
}
