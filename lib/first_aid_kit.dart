import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstAidKitPage extends StatefulWidget {
  @override
  _FirstAidKitPageState createState() => _FirstAidKitPageState();
}

class _FirstAidKitPageState extends State<FirstAidKitPage> {
  // List of first aid kit items with names, images (optional), and checked state
  final List<Map<String, dynamic>> kitItems = [
    {'name': 'Triangular Bandage', 'image': 'assets/triangular_bandage.png', 'checked': false},
    {'name': 'Wound Dressing', 'image': 'assets/wound_dressing.png', 'checked': false},
    {'name': 'Disposable Gloves', 'image': 'assets/disposable_gloves.png', 'checked': false},
    {'name': 'Alcohol', 'image': 'assets/alcohol.png', 'checked': false},
    {'name': 'Providone Iodine', 'image': 'assets/providone_iodine.png', 'checked': false},
    {'name': 'Conforming Bandage', 'image': 'assets/conforming_bandage.png', 'checked': false},
    {'name': 'Cotton Applicator', 'image': 'assets/cotton_applicator.png', 'checked': false},
    {'name': 'Face Mask', 'image': 'assets/face_mask.png', 'checked': false},
    {'name': 'Oral Solution', 'image': 'assets/oral_solution.png', 'checked': false},
    {'name': 'Whistle', 'image': 'assets/whistle.png', 'checked': false},
    {'name': 'Flashlight', 'image': 'assets/flashlight.png', 'checked': false},
    {'name': 'Reusable Bandage', 'image': 'assets/reusable_bandage.png', 'checked': false},
    {'name': 'Micropore Tape', 'image': 'assets/micropore_tape.png', 'checked': false},
    {'name': 'Scissors', 'image': 'assets/scissors.png', 'checked': false},
    {'name': 'Safety Pin', 'image': 'assets/safety_pin.png', 'checked': false},
    {'name': 'Tweezers', 'image': 'assets/tweezers.png', 'checked': false},
    {'name': 'Multi-purpose Knife', 'image': 'assets/multi_purpose_knife.png', 'checked': false},
    {'name': 'Battery', 'image': 'assets/battery.png', 'checked': false},
    {'name': 'Glow Sticks', 'image': 'assets/glowstick.png', 'checked': false},
    {'name': 'Garbage Bag', 'image': 'assets/garbage_bag.png', 'checked': false},
    {'name': 'Match Sticks', 'image': 'assets/match_sticks.png', 'checked': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadCheckboxStates();
  }

  // Load saved checkbox states from SharedPreferences
  Future<void> _loadCheckboxStates() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < kitItems.length; i++) {
      bool isChecked = prefs.getBool('checklistItem_$i') ?? false;
      setState(() {
        kitItems[i]['checked'] = isChecked;
      });
    }
  }

  // Save checkbox state to SharedPreferences
  Future<void> saveCheckboxState(int index, bool isChecked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checklistItem_$index', isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Aid Kit Checklist"),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: kitItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 12), // Add spacing between cards
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Rounded corners for the image
                    child: Image.asset(
                      kitItems[index]['image'],
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(width: 15), // Space between image and text

                  Expanded(
                    child: Text(
                      kitItems[index]['name'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),

                  // Checkbox
                  Checkbox(
                    value: kitItems[index]['checked'],
                    activeColor: Colors.blue,
                    onChanged: (bool? value) {
                      setState(() {
                        kitItems[index]['checked'] = value!;
                      });
                      saveCheckboxState(index, value!); // Save the checkbox state
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
