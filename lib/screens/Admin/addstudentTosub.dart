// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:async';
import 'package:excel/excel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ghyabko/screens/auth/Login_Screen.dart';


class AddstudentTOsubject extends StatefulWidget {
  final String subjectID;
  const AddstudentTOsubject({
    Key? key,
    required this.subjectID,
  }) : super(key: key);

  @override
  State<AddstudentTOsubject> createState() => _AddStudentState();
}



// class CustomPdfDocument {
//   static Future<CustomPdfDocument> openData(Uint8List data) async {
//     // Simulating opening PDF data
//     print('Opening PDF data...');
//     await Future.delayed(Duration(seconds: 1)); // Simulating async operation
//     print('PDF data opened successfully.');
//     return CustomPdfDocument();
//   }
// }



class _AddStudentState extends State<AddstudentTOsubject> {
// String jsonString = '';
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // List<Map<String,dynamic>> pdfData = [];

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

//   Future<void> _uploadAndConvertPdf() async {
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
//   final pdfDocument = PdfDocument.openData(Uint8List.fromList(pdfOutput));
//   final StringBuffer buffer = StringBuffer();
//   for (int i = 0; i < pdfDocument.pagesCount; i++) {
//     final page = pdfDocument.getPage(i + 1);
//     final pageContent = await page.text;
//     buffer.write(pageContent);
//   }
//   return buffer.toString();
// }




// Future<void> _handlePdfData() async {
//   try{
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//       if (result != null) {
//         String? filePath = result.files.single.path;
//         if (filePath != null) {
//           // Convert PDF file to JSON
//           String jsonText = await _convertPdfToJson(filePath);
//           setState(() {
//             jsonString = jsonText;
//           });
//         }
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<String> _convertPdfToJson(String filePath) async {
//     // Simulating converting PDF to JSON
//     print('Converting PDF to JSON...');
//     await Future.delayed(Duration(seconds: 1)); // Simulating async operation

//     // Example JSON data
//     List<Map<String, dynamic>> jsonList = [
//       // {'name': 'John Doe', 'age': 30},
//       // {'name': 'Jane Smith', 'age': 25},
//     ];

//     String jsonText = jsonEncode(jsonList);
//     print('PDF converted to JSON successfully.');
//     return jsonText;
//   }

//   Future<String> uploadPdfToStorage(File pdfFile) async {
//   try {
//     FirebaseStorage storage = FirebaseStorage.instance;
//     Reference ref = storage.ref().child('pdfs').child('sample.pdf'); // Name of the file in Firebase Storage
//     UploadTask uploadTask = ref.putFile(pdfFile);
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//     String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//     return downloadUrl;
//   } catch (e) {
//     print('Error uploading PDF to Firebase Storage: $e');
//     return '';
//   }
// }

//   Future<void> savePdfDownloadUrlToDatabase(String downloadUrl) async {
//   try {
//     DatabaseReference databaseRef =
//         FirebaseDatabase.instance.reference().child('pdf_info');
//     await databaseRef.set({'downloadUrl': downloadUrl});
//     print('PDF download URL saved to Firebase Database.');
//   } catch (e) {
//     print('Error saving PDF download URL to Firebase Database: $e');
//   }
// }


  List<List<dynamic>> _xlsxData = [];

  Future<void> _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);
      var table = excel.tables[excel.tables.keys.first];
      setState(() {
        _xlsxData = table!.rows;
      });

      // Store Excel data in Firestore
      await storeDataInFirestore(_xlsxData);
    }
  }

   Future<void> storeDataInFirestore(List<List<dynamic>> data) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('excel_data');
    for (var row in data) {
      if (row.length >= 3) { // Check if the row has at least 3 elements
        String name = row[0].toString();
        String email = row[1].toString();
        String password = row[2].toString();

        await collection.add({
          'name': name,
          'email': email,
          'password': password,
        });
      } else {
        print('Invalid row: $row'); // Handle or log invalid rows
      }
    }
  }

  void processExcelData(List<List<dynamic>> data) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('excel_data');
    for (var row in data) {
      if (row.length >= 3) {
        String name = row[0].toString();
        String email = row[1].toString();
        String password = row[2].toString();

        await collection.add({
          'name': name,
          'email': email,
          'password': password,
        });
      } else {
        print('Invalid row: $row');
      }
    }
  }



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
                  child: Column(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () => {
                          _openFileExplorer()
                        },
                        minWidth: 140,
                        height: 60,
                        child: const Text(
                          'Upload XLSX',
                          style: TextStyle(
                            fontSize: 22.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _xlsxData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(_xlsxData[index].join(', ')),
                            );
                          },
                        ),
                      ),
                    ],
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
