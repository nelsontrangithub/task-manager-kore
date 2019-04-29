class Account {
  int id;
  String accountName;
  String dateCreated;
  String dateModified;
  int status;
  String description;
  int createdBy;
  int modifiedBy;
  double percentage;

  Account({
    this.id,
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
        id: json['id'] as int,
        accountName: json['accountName'] as String,
        dateCreated: json['dateCreated'] as String,
        dateModified: json['dateModified'] as String,
        status: json['status'] as int,
        description: json['description'] as String,
        createdBy: json['createdBy'] as int,
        modifiedBy: json['modifiedBy'] as int,
        percentage: 100.0
    );
  }
}