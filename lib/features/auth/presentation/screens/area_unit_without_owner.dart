import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/area_unit.dart';
import 'package:avms/services/api_service/dio_helper.dart';

class AreaListScreenWithoutOwner extends StatefulWidget {
  @override
  AreaListScreenWithoutOwnerState createState() =>
      AreaListScreenWithoutOwnerState();
}

class AreaListScreenWithoutOwnerState extends State<AreaListScreenWithoutOwner> {
  late Future<List<Area>> futureAreas;
  Area? selectedArea; // Initialize selectedArea as nullable Area
  static int? selectedAreaId; // Initialize selectedAreaId as nullable int
  late SharedPreferences prefs; // Declare SharedPreferences variable

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences(); // Call method to initialize shared preferences
    futureAreas = DioHelper.fetchAreasWithoutOwners();
  }

  // Method to initialize shared preferences
  void initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // Retrieve the selected area ID and area from shared preferences
    selectedAreaId = prefs.getInt('selectedAreaIdWithoutOwner');
    if (selectedAreaId != null) {
      setState(() {
        selectedArea = findAreaById(selectedAreaId!);
      });
    }
  }

  // Method to find area by its ID from the list of areas
  Area? findAreaById(int id) {
    // Replace this with your logic to find area by ID from the fetched areas
    // For demonstration, assuming areas is a list of Area objects fetched from API
    List<Area> areas = [];
    for (Area area in areas) {
      if (area.id == id) {
        return area;
      }
    }
    return null;
  }

  // Method to handle saving selected area and its ID to shared preferences
  void saveSelectedArea(Area area) {
    setState(() {
      selectedArea = area;
      selectedAreaId = area.id;
      // Save selected area ID to shared preferences
      prefs.setInt('selectedAreaIdWithoutOwner', selectedAreaId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Area>>(
      future: futureAreas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Area> areas = snapshot.data!;
          return DropdownButton<int>(
            hint: Text('Select an Area'),
            value: selectedAreaId,
            onChanged: (int? newValue) {
              setState(() {
                selectedAreaId = newValue;
              });
            },
            items: areas.map<DropdownMenuItem<int>>((Area area) {
              return DropdownMenuItem<int>(
                value: area.id,
                child: Text(area.name),
              );
            }).toList(),
          );
        } else {
          return Text('No data');
        }
      },
    );
  }
}
