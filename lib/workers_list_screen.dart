import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttercloudfirestoresample/add_edit_worker_screen.dart';
import 'package:fluttercloudfirestoresample/firestore_helper.dart';
import 'worker.dart';

class WorkersListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WorkersListScreenState();
  }
}

class WorkersListScreenState extends State<WorkersListScreen> {
  List<Worker> listWorkers = [];

  Future<FirebaseApp> initializeFirebaseApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Flutter Cloud Firestore Sample"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddEditWorkerScreen(false)));
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: initializeFirebaseApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error initializing Firebase');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<QuerySnapshot>(
                stream: FireStoreHelper.getWorkers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                          return Container(
                            padding: EdgeInsets.all(15),
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(height: 16.0),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, position) {
                                var workersData = snapshot.data.docs[position].data();
                                var docID = snapshot.data.docs[position].id;
                                var getWorker = Worker(workerId: docID, workerName : workersData['name'], workerSalary : workersData['salary'], workerAge : workersData['age']);
                                var salary = getWorker.workerSalary;
                                var age = getWorker.workerAge;
                                listWorkers.add(getWorker);
                                return Card(
                                    elevation: 8,
                                    child: Container(
                                      height: 80,
                                      padding: EdgeInsets.all(15),
                                      child: Stack(
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(getWorker.workerName, style: TextStyle(fontSize: 18))),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 45),
                                              child: IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                AddEditWorkerScreen(
                                                                    true,
                                                                    getWorker)));
                                                  }),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  FireStoreHelper.deleteWorker(workerId: getWorker.workerId);
                                                  setState(() => {
                                                        listWorkers.removeWhere(
                                                            (item) =>
                                                                item.workerId ==
                                                                getWorker.workerId)
                                                      });
                                                }),
                                          ),
                                          Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                  "Salary: $salary | Age: $age",
                                                  style: TextStyle(fontSize: 18))),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          );
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFF57C00),
                    ),
                  );
                });
          }
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFFF57C00),
            ),
          );
        },
      ),
    ));
  }
}
