import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassesDisplayCard extends StatelessWidget {
  final double height;
  final String expertiseLevel;
  final String classDuration;
  final String classTitle;
  final String classType;
  final String instructorName;
  final DateTime scheduledAt;
  final String bgImageLink;
  final Color bgColor = Colors.white;

  ClassesDisplayCard(
      {this.height,
      this.expertiseLevel,
      this.classDuration,
      this.classTitle,
      this.instructorName,
      this.scheduledAt,
      this.bgImageLink,
      this.classType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Stack(children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          width: (height * 2) + 20,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset.fromDirection(1.5708, 4.0),
                  spreadRadius: 0)
            ],
            color: bgColor,
            image: DecorationImage(
              image: AssetImage(bgImageLink),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: (height * 2) + 20,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.5),
                  Colors.transparent
                ],
              )),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("#$expertiseLevel",
                            style: Theme.of(context).textTheme.overline),
                        Text(classDuration,
                            style: Theme.of(context).textTheme.overline),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "$classTitle",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "$instructorName - $classType",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    Text(
                      getFormattedDateTimeForClass(scheduledAt),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  String getFormattedDateTimeForClass(DateTime scheduledAt) {
    if (scheduledAt != null) {
      DateFormat classesDateFormat = new DateFormat(
          "d'${getOrdinalForDay(scheduledAt.day)}' MMM EEE '@' hh:mm aaa");
      return classesDateFormat.format(scheduledAt);
    } else
      return "";
  }

  String getOrdinalForDay(int day) {
    String suffix = "th";
    if (day < 11 || day > 20) {
      int lastDigit = day % 10;
      switch (lastDigit) {
        case 1:
          suffix = "st";
          break;
        case 2:
          suffix = "nd";
          break;
        case 3:
          suffix = "rd";
          break;
      }
    }
    return suffix;
  }
}
