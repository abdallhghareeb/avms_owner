// import 'dart:async';
// import 'package:total/provider/home_provider.dart';
// import 'package:workmanager/workmanager.dart';
//
//
// class BackgroundTask {
//
//
//   void main() {
//     Workmanager().initialize(callbackDispatcher);
//     Workmanager().registerPeriodicTask(
//       "1", // Task ID
//       "driver_columns_deletion", // Task name
//       initialDelay: Duration(seconds: 10), // Delay before the first execution
//       frequency: Duration(hours: 4), // Run task every 4 hours
//     );
//   }
//   void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) {
//       // Call the deleteDriverColumns() method from your HomeProvider to delete driver columns
//       HomeProvider homeProvider = HomeProvider();
//       homeProvider.deleteDriverColumns();
//       return Future.value(true);
//     });
//   }
// }
//
