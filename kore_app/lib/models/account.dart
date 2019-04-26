
class Account {
  String orgName;
  int id;
  int orgId;
  String accountName;
  DateTime dateCreated;
  DateTime dateModified;
  int status;
  String description;
  int createdBy;
  int modifiedBy;
  double percentage;

  Account({
    this.orgName,
    this.id,
    this.orgId,
    this.accountName, 
    this.dateCreated,
    this.dateModified,
    this.status,
    this.description,
    this.createdBy,
    this.modifiedBy,
    this.percentage
  });

  factory Account.fromJson(Map<String, dynamic> json ) {
    return new Account(
        orgName: json['orgName'] as String,
        id: json['id'] as int,
        orgId: json['orgId'] as int,
        accountName: json['accountName'] as String,
        dateCreated: json['dateCreated'] as DateTime,
        dateModified: json['dateModified'] as DateTime,
        status: json['status'] as int,
        description: json['description'] as String,
        createdBy: json['createdBy'] as int,
        modifiedBy: json['modifiedBy'] as int,
    );
  }
}