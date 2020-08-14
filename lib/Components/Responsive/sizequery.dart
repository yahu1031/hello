import 'package:flutter/material.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double}) {
  return screenSize(context).height;
}

double screenWidth(BuildContext context, {double}) {
  return screenSize(context).width;
}

final appHeight = 812;
final appWidth = 375;

// //This is to hide the top panel
// SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 190.0,
//               color: Colors.red.shade900,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             logout();
//                           },
//                           icon: Icon(
//                             Icons.arrow_back,
//                             size: 40.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Icon(
//                           Icons.notifications_none,
//                           size: 40.0,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20.0),
//                     child: Text(
//                       "Search Users",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: TextField(
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         color: Colors.blueAccent,
//                       ),
//                       decoration: InputDecoration(
//                         contentPadding:
//                             EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                         prefixIcon: Icon(
//                           Icons.search,
//                         ),
//                         hintText: "Enter Your Name",
//                         hintStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.white,
//                             ),
//                             borderRadius: BorderRadius.circular(25.0)),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.white, width: 32.0),
//                           borderRadius: BorderRadius.circular(25.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//                 // children: profileList,
//                 ),
//           ],
//         ),
//       ),
