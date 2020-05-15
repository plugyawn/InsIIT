import 'package:flutter/material.dart';
import 'package:instiapp/utilities/constants.dart';

class EventModel {
  DateTime start;
  DateTime end;
  bool isCourse;
  String courseName;
  String courseId;
  String description;
  String summary;
  String eventType;
  String remarks;
  String location;
  String creator;
  List<String> instructors;
  String credits;
  String preRequisite;
  EventModel(
      {this.start,
        this.end,
        this.isCourse,
        this.courseName,
        this.courseId,
        this.description,
        this.summary,
        this.eventType,
        this.remarks,
        this.location,
        this.creator,
        this.instructors,
        this.credits,
        this.preRequisite});

  Widget time (DateTime time) {
    if (time == null) {
      return Flexible(
        child: Text("Whole Day",
            style: TextStyle(
                color: Colors.black.withAlpha(200), fontSize: 17)),
      );
    }
    else {
      return Text("${time.hour}:${time.minute}",
          style: TextStyle(
              color: Colors.black.withAlpha(200), fontSize: 17));
    }
  }

  String stringReturn(String text) {
    if (text == null) {
      return 'None';
    } else if (text.length < 100) {
      return text;
    } else {
      return text.substring(0, 99);
    }
  }

  Widget descriptionWidget () {
    if (this.isCourse) {
      return Container(
        width: ScreenSize.size.width * 0.55,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(this.courseId,
                  style: TextStyle(
                      color: Colors.black.withAlpha(120),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              SizedBox(
                height: 8,
              ),
              Text(this.courseName,
                  style: TextStyle(
                      color: Colors.black.withAlpha(255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Text(this.eventType + ' (${this.remarks})',
                      style: TextStyle(
                          color: Colors.black.withAlpha(200),
                          fontStyle: FontStyle.italic,
                          fontSize: 14)),
                  SizedBox(width: 5,),
                  Flexible(
                    child: Text('Room: ${this.location}',
                        style: TextStyle(
                            color: Colors.black.withAlpha(200),
                            fontStyle: FontStyle.italic,
                            fontSize: 14)),
                  ),
                ],
              ),
            ]),
      );
    } else {
      return Container(
        width: ScreenSize.size.width * 0.55,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(stringReturn(this.description),
                  style: TextStyle(
                      color: Colors.black.withAlpha(120),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              SizedBox(
                height: 8,
              ),
              Text(stringReturn(this.summary),
                  style: TextStyle(
                      color: Colors.black.withAlpha(255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              SizedBox(
                height: 8,
              ),
              Text(stringReturn(this.eventType) + ' (' + stringReturn(this.remarks) + ')',
                  style: TextStyle(
                      color: Colors.black.withAlpha(200),
                      fontStyle: FontStyle.italic,
                      fontSize: 14)),
            ]),
      );
    }
  }

  Widget buildCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/eventdetail', arguments: {
          'eventModel': this,
        });
      },
      child: Card(
        child: Container(
          width: ScreenSize.size.width,
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    time(this.start),
                    SizedBox(
                      height: 8,
                    ),
                    Text("to",
                        style: TextStyle(
                            color: Colors.black.withAlpha(120), fontSize: 14)),
                    SizedBox(
                      height: 8,
                    ),
                    time(this.end),
                  ]),
                  verticalDivider(),
                  descriptionWidget(),
                ],
              )),
        ),
      ),
    );
  }
}

class TodayCourse {
  DateTime start;
  DateTime end;
  String course;

  TodayCourse({this.start, this.end , this.course});
}

class MyCourse {
  String courseCode;
  String courseName;
  String noOfLectures;
  String noOfTutorials;
  String credits;
  List<String> instructors;
  String preRequisite;
  List<String> lectureCourse;
  String lectureLocation;
  List<String> tutorialCourse;
  String tutorialLocation;
  List<String> labCourse;
  String labLocation;
  String remarks;
  String courseBooks;

  MyCourse({
    this.courseCode,
    this.courseName,
    this.noOfLectures,
    this.noOfTutorials,
    this.credits,
    this.instructors,
    this.preRequisite,
    this.lectureCourse,
    this.lectureLocation,
    this.tutorialCourse,
    this.tutorialLocation,
    this.labCourse,
    this.labLocation,
    this.remarks,
    this.courseBooks,
  });
}

verticalDivider() {
  return Row(
    children: <Widget>[
      SizedBox(
        width: 16,
      ),
      Container(
        height: 50,
        width: 1,
        color: Colors.grey,
      ),
      SizedBox(
        width: 16,
      ),
    ],
  );
}
