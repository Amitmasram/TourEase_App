// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../../../data/models/location_dummy.dart';

// class LocationScreen extends StatefulWidget {
//   const LocationScreen({super.key});

//   @override
//   State<LocationScreen> createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Locations'),
//         automaticallyImplyLeading: false,
//       ),
//       body: ListView.builder(
//         itemCount: locations.length,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             color: Colors.black,
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     topLeft: Radius.circular(15),
//                   ),
//                   child: Image.asset(
//                     locations[index].image,
//                     height: 200, // Decreased height
//                     fit: BoxFit.fill,
//                     width: double.infinity,
//                   ),
//                 ),
//                 ListTile(
//                   contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 3), // Adjusted padding
//                   title: Text(
//                     locations[index].name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                   subtitle: Row(
//                     children: [
//                       Text(
//                         locations[index].district,
//                         style: const TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const Text(
//                         ',',
//                         style: TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 3,
//                       ),
//                       Text(
//                         locations[index].state,
//                         style: const TextStyle(
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 1), // Adjusted padding
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // ignore: avoid_unnecessary_containers
//                       Container(
//                         child: const FaIcon(
//                           FontAwesomeIcons.locationArrow,
//                           color: Colors.amber,
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 10, // Decreased width
//                       ),
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           backgroundColor: Colors.white,
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DetailsScreen(
//                                 location: locations[index],
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Row(
//                           children: [
//                             FaIcon(FontAwesomeIcons.arrowUpRightFromSquare),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text(
//                               "Get to Know more",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class DetailsScreen extends StatelessWidget {
//   final Location location;

//   const DetailsScreen({
//     Key? key,
//     required this.location,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Location Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 200,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(location.image),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Locality Name:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     location.locality,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     'Taluka Name:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     location.taluka,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 4),
//                   const Text(
//                     'Location',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Text(
//                         location.district,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         location.state,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     'To Know More about:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     location.description,
//                     style: const TextStyle(fontSize: 16),
//                   ),

//                   // Continue similarly for other details
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(10)),
//                 height: 45,
//                 width: 170,
//                 child: const Row(
//                   children: [
//                     FaIcon(FontAwesomeIcons.locationArrow),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       'Get the Direction',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }



// // ListView.builder(
// //         itemCount: locations.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text(locations[index].name),
// //             subtitle: Text(locations[index].locality),
// //             onTap: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) =>
// //                       DetailsScreen(location: locations[index]),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
