// import 'package:flutter/material.dart';
// import 'package:flutter_app/classes/FaqDetails.dart';

// class FaqDetailScreen extends StatelessWidget {
//   static const String routeName = "/faq_details_screen";

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     final FaqDetails faq = ModalRoute.of(context).settings.arguments;

// // Use the Todo to create the UI.
//     return Scaffold(
//         body: Stack(children: <Widget>[
//       Column(children: <Widget>[
//         SizedBox(
//           height: screenSize.height / 7,
//         ),
//         Container(
//           height: screenSize.height * 0.77,
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(faq.answer),
//           ),
//         ),
//       ])
//     ]));
//   }
// }
