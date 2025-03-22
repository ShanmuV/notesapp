import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
//import 'package:http/http.dart' as http;
import 'dart:io';

class PdfContentPage extends StatefulWidget {
  const PdfContentPage({super.key, required this.pdfID});

  final String pdfID;
  @override
  State<PdfContentPage> createState() => _PdfContentPageState();
}

class _PdfContentPageState extends State<PdfContentPage> {
  late String? _localPath;
  String? _errorMessage;
  double downloadProgress = 0.0;
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: (message) => "Retried",
    ));
    _downloadPdf();
  }

  @override
  void dispose() {
    _deletePDF();
    dio.close();
    super.dispose();
  }

  Future<void> _downloadPdf() async {
    setState(() {
      _localPath = null;
      _errorMessage = null;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final String path = '${tempDir.path}/${widget.pdfID}.pdf';

      // final response = await http
      //     .get(Uri.parse('http://10.0.2.2:5000/view-pdf/${widget.pdfID}'));

      // if (response.statusCode == 200) {
      //   final file = File(path);
      //   await file.writeAsBytes(response.bodyBytes);
      //   print("Writed!");
      // } else {
      //   throw "Response Code: ${response.statusCode}";
      // }

      await dio.download('http://10.0.2.2:8000/view-pdf/${widget.pdfID}', path,
          onReceiveProgress: (received, total) {
        setState(() {
          if (total != -1) {
            downloadProgress = (received / total) * 100;
          }
        });
      });

      // URL for JumpShare: https://pouch.jumpshare.com/download/pFg9C5S4VY0PQ3v3eMAgnCRn6aDetccEosrOy2fctD5ZbeKKokJQRyV8hHpTrjg1Vdawyn2TjSMUFz5yeugwmw

      // final file = File("${tempDir.path}/hello.txt");
      // if (await file.exists()) {
      //   print("FILE EXISTS");
      // }
      // print("Opened the file");
      // await file.writeAsString("Hello from Computer!");
      // print("Written to the file");

      // await Future.delayed(Duration(seconds: 1));

      // File file2 = File("${tempDir.path}/hello.txt");

      // print(await file2.readAsString());

      // print("Downloaded! Local Path = $_localPath\n Path: $path");

      setState(() {
        _localPath = path;
      });
    } catch (e) {
      _errorMessage = "$e";
    }
  }

  Future<void> _deletePDF() async {
    if (_localPath != null) {
      final file = File(_localPath!);
      if (await file.exists()) {
        await file.delete();
        print("PDF deleted successfully.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _errorMessage != null
            ? Text(
                _errorMessage!,
                style: Theme.of(context).textTheme.headlineMedium,
              )
            : _localPath != null
                ? Stack(children: [
                    PDFView(filePath: _localPath),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(231, 180, 247, 1)),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Text("Here goes the Ad")))
                  ])
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text("Progress: ${downloadProgress.toStringAsFixed(2)}")
                    ],
                  ),
      ),
    );
  }
}
