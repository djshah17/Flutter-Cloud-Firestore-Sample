import 'package:flutter/material.dart';
import 'package:fluttercloudfirestoresample/firestore_helper.dart';
import 'package:fluttercloudfirestoresample/worker.dart';

import 'workers_list_screen.dart';

class AddEditWorkerScreen extends StatefulWidget {
  bool isEdit;
  Worker selectedWorker;

  AddEditWorkerScreen(this.isEdit, [this.selectedWorker]);

  @override
  State<StatefulWidget> createState() {
    return AddEditWorkerScreenState();
  }
}

class AddEditWorkerScreenState extends State<AddEditWorkerScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    if (widget.isEdit) {
      nameController.text = widget.selectedWorker.workerName.toString();
      salaryController.text = widget.selectedWorker.workerSalary.toString();
      ageController.text = widget.selectedWorker.workerAge.toString();
    }

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Worker Name:", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(controller: nameController),
                      )
                    ],
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Worker Salary:", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                            controller: salaryController,
                            keyboardType: TextInputType.number),
                      )
                    ],
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Worker Age:", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                            controller: ageController,
                            keyboardType: TextInputType.number),
                      )
                    ],
                  ),
                  SizedBox(height: 100),
                  RaisedButton(
                    color: Colors.grey,
                    child: Text("Submit",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    onPressed: () {
                      var getWorkerName = nameController.text;
                      var getWorkerSalary = salaryController.text;
                      var getWorkerAge = ageController.text;
                      if (getWorkerName.isNotEmpty &&
                          getWorkerSalary.isNotEmpty &&
                          getWorkerAge.isNotEmpty) {
                        if (widget.isEdit) {
                          Worker updateWorker = Worker(
                            workerId: widget.selectedWorker.workerId,
                              workerName: getWorkerName,
                              workerSalary: getWorkerSalary,
                              workerAge: getWorkerAge);
                          FireStoreHelper.updateWorker(worker: updateWorker);
                        } else {
                          Worker addWorker = Worker(
                              workerName: getWorkerName,
                              workerSalary: getWorkerSalary,
                              workerAge: getWorkerAge);
                          FireStoreHelper.addWorker(worker: addWorker);
                        }
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => WorkersListScreen()),
                                (r) => false);
                      }
                    },
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
