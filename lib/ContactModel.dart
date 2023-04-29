class ContactModel {
  String name;
  String number;

  ContactModel(this.name, this.number);

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(json["name"] ?? "", json["number"] ?? "");

  Map<String, dynamic> toJson() => {"name": name, "number": number};

}
