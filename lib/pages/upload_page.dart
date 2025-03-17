import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Uint8List? fileBytes;
  String? filename;
  final _subjectController = TextEditingController();
  final _nameController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> uploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(withData: true);
      if (result != null) {
        String filename = result.files.single.name;
        Uint8List? fileBytes = result.files.single.bytes;
        debugPrint("Filename: $filename");

        if (fileBytes == null) {
          debugPrint("File bytes are null!");
          return;
        }

        var uri = Uri.parse("http://10.0.2.2:8000/upload");
        var request = http.MultipartRequest("POST", uri)
          ..files.add(http.MultipartFile.fromBytes('file', fileBytes,
              filename: filename))
          ..fields['subject'] = _subjectController.text
          ..fields['name'] = _nameController.text
          ..fields['author'] = _authorNameController.text
          ..fields['desc'] = _descriptionController.text;

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          debugPrint("Upload Successful");
        } else {
          debugPrint("Upload Failed: ${response.statusCode} ${response.body}");
        }
      } else {
        debugPrint("No file selected.");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Share your Notes",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _authorNameController,
                decoration: InputDecoration(labelText: "Author"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText: "Description", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: DropdownMenu<String>(
                controller: _subjectController,
                requestFocusOnTap: true,
                initialSelection: "Math",
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: "Maths", label: "Maths"),
                  DropdownMenuEntry(value: "Science", label: "Science"),
                  DropdownMenuEntry(
                      value: "Computer Science", label: "Computer Science"),
                ],
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 2,
                  color: const Color.fromARGB(255, 85, 8, 99),
                ),
              ),
              child: InkWell(
                onTap: uploadFile,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                      ),
                      Text(
                        "Upload Notes",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
