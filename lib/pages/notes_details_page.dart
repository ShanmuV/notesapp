import 'package:flutter/material.dart';
import 'package:notesapp/PlaceHolderData/file_data.dart';
import 'package:notesapp/pages/pdf_content_page.dart';

class NotesDetailsPage extends StatelessWidget {
  final FileData note;
  const NotesDetailsPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                    child: Hero(
                      tag: note.id,
                      child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FadeInImage.assetNetwork(
                            placeholder: 'assets/img/loading_gif.gif',
                            image: "https://placehold.co/400x600.jpg",
                            width: 125,
                            height: 200,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    note.name,
                    style: TextStyle(
                        fontFamily: "Satoshi",
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    note.author,
                    style: TextStyle(fontFamily: "Satoshi", fontSize: 18),
                  ),
                  const SizedBox(height: 40),
                  Text(note.desc,
                      style: Theme.of(context).textTheme.headlineSmall)
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.deepPurple[100],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PdfContentPage(pdfID: note.id.toString())));
                },
                child: Text("Read",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            )
          ],
        ),
      ),
    );
  }
}
