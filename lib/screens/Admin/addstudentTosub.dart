// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ghyabko/screens/auth/Login_Screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class AddstudentTOsubject extends StatefulWidget {
  final String subjectID;
  const AddstudentTOsubject({
    Key? key,
    required this.subjectID,
  }) : super(key: key);

  @override
  State<AddstudentTOsubject> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddstudentTOsubject> {
String jsonString = '';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String,dynamic>> pdfData = [];

  List<QueryDocumentSnapshot> data = [];
  addstudent() async {
    CollectionReference student = FirebaseFirestore.instance
        .collection('subject')
        .doc(widget.subjectID)
        .collection('student');
    DocumentReference response =
        await student.add({'studentemail': studentemail.text});
  }

  TextEditingController studentemail = TextEditingController();

  // Future<void> _uploadAndConvertPdf() async {
  //   try {
  //     // Choose PDF file
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //     );

  //     if (result != null) {
  //       String? filePath = result.files.single.path;
  //       if (filePath != null) {
  //         // Convert PDF file to JSON
  //         String jsonText = await _convertPdfToJson(filePath);
  //         setState(() {
  //           jsonString = jsonText;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  // Future<String> _convertPdfToJson(String filePath) async {
  //   // Load PDF
  //   final pdf = pw.Document();
  //   pdf.addPage(pw.Page(
  //     build: (pw.Context context) {
  //       return pw.Center(
  //         child: pw.Text('Hello World', style: pw.TextStyle(fontSize: 40)),
  //       );
  //     },
  //   ));

  //   // Extract text from PDF
  //   String text = await _getTextFromPdf(pdf);

  //   // Convert text to JSON
  //   List<String> lines = text.split('\n');
  //   List<Map<String, dynamic>> jsonList = [];
  //   for (String line in lines) {
  //     jsonList.add({'text': line});
  //   }
  //   String jsonText = jsonEncode(jsonList);

  //   return jsonText;
  // }

  // Future<String> _getTextFromPdf(pw.Document pdf) async {
  //   final pdfOutput = await pdf.save();
  //   final pdfDocument = PdfDocument.openData(pdfOutput);
  //   final StringBuffer buffer = StringBuffer();
  //   for (int i = 0; i < pdfDocument.length; i++) {
  //     final page = await pdfDocument.getPage(i + 1);
  //     final pageContent = await page.text;
  //     buffer.write(pageContent);
  //   }
  //   return buffer.toString();
  // }


  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text('ADD Student To Subject',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Image(
                  image: AssetImage('assets/student.png'),
                  height: 170,
                  width: 190,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: constColor,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: Colors.white,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: studentemail,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.subject,
                      color: Colors.white,
                    ),
                    hintText: "Enter student email",
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
                    child: Material(
                      color: constColor,
                      borderRadius: BorderRadius.circular(10),
                      child: MaterialButton(
                        onPressed: () => {addstudent()},
                        minWidth: 140,
                        height: 60,
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 22.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 5),
                child: Material(
                  color: constColor,
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    onPressed: () async {
                      // Choose PDF file
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null) {
                        String? pdfPath = result.files.single.path;
                        if (pdfPath != null) {
                          // Convert PDF file to JSON
                          String? jsonText = await PdfToJsonConverter.convertPdfToJson(pdfPath);
                          if (jsonText != null) {
                            // Handle the JSON data
                            print(jsonText);
                          } else {
                            print('Failed to convert PDF to JSON.');
                          }
                        }
                      }
                      // _uploadAndConvertPdf()
                    },
                    minWidth: 140,
                    height: 60,
                    child: const Text(
                      'Upload PDF',
                      style: TextStyle(
                        fontSize: 22.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
