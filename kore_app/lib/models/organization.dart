
class Organization {
  int id;
  String name;
  DateTime dateCreated;
  DateTime dateModified;
  int status;
  int createdBy;
  int modifiedBy;

  Organization({
    this.id,
    this.name,
    this.dateCreated,
    this.dateModified,
    this.status,
    this.createdBy,
    this.modifiedBy
  });

  factory Organization.fromJson(Map<String, dynamic> json ) {
    return new Organization(
        id: json['id'] as int,
        name: json['name'] as String,
        dateCreated: json['dateCreated'] as DateTime,
        dateModified: json['dateModified'] as DateTime,
        status: json['status'] as int,
        createdBy: json['createdBy'] as int,
        modifiedBy: json['modifiedBy'] as int,
    );
  }
}