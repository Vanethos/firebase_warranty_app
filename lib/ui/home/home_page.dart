import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warranty_app_example/data/models/warranty.dart';
import 'package:warranty_app_example/ui/navigation.dart';

var mockData = generateWarranties();

const warrantyCollection = "warranties";

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({@required this.user, Key key}) : super(key: key);

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Warranties"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => showExitDialog(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(warrantyCollection)
              .where('user', isEqualTo: widget.user.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Loading...');
              default:
                if (snapshot.data.docs != null && snapshot.data.docs.isNotEmpty) {
                  return ListView(
                    children: snapshot.data.docs
                        .map((document) =>
                        _WarrantyItem(Warranty.fromFirestore(document)))
                        .toList(),
                  );
                }
                return const Text('No warranties added');
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var warranty = await showAddDialog(context);
          debugPrint("wattanty: $warranty");
          if (warranty != null) {
            debugPrint("Adding new entry to firebase");
            await _addNewEntry(warranty);
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }

  Future<void> _addNewEntry(Warranty warranty) async {
    return FirebaseFirestore.instance.collection(warrantyCollection).doc().set({
      'user': widget.user.email,
      'name': warranty.name,
      'company': warranty.company,
      'date': warranty.date
    }).catchError((error) => debugPrint(error.toString())).then((_) => debugPrint("done!"));
  }
}

class _WarrantyItem extends StatelessWidget {
  final Warranty warranty;

  const _WarrantyItem(this.warranty);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.folder_open,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Name: ${warranty.name}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Company: ${warranty.company}"),
                  Text(
                      "Date: ${DateTime.fromMillisecondsSinceEpoch(warranty.date)}"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<Warranty> generateWarranties() {
  var warranties = <Warranty>[];
  for (var i = 1; i < 100; i++) {
    warranties.add(Warranty("Warranty $i", "Company $i",
        (DateTime.now().millisecondsSinceEpoch - i * 1000 * 1000)));
  }
  return warranties;
}

String validateTextFields(String value) {
  if (value == null || value == "") {
    return "Text Fields cannot be null";
  }
  return null;
}

String validateMonthFields(String value) {
  if (value == null || value == "") {
    return "Text must not be null";
  }
  try {
    var month = int.parse(value);
    if (month > 12 || month < 1) {
      return "Invalid month";
    }
  } catch (e) {
    return "Text Fields must be numbers";
  }
  return null;
}

String validateYearFields(String value) {
  if (value == null || value == "") {
    return "Text must not be null";
  }
  try {
    var year = int.parse(value);
    if (year < DateTime.now().year) {
      return "Invalid year";
    }
  } catch (e) {
    return "Text Fields must be numbers";
  }
  return null;
}

void showExitDialog(BuildContext context) {
  // Create keys to be able to reference each form field
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Logout?"),
            actions: <Widget>[
              FlatButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, null);
                  navigateToLoginPage(context);
                },
              ),
            ],
          ));
}

Future<Warranty> showAddDialog(BuildContext context) {
  debugPrint("we show a dialog");
  // Create keys to be able to reference each form field
  var nameFormkey = GlobalKey<FormFieldState>();
  var companyFormkey = GlobalKey<FormFieldState>();
  var monthFormkey = GlobalKey<FormFieldState>();
  var yearFormkey = GlobalKey<FormFieldState>();
  return showDialog<Warranty>(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(Icons.add_circle_outline),
                SizedBox(
                  width: 8,
                ),
                Text("Add a Warranty"),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: nameFormkey,
                    validator: validateTextFields,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      suffixIcon: Icon(Icons.account_box),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    key: companyFormkey,
                    validator: validateTextFields,
                    decoration: InputDecoration(
                      hintText: 'Company',
                      suffixIcon: Icon(Icons.home),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          key: monthFormkey,
                          validator: validateMonthFields,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'MM',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          key: yearFormkey,
                          validator: validateYearFields,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'YYYY',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text("CLOSE"),
                onPressed: () {
                  Navigator.pop(context, null);
                },
              ),
              FlatButton(
                child: const Text("ADD"),
                onPressed: () {
                  // validate all keys
                  var yearFormValidation = yearFormkey.currentState.validate();
                  var monthFormValidation =
                      monthFormkey.currentState.validate();
                  var companyFormValidation =
                      companyFormkey.currentState.validate();
                  var nameFormValidation = nameFormkey.currentState.validate();
                  if (yearFormValidation &&
                      monthFormValidation &&
                      companyFormValidation &&
                      nameFormValidation) {
                    Navigator.pop(
                        context,
                        Warranty(
                            nameFormkey.currentState.value,
                            companyFormkey.currentState.value,
                            DateTime(int.parse(yearFormkey.currentState.value),
                                    int.parse(monthFormkey.currentState.value))
                                .millisecondsSinceEpoch));
                  }
                },
              ),
            ],
          ));
}
