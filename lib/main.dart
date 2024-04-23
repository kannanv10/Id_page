import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firstpage/greenhouse_details.dart';
import 'package:flutter/widgets.dart';
var selectedGreenKey;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyDSSIBsrEztVBv4DiP8OTFJxh7F1degUNY",
          appId: "1:778925904779:android:4e7786eb5d68009a17158e",
          messagingSenderId: "778925904779",
          projectId:"flutter-d8e01",
          databaseURL: "https://flutter-d8e01-default-rtdb.firebaseio.com/")
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      home: FirebaseDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirebaseDemo extends StatefulWidget {
  @override
  _FirebaseDemoState createState() => _FirebaseDemoState();
}

class _FirebaseDemoState extends State<FirebaseDemo> {
  String kannanKey = "0";
  Greenhouse? greenhouseRetrievedDetails;
  String? selectedGreenKey;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("user/1@gmail");
    ref.once().then((event) {
      DataSnapshot snapshot = event.snapshot;
      print(snapshot.value.toString());

      setState(() {
        kannanKey = snapshot.value.toString(); // Update kannanKey with the retrieved value
      });
    }).catchError((error) {
      print("Failed to fetch data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Extract Green keys from kannanKey and convert them into a list
    List<String> greenKeys = extractGreenKeys(kannanKey);
    print(greenKeys);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Automated Irrigation System'),
        titleTextStyle: TextStyle(fontSize: 19),
        backgroundColor: Colors.green[700],
      ),
      backgroundColor: Colors.purple[50],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(vertical: 60.0),
          decoration: BoxDecoration(
            color: Colors.green[400],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select the greenhouse to load value',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Show the dropdown menu
                  showGreenKeysDropdown(context, greenKeys);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                ),
                child: Text(selectedGreenKey ?? 'Select a Greenhouse device '),
              ),
              SizedBox(height: 16.0),
              // Text(
              //   'Selected Green Key: ${selectedGreenKey ?? "None"}',
              //   style: TextStyle(fontSize: 16, color: Colors.white),
              //   textAlign: TextAlign.center,
              // ),
              ],
          ),
        ),
      ),
    );
  }

  void showGreenKeysDropdown(BuildContext context, List<String> greenKeys) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Greenhouse device'),
          content: DropdownButton<String>(
            value: selectedGreenKey, // Set the selected value
            onChanged: (String? newValue) {
              setState(() {
                selectedGreenKey = newValue; // Update the selected value
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            items: greenKeys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

List<String> extractGreenKeys(String kannanKey) {
  // Define a regular expression pattern to match "GreenX"
  RegExp regex = RegExp(r'Green\d');

  // Find all matches in the kannanKey string
  Iterable<RegExpMatch> matches = regex.allMatches(kannanKey);

  // Extract matched substrings
  List<String> greenKeys = matches.map((match) => match.group(0)!).toList();

  return greenKeys;
}







// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: FirebaseOptions(apiKey: "AIzaSyDSSIBsrEztVBv4DiP8OTFJxh7F1degUNY",
//           appId: "1:778925904779:android:4e7786eb5d68009a17158e",
//           messagingSenderId: "778925904779",
//           projectId:"flutter-d8e01",
//           databaseURL: "https://flutter-d8e01-default-rtdb.firebaseio.com/")
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Demo',
//       home: FutureBuilder<List<Greenhouse>>(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Scaffold(
//               appBar: AppBar(title: Text('Firebase Demo')),
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else if (snapshot.hasError) {
//             return Scaffold(
//               appBar: AppBar(title: Text('Firebase Demo')),
//               body: Center(child: Text('Error: ${snapshot.error}')),
//             );
//           } else {
//             return FirebaseDemo(greenhouses: snapshot.data!);
//           }
//         },
//       ),
//     );
//   }
// }
//
// class FirebaseDemo extends StatelessWidget {
//   final List<Greenhouse> greenhouses;
//
//   FirebaseDemo({required this.greenhouses});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Demo'),
//       ),
//       body: ListView.builder(
//         itemCount: greenhouses.length,
//         itemBuilder: (context, index) {
//           Greenhouse greenhouse = greenhouses[index];
//           return ListTile(
//             title: Text('User ID: ${greenhouse.userId}'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 for (var entry in greenhouse.greenhouseDetails.entries)
//                   Text('${entry.key}: ${entry.value}'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class Greenhouse {
//   final String userId;
//   final Map<String, GreenhouseDetail> greenhouseDetails;
//
//   Greenhouse({
//     required this.userId,
//     required this.greenhouseDetails,
//   });
//
//   factory Greenhouse.fromJson(Map<String, dynamic> json) {
//     Map<String, dynamic> detailsJson = json['greenhouseDetails'];
//     Map<String, GreenhouseDetail> details = detailsJson.map((key, value) =>
//         MapEntry(key, GreenhouseDetail.fromJson(value)));
//
//     return Greenhouse(
//       userId: json['userId'],
//       greenhouseDetails: details,
//     );
//   }
// }
//
// class GreenhouseDetail {
//   final String motorStatus;
//   final double operationTime;
//   final double panValue;
//
//   GreenhouseDetail({
//     required this.motorStatus,
//     required this.operationTime,
//     required this.panValue,
//   });
//
//   factory GreenhouseDetail.fromJson(Map<String, dynamic> json) {
//     return GreenhouseDetail(
//       motorStatus: json['Motor status'],
//       operationTime: double.parse(json['Operation time']),
//       panValue: double.parse(json['Pan_value']),
//     );
//   }
//
//   @override
//   String toString() {
//     return 'Motor Status: $motorStatus, Operation Time: $operationTime, Pan Value: $panValue';
//   }
// }
//
// Future<List<Greenhouse>> fetchData() async {
//   DatabaseReference ref = FirebaseDatabase.instance.ref("usersgreenhouse");
//   DataSnapshot snapshot;
//   try {
//     // Fetch data and wait for the DatabaseEvent
//     DatabaseEvent event = await ref.once();
//     // Access the DataSnapshot from the DatabaseEvent
//     snapshot = event.snapshot;
//   } catch (error) {
//     print("Failed to fetch data: $error");
//     return []; // Return an empty list if fetching data fails
//   }
//
//   if (snapshot.value == null) {
//     print("No data available");
//     return []; // Return an empty list if no data is available
//   }
//
//   List<Greenhouse> greenhouses = [];
//
//   // Check if the value is not null before casting
//   if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
//     Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
//     data.forEach((key, value) {
//       Greenhouse greenhouse = Greenhouse.fromJson({
//         'userId': key,
//         'greenhouseDetails': value['greenhouseDetails'],
//       });
//       greenhouses.add(greenhouse);
//     });
//   } else {
//     print("Invalid data format");
//     return []; // Return an empty list if the data format is invalid
//   }
//
//   return greenhouses;
// }

// working fine
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firstpage/greenhouse_details.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: FirebaseOptions(apiKey: "AIzaSyDSSIBsrEztVBv4DiP8OTFJxh7F1degUNY",
//           appId: "1:778925904779:android:4e7786eb5d68009a17158e",
//           messagingSenderId: "778925904779",
//           projectId:"flutter-d8e01",
//           databaseURL: "https://flutter-d8e01-default-rtdb.firebaseio.com/")
//           );
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Demo',
//       home: FirebaseDemo(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class FirebaseDemo extends StatefulWidget {
//   @override
//   _FirebaseDemoState createState() => _FirebaseDemoState();
// }
//
// class _FirebaseDemoState extends State<FirebaseDemo> {
//   String kannanKey = "0";
//   Greenhouse? greenhouseRetrievedDetails;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   void fetchData() async {
//     DatabaseReference ref = FirebaseDatabase.instance.ref("user/1@gmail");
//     ref.once().then((event) {
//       DataSnapshot snapshot = event.snapshot;
//       print(snapshot.value.toString());
//
//       setState(() {
//         //greenhouseRetrievedDetails = snapshot;
//         kannanKey = snapshot.value.toString(); // Update kannanKey with the retrieved value
//       });
//     }).catchError((error) {
//       print("Failed to fetch data: $error");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Extract Green keys from kannanKey and convert them into a list
//     List<String> greenKeys = extractGreenKeys(kannanKey);
//     print(greenKeys);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome to Automated Irrigation System'),
//         titleTextStyle: TextStyle(fontSize: 19),
//         backgroundColor: Colors.green[700],
//       ),
//       backgroundColor: Colors.purple[50],
//       body: Center(
//
//
//         child: ListView.builder(
//           itemCount: greenKeys.length,
//           itemBuilder: (context, index) {
//             String key = greenKeys[index];
//             return Container(
//
//
//               margin: EdgeInsets.all(8.0),
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.green[400],
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     key,
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Add your load button functionality here
//                     },
//                     child: Text('Load'),
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );;
//   }
// }
//
// List<String> extractGreenKeys(String kannanKey) {
//   // Define a regular expression pattern to match "GreenX"
//   RegExp regex = RegExp(r'Green\d');
//
//   // Find all matches in the kannanKey string
//   Iterable<RegExpMatch> matches = regex.allMatches(kannanKey);
//
//   // Extract matched substrings
//   List<String> greenKeys = matches.map((match) => match.group(0)!).toList();
//
//   return greenKeys;
// }
//

//
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: FirebaseOptions(apiKey: "AIzaSyDSSIBsrEztVBv4DiP8OTFJxh7F1degUNY",
//           appId: "1:778925904779:android:4e7786eb5d68009a17158e",
//           messagingSenderId: "778925904779",
//           projectId:"flutter-d8e01",
//           databaseURL: "https://flutter-d8e01-default-rtdb.firebaseio.com/")
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Demo',
//       home: FirebaseDemo(),
//     );
//   }
// }
//
// class FirebaseDemo extends StatefulWidget {
//   @override
//   _FirebaseDemoState createState() => _FirebaseDemoState();
// }
//
// class _FirebaseDemoState extends State<FirebaseDemo> {
//   String kannanKey = "kannan2003spmn@gmail";
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//
//   void fetchData() async {
//
//     DatabaseReference ref = FirebaseDatabase.instance.ref("kannan2003spmn@gmail");
//     ref.once().then((event) {
//       DataSnapshot snapshot = event.snapshot; // Access the DataSnapshot from the DatabaseEvent
//       setState(() {
//         kannanKey = snapshot.value.toString(); // Cast to Map<String, dynamic> explicitly
//       });
//       print(kannanKey);
//     }).catchError((error) {
//       print("Failed to fetch data: $error");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Demo'),
//       ),
//       body: Center(
//       child: Text(kannanKey),
//       ),
//     );
//   }
// }

// import 'dart:ffi';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// DatabaseReference Panval = FirebaseDatabase.instance.ref().child("Operation time");
// String pan = "0";
// DatabaseReference ref = FirebaseDatabase.instance.ref("kannan2003spmn@gmail");
//
// //final ref = FirebaseDatabase.instance.ref("kannan2003spmn@gmail");
// //DatabaseEvent event = await ref.once();
// //DatabaseReference child = ref.child("Motor Status");
//
//
// //DataSnapshot event = await query.get();
//
// setState(){
//   pan = ref.key.toString();
// }
//
// Future <void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: FirebaseOptions(apiKey: "AIzaSyDSSIBsrEztVBv4DiP8OTFJxh7F1degUNY",
//           appId: "1:778925904779:android:4e7786eb5d68009a17158e",
//           messagingSenderId: "778925904779",
//           projectId:"flutter-d8e01",
//           databaseURL: "https://flutter-d8e01-default-rtdb.firebaseio.com/")
//   );
//
//
//   Query query = ref.orderByChild("Operation time").limitToFirst(10);
//
//
//   DataSnapshot event = await query.get();
//
//   //DatabaseEvent event = await ref.once();
//   fetchData();
//   runApp(MyApp());
// }
// void fetchData() async {
//   // Initialize Firebase app if not already done
//   await Firebase.initializeApp();
//
//   // Create a reference to the "users" node in your Firebase database
//   DatabaseReference ref = FirebaseDatabase.instance.ref("kannan2003spmn@gmail");
//
//   // Query the data to order by child "age" and limit the results to the first 10
//   Query query = ref.orderByChild("Operation time").limitToFirst(10);
//
//   // Get the data snapshot asynchronously
//   DataSnapshot snapshot = await query.get();
//
//   // Check if there is data available
//   if (snapshot.value != null) {
//     // Iterate over the children of the snapshot
//     (snapshot.value as Map).forEach((key, value) {
//       // Print the data for each child
//       print("Key: $key, Value: $value");
//     });
//   }else {
//     print("No data available.");
//   }
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     //print(ref.key);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Flutter Demo",
//       theme: ThemeData(
//         primarySwatch: Colors.cyan,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: Reltime(),
//
//     );
//   }
// }
//
// class Reltime extends StatelessWidget {
//   const Reltime({super.key});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         titleTextStyle: TextStyle(fontSize: 20,color: Colors.black),
//         title: Text("Welcome to Automated Irrigation System"),
//       ),
//
//       body: Column(
//         children: [
//           Expanded(child: Text(ref.onValue.toString())
//
//
//           )
//         ],
//       ),
//     );
//   }
// }
// // FirebaseAnimatedList(query: ref, itemBuilder: (context, snapshot, animation, index) {
// // return ListTile(
// // title: Text(snapshot.child("Pan").value.toString()),
// // );
// // })
