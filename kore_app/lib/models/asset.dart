import 'package:kore_app/models/user.dart';

class Asset {
  String id;
  String taskId;
  String accountId;
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
        accountId: json['accountId'] as String,
        taskId: json ['taskId'] as String,
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
        'accountId': this.accountId.toString(),
        'taskId': this.taskId.toString(),
        'title': this.title,
        'mimeType': this.mimeType,
        'size': this.size,
        'fileName': this.fileName,
        'location': this.location,
        'fileKey': '',
        'url': this.url,
        'status': this.status,
        'dateCreated': DateTime.now().toString(),
        'dateModified': DateTime.now().toString(),
        'createdBy': user.name,
        'createdById': user.id
    };
}
