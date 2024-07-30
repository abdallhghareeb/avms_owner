import 'package:avms/services/api_service/dio_helper.dart';
import 'package:flutter/material.dart';
import '../../data/models/area_unit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Area List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AreaListScreen(),
    );
  }
}

class AreaListScreen extends StatefulWidget {
  @override
  _AreaListScreenState createState() => _AreaListScreenState();
}

class _AreaListScreenState extends State<AreaListScreen> {
  late Future<List<Area>> futureAreas;

  @override
  void initState() {
    super.initState();
    futureAreas = DioHelper.fetchAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Area List'),
      ),
      body: FutureBuilder<List<Area>>(
        future: futureAreas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final area = snapshot.data![index];
              return ListTile(
                title: Text(area.name),
                subtitle:
                    Text('Type: ${area.areaTypeName}, Status: ${area.status}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AreaDetailScreen(area: area),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AreaDetailScreen extends StatelessWidget {
  final Area area;

  AreaDetailScreen({required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(area.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Area Type: ${area.areaTypeName}'),
            Text('Status: ${area.status}'),
            Text('Is Unit: ${area.isUnit}'),
            Text('Is Active: ${area.isActive}'),
            Text('Note: ${area.note ?? 'N/A'}'),
            Text('Description: ${area.description ?? 'N/A'}'),
            SizedBox(height: 16.0),
            Text('Owners:', style: TextStyle(fontWeight: FontWeight.bold)),
            // Check if owners list is empty
            area.owners.isEmpty
                ? Text('No owners available')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: area.owners
                        .map((owner) => Text(owner.userName))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
