import 'package:flutter/material.dart';
import 'package:instiapp/screens/TLForms/secondPage.dart';
import 'package:instiapp/screens/homePage.dart';
import 'package:instiapp/screens/roomBooking/functions.dart';
import 'dart:io';
import 'dart:convert';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/screens/roomBooking/roomservice.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {

  Map machineData = {};
  bool uploading = false;
  int count = 0;

  String type;
  Machine machine;
  Map<String, File> files;

  String purpose = 'Select your purpose';
  List<String> purposes = ['Project Course', 'TC Project', 'Event(Amalthea, etc.)', 'Independant'];

  MachineTime userTime;

  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;

  @override
  void initState() {
    super.initState();
    DateTime _currentTime = DateTime.now();
    startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    endDate = DateTime(_currentTime.add(new Duration(hours: 1)).year, _currentTime.add(new Duration(hours: 1)).month, _currentTime.add(new Duration(hours: 1)).day);
    startTime = TimeOfDay.fromDateTime(_currentTime);
    endTime = TimeOfDay.fromDateTime(_currentTime.add(new Duration(hours: 1)));
  }

  bookMachine(MachineTime time, Machine machine) async{

    var queryParameters = {
      'api_key': 'GULLU',
      'machine_id': machine.machineId,
    };
    var uri1 = Uri.https(
      baseUrlTL,
      '/addBookingFile',
      queryParameters,
    );
    var uri2 = Uri.https(
      baseUrlTL,
      '/addBooking',
      queryParameters,
    );
    List<String> fileNames = [];
    files.forEach((String type, File file) {
      fileNames.add(machine.machineId + '&' + time.start.millisecondsSinceEpoch.toString() + '_' + time.end.millisecondsSinceEpoch.toString() + '.' + type);
    });
    print('Booking ' + machine.model + ': ' + uri1.toString());
    var jsonBody = jsonEncode({
      "booked_by": {
        "user_id": time.userId,
        "full_name": time.name,
        "image_link": time.url,
        "bio": time.bio,
        "contact": time.mobNo,
      },
      "purpose": time.purpose,
      "start": time.start.millisecondsSinceEpoch,
      "end": time.end.millisecondsSinceEpoch,
      "url_of_uploaded_files": fileNames,
    });
    print(jsonBody);
    setState(() {
      uploading = true;
    });
    uploadData(uri2, jsonBody);
    files.forEach((String type, File file) {
      String filename = machine.machineId + '&' + time.start.millisecondsSinceEpoch.toString() + '_' + time.end.millisecondsSinceEpoch.toString() + '.' + type;
      uploadFile(uri1, filename, file);
    });
  }

  uploadData (var uri, var jsonBody) async {
    var response = await http.post(
        uri,
        body: jsonBody,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
    setState(() {
      count++;
      if (count == files.length + 1) {
        uploading = false;
        //print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
        selectedIndex = 4;
        Navigator.pushReplacementNamed(context, '/menuBarBase');
      }
    });
    print(response.statusCode);
  }
  uploadFile (var uri, String filename, File file) async {
    var request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile.fromBytes('file', file.readAsBytesSync(), filename: filename, contentType: MediaType('application', 'x-tar')));
    var response = await request.send();
    setState(() {
      count++;
      if (count == files.length + 1) {
        uploading = false;
        //print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
        selectedIndex = 4;
        Navigator.pushReplacementNamed(context, '/menuBarBase');
      }
    });
    print(response.statusCode);
  }

  Widget homeScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30,),
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  'From',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListTile(
                      title: Center(
                          child: Text(
                            "Date",
                          )
                      ),
                      subtitle: Center(
                          child: Text(
                            "${startDate.day} / ${startDate.month} / ${startDate.year}",
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          )
                      ),
                      trailing: Icon(
                        Icons.calendar_today,
                      ),
                      onTap: _pickStartDate,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListTile(
                      title: Center(
                          child: Text(
                            "Time",
                          )),
                      subtitle: Center(
                        child: Text(
                          "${startTime.hour} : ${startTime.minute}",
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.access_time,
                      ),
                      onTap: _pickStartTime,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30,),
          Divider(indent: 40, endIndent: 40, color: Colors.grey[800],),
          SizedBox(height: 30,),
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  'To',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListTile(
                      title: Center(
                        child: Text(
                          "Date",
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          "${endDate.day} / ${endDate.month} / ${endDate.year}",
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.calendar_today,
                      ),
                      onTap: _pickEndDate,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListTile(
                      title: Center(
                        child: Text(
                          "Time",
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          "${endTime.hour} : ${endTime.minute}",
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.access_time,
                      ),
                      onTap: _pickEndTime,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(indent: 40, endIndent: 40, color: Colors.grey[800],),
          SizedBox(height: 80,),
          ExpansionTile(
            key: GlobalKey(),
            title: Text(purpose),
            children: purposes.map((String text) {
              return ListTile(
                title: Text(text),
                onTap: () {
                  setState(() {
                    this.purpose = text;
                    this.startDate = startDate;
                    this.startTime = startTime;
                    this.endDate = endDate;
                    this.endTime = endTime;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 20.0,),
          Center(
            child: FlatButton(
              color: primaryColor,
              onPressed: () {
                if (purpose == 'Select your purpose') {
                  showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      content: Text('Please select your purpose'),
                    ),
                  );
                } else {
                  DateTime start = DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute);
                  DateTime end = DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute);
                  bookMachine(MachineTime(userId: userID, name: gSignIn.currentUser.displayName, mobNo: userMobileNumber, bio: userBio, start: start, end: end, purpose: purpose, url: gSignIn.currentUser.photoUrl, urlOfUploadedFiles: ['gcodefile', 'stlfile', 'imgfile']), machine);
                }
              },
              child: Text(
                'Book ' + machine.model,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _pickStartDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: startDate,
    );
    if(date != null)
      setState(() {
        startDate = DateTime(date.year, date.month, date.day);
      });
  }

  _pickEndDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: endDate,
    );
    if(date != null)
      setState(() {
        endDate = DateTime(date.year, date.month, date.day);
      });
  }

  _pickStartTime() async {
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: startTime
    );
    if(t != null)
      setState(() {
        startTime = t;
      });
  }

  _pickEndTime() async {
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: endTime
    );
    if(t != null)
      setState(() {
        endTime = t;
      });
  }

  Widget loadScreen () {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Text('Your Files are being uploaded'),
          Text('Please wait a few minutes.....'),
          SizedBox(height: 5,),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    machineData = ModalRoute.of(context).settings.arguments;
    type = machineData['type'];
    machine = machineData['machine'];
    files = machineData['files'];

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              selectedIndex = 4;
              Navigator.pushReplacementNamed(context, '/menuBarBase');
            },
          ),
          title: Text('Step 3',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        body: (uploading == true && count != files.length + 1)
            ? loadScreen()
            : homeScreen()
    );
  }
}
