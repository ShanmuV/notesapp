const data = [
  {
    "Category": "Maths",
    "Items": [
      NotesItemData("Notes 1", "Author 1",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '1'),
      NotesItemData("Notes 2", "Author 2",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '2'),
      NotesItemData("Note 3", "Author 3",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '3')
    ]
  },
  {
    "Category": "Science",
    "Items": [
      NotesItemData("Notes 1", "Author 1",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '4'),
      NotesItemData("Notes 2", "Author 2",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '5'),
    ]
  },
  {
    "Category": "Computer Science",
    "Items": [
      NotesItemData("Notes 1", "Author 1",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '6'),
      NotesItemData("Notes 2", "Author 2",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '7'),
      NotesItemData("Notes 3", "Author 3",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '8'),
      NotesItemData("Notes 4", "Author 4",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '9'),
      NotesItemData("Notes 5", "Author 5",
          thumbnailURL: "https://placehold.co/400x600.jpg", tag: '0'),
    ]
  }
];

class NotesItemData {
  final String name;
  final String author;
  final String? pdfURL;
  final String? thumbnailURL;
  final String tag;
  const NotesItemData(this.name, this.author,
      {this.pdfURL, this.thumbnailURL, required this.tag});
}
