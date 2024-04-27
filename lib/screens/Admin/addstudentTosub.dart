// ignore_for_file: unused_local_variable
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ghyabko/screens/auth/Login_Screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
// import 'package:flutter/services.dart' show rootBundle;

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

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      final CollectionReference contacts = FirebaseFirestore.instance.collection('subject');

      final myData = await file.readAsString();
      List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
      List<List<dynamic>> data = csvTable;

      for (var i=0; i<data.length; i++){
      var record = {
        "name": data[i][0],
        "email": data[i][1]
      };
      contacts.add(record);
     }
      // var bytes = await file.readAsBytes();
      // var excel = Excel.decodeBytes(bytes);
      // var table = excel.tables[excel.tables.keys.first];
      // setState(() {
      //   _xlsxData = table!.rows;
      // });
       // Store Excel data in Firestore
      // await storeDataInFirestore();
    }
  }

  // void storeDataInFirestore() async {
  //    final CollectionReference contacts = FirebaseFirestore.instance.collection('contacts');
    //  final myData = await rootBundle.loadString("file");
    //  List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    //  List<List<dynamic>> data = [];
     
    //  data = csvTable;
    //  for (var i=0; i<data.length; i++){
    //   var record = {
    //     "name": data[i][1],
    //     "email": data[i][2]
    //   };
    //   contacts.add(record);
    //  }
    // for (var row in data) {
    //   if (row.length >= 3) { // Check if the row has at least 3 elements
    //     String name = row[0].toString();
    //     String email = row[1].toString();
    //     String password = row[2].toString();

    //     await collection.add({
    //       'name': name,
    //       'email': email,
    //       'password': password,
    //     });
    //   } else {
    //     print('Invalid row: $row'); // Handle or log invalid rows
    //   }
    // }
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
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
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Material(
                  color: constColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () => {_openFileExplorer()},
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
                      SizedBox(height: 10),
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
