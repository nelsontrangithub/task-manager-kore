
class Organization {
  int id;
  String name;
  DateTime dateCreated;
  DateTime dateModified;
  int status;
  int createdBy;
  int modifiedBy;

  Organization(int id, String name) {
    this.id = id;
    this.name = name;
  }
}