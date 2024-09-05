// import 'package:flutter/material.dart';
// import 'package:avms/services/api_service/dio_helper.dart';
// import '../../data/models/area_unit.dart';
//
// class AreaListScreenWithOwners extends StatefulWidget {
//
//   const AreaListScreenWithOwners({Key? key}) : super(key: key);
//
//   @override
//   AreaListScreenWithOwnersState createState() => AreaListScreenWithOwnersState();
// }
//
// class AreaListScreenWithOwnersState extends State<AreaListScreenWithOwners> {
//   late Future<List<Area>> futureAreas;
//   static int? selectedAreaId; // Initialize selectedAreaId as nullable int
//
//   @override
//   void initState() {
//     super.initState();
//     futureAreas = DioHelper.fetchAreasWithOwners();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Area>>(
//       future: futureAreas,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.hasData) {
//           List<Area> areas = snapshot.data!;
//           return DropdownButton<int>(
//             hint: Text('Select an Area'),
//             value: selectedAreaId,
//             onChanged: (int? newValue) {
//               setState(() {
//                 selectedAreaId = newValue;
//               });
//             },
//             items: areas.map<DropdownMenuItem<int>>((Area area) {
//               return DropdownMenuItem<int>(
//                 value: area.id,
//                 child: Text(area.name),
//               );
//             }).toList(),
//           );
//         } else {
//           return Text('No data');
//         }
//       },
//     );
//   }
// }
