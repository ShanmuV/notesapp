class FileData {
  int id;
  String name;
  String author;
  String subject;
  String desc;
  String? thumbnailURL;

  FileData(
      {required this.id,
      required this.name,
      required this.subject,
      required this.author,
      required this.desc,
      this.thumbnailURL});

  factory FileData.fromJSON(Map<String, dynamic> data) {
    return FileData(
        id: data['id'],
        author: data['author'],
        name: data['name'],
        subject: data['subject'],
        desc: data['desc']);
  }
}
