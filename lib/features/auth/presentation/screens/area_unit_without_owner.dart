// import 'package:avms/services/api_service/end_point.dart';
// import 'package:dio/dio.dart';
// import '../../data/models/area_unit.dart';
//
//
// class AreaService {
//   // Static Dio instance
//   static final Dio dio = Dio(BaseOptions(
//     baseUrl: '$BASE_URL$SaveApiUrl',
//     headers: {'accept': '*/*'},
//
//     validateStatus: (int? status) {
//       return status != null;
//       // return status != null && status >= 200 && status < 300;
//     },
//     receiveDataWhenStatusError: true,
//   ));
//
//   // Static method to fetch areas
//   static Future<List<Area>> fetchAreasWithHaveOwners() async {
//     try {
//       final response = await dio.get('$GetAll');
//       if (response.statusCode == 200) {
//         final data = response.data['data'] as List;
//         // Parse the data into Area objects
//         final areas = data.map((json) => Area.fromJson(json)).toList();
//         // Filter the areas to include only those with owners
//         final areasWithOwners = areas.where((area) => area.owners.isNotEmpty).toList();
//         return areasWithOwners;
//       } else {
//         throw Exception('Failed to load areas');
//       }
//     } catch (e) {
//       print('Error fetching areas: $e');
//       throw Exception('Failed to load areas');
//     }
//   }
//   static Future<List<Area>> fetchAreasWithoutOwners() async {
//     try {
//       final response = await dio.get('$GetAll');
//       if (response.statusCode == 200) {
//         final data = response.data['data'] as List;
//         // Parse the data into Area objects
//         final areas = data.map((json) => Area.fromJson(json)).toList();
//         // Filter the areas to include only those without owners
//         final areasWithoutOwners = areas.where((area) => area.owners.isEmpty).toList();
//         return areasWithoutOwners;
//       } else {
//         throw Exception('Failed to load areas');
//       }
//     } catch (e) {
//       print('Error fetching areas: $e');
//       throw Exception('Failed to load areas');
//     }
//   }
// }