class Asset {
  int id;
  String title;
  String fileName;
  String mimeType;
  int size;
  String location;
  String url;
  int status;

  Asset({ 
    this.id,
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
        id: json['id'] as int,
        title: json['title'] as String,
        fileName: json['fileName'] as String,
        mimeType: json['mimeType'] as String,
        size: json['size'] as int,
        location: json['location'] as String,
        url: json['url'] as String,
        status: json['status'] as int
    );
  }
}
