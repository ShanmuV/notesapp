import 'package:flutter/material.dart';
import 'package:notesapp/PlaceHolderData/notes_details.dart';
import 'package:notesapp/PlaceHolderData/file_data.dart';
import 'package:notesapp/pages/notes_details_page.dart';
import 'package:notesapp/pages/upload_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> fileData;
  late List<String> subjects;

  @override
  void initState() {
    super.initState();
    fileData = fetchNotes();
  }

  Future<Map<String, dynamic>> fetchNotes() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/notes'));

    if (response.statusCode == 200) {
      print("Response: ${response.body}"); // 🔍 Debugging line

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      subjects = jsonResponse.keys.toList();

      return jsonResponse.map((subject, filedata) {
        if (filedata == null) {
          print("Warning: filedata is null for subject: $subject");
          return MapEntry(subject, []); // Return empty list instead of null
        }

        List<FileData> data =
            (filedata as List).map((data) => FileData.fromJSON(data)).toList();
        return MapEntry(subject, data);
      });
    } else {
      throw Exception("Cant recieve File data");
    }
  }

  // Map<String, List<Map<String, dynamic>>>
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "NotesApp",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(125, 91, 237, 1),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: Colors.white),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UploadPage()));
          },
          child: Icon(Icons.add)),
      body: RefreshIndicator(
        onRefresh: fetchNotes,
        child: Center(
          child: Column(
            children: [
              Flexible(
                  child: FutureBuilder(
                      future: fileData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                "An Error Occured, Try again later \n${snapshot.error.toString()}",
                                style: Theme.of(context).textTheme.bodyLarge),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text("No Files Found",
                              style: Theme.of(context).textTheme.bodyLarge);
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final subject = subjects[index];
                              return NotesCategory(
                                  categoryName: subject,
                                  data: snapshot.data![subject]);
                            },
                          );
                        }
                      }))
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_outlined), label: "Subscriptions"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "You"),
        ],
        currentIndex: 1,
      ),
    );
  }
}

class NotesCategory extends StatelessWidget {
  final String categoryName;
  final List<FileData> data;
  const NotesCategory(
      {super.key, required this.categoryName, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(categoryName, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return NotesItem(data: data[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}

class NotesItem extends StatelessWidget {
  final FileData data;
  const NotesItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: data.id,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                reverseTransitionDuration: Duration(milliseconds: 300),
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    NotesDetailsPage(note: data)));
          },
          child: Stack(
            children: [
              FadeInImage.assetNetwork(
                  placeholder: 'assets/img/loading_gif.gif',
                  image: "https://placehold.co/400x600.jpg",
                  width: 125,
                  fit: BoxFit.cover),
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  children: [
                    Text(data.name,
                        style: Theme.of(context).textTheme.bodyLarge),
                    Text(data.author,
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Old body Code
// Flexible(
//               child: ListView.builder(
//                 itemCount: data.length,
//                 itemBuilder: (context, index) {
//                   final dataItem = data[index];
//                   return NotesCategory(
//                       categoryName: dataItem['Category'] as String,
//                       data: dataItem['Items'] as List<NotesItemData>);
//                 },
//               ),
//             )
