import 'package:flutter/material.dart';

class AddAppliancePage extends StatefulWidget {
  const AddAppliancePage({super.key});

  @override
  State<AddAppliancePage> createState() => _AddAppliancePageState();
}

Map categories = new Map(); // Map

String testa = '';

const List<String> listCategory = <String>[
  'Kitchen',
  'Desk/Work Appliance',
  'Entertainment',
  'Heating/Cooling',
  'Lights',
  'Other'
];

const List<String> listKitchenName = <String>[
  'Microwave',
  'Air Fryer',
  'Toaster',
  'Blender'
];
const List<String> listEntertainmentName = <String>[
  'Microwave',
  'Air Fryer',
  'Toaster',
  'Blender'
];
const List<String> list3 = <String>['One', 'Two', 'Three', 'Four'];

int categorySelector(String category) {
  switch (category) {
    case 'Kitchen':
      return 0;
    case 'Desk/Work Appliance':
      return 1;
    default:
      return 2;
  }
}

class _AddAppliancePageState extends State<AddAppliancePage> {
  String dropdownValue = listCategory.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: false,
        toolbarHeight: 80,
        title: Text(
          "Add Appliance",
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                /*Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen),
                        onPressed: () {},
                        child: Text('Elevated Button')),
                    SizedBox(width: 5),
                    Text('Test Notifications'),
                  ],
                ),*/
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /* Get user input
                      /TextField(
                        //controller: controller1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Add Appliance Name"),
                      ),
                      const SizedBox(height: 5),
                      // Get user input
                      TextField(
                        //controller: controller2,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Add Appliance Brand"),
                      ),
                      const SizedBox(height: 5),
                      // Get user input
                      TextField(
                        //controller: controller3,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Add Appliance Watts"),
                      ),*/
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          DropdownMenu<String>(
                            // ---------------------------------------------- CATEGORIES
                            initialSelection: listCategory.first,
                            onSelected: (String? value) {
                              /*if (value == 'Desk/Work Appliance') {
                                testa = 1;
                              }*/
                              //testa = value;
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            dropdownMenuEntries: listCategory
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                          Text("Appliance Category"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          DropdownMenu<String>(
                            // ----------------------------------------------- CATEGORY ITEMS
                            initialSelection: listKitchenName.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            dropdownMenuEntries: listKitchenName
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                          Text("Appliance Name"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          DropdownMenu<String>(
                            // ------------------------------------------------ WATTS
                            initialSelection: list3.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            dropdownMenuEntries: list3
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                          Text("Appliance Watts"),
                        ],
                      ),

                      const SizedBox(height: 10),
                      //buttons -> save + cancel
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // save button
                          /*MyButton(
                            text: "Save",
                            onPressed: () {},
                            buttonColor: Colors.amber,
                          ),*/
                          // const SizedBox(width: 8),
                          // cancel button
                          // MyButton(text: "Cancel", onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
