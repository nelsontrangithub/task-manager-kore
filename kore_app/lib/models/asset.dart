import 'package:kore_app/models/user.dart';

class Asset {
  String id;
  int taskId;
  int accountId;
  String title;
  String fileName;
  String mimeType;
  int size;
  String location;
  String url;
  int status;

  Asset({
    this.id,
    this.accountId,
    this.taskId,
    this.title,
    this.fileName,
    this.mimeType,
    this.size,
    this.location,
    this.url,
    this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json ) {
    return new Asset(
        title: json['title'] as String,
        accountId: json['accountId'] as int,
        taskId: json ['taskId'] as int,
        fileName: json['fileName'] as String,
        mimeType: json['mimeType'] as String,
        size: json['size'] as int,
        location: json['location'] as String,
        url: json['url'] as String,
        status: json['status'] as int
    );
  }

  Map<String, dynamic> toJson(User user) => {
        'fileId': this.id,
        'title': this.title,
        'accountId': this.accountId.toString(),
        'taskId': this.taskId.toString(),
        'fileName': this.fileName,
        'mimeType': this.mimeType,
        'size': this.size,
        'location': this.location,
        'url': this.url,
        'status': this.status,
        'createdBy': user.name,
        'createdById': user.id, 
        'fileKey': '',
        'dateCreated': DateTime.now(),
        'dateModified': DateTime.now()
    };
}
