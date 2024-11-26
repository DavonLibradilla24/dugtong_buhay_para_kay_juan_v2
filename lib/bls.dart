import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BlsPage extends StatefulWidget {
  @override
  _BlsPageState createState() => _BlsPageState();
}

class _BlsPageState extends State<BlsPage> {
  final List<Map<String, dynamic>> steps = [
    {
      "title": "Check for Scene Safety",
      "description":
      "- Survey the area for scene safety first.\n"
          "- Ensure the environment is safe for both the rescuer and the victim.\n"
          "- Use gloves and a mask (Personal Protective Equipment).",
      "image": "assets/scene_safety.gif",
    },
    {
      "title": "Introduce Yourself",
      "description":
      "- Introduce yourself to the victim or bystander if there is one (conscious or unconscious).\n"
          "- Say: \"I'm [Your name]. I know BLS/CPR. I can help.\"",
      "image": "assets/introduce_yourself.gif",
    },
    {
      "title": "Check for Responsiveness",
      "description":
      "- Tap shoulders (for child to adult) or tap the sole of the feet (for infant) and ask, \"Are you OK?\" three times.\n"
          "- If the patient is responsive or awake, monitor or observe their condition and call the Barangay Health Emergency Response Team.",
      "image": "assets/check_responsiveness.gif",
    },
    {
      "title": "Check For Breathing",
      "description":
      "- Observe visually for chest rise.\n"
          "- Breathing is not normal if the patient is gasping.",
      "image": "assets/check_breathing.gif",
    },
    {
      "title": "Check For Pulse",
      "description":
      "- For adult to child: Check the carotid pulse (carotid artery on the side of the neck).\n"
          "- For infant: Check the brachial or femoral pulse (brachial is in the crease of the elbow, femoral is in the upper thigh near the groin area).",
      "image": "assets/check_pulse.gif",
    },
    {
      "title": "Activate Emergency Response System (EMS)",
      "description":
      "- Point and instruct someone to call for help if someone is present.\n"
          "- Instruct someone to get an AED/defibrillator if someone is present.\n"
          "- Key: If no one is there and you witness the victim losing consciousness on the spot, prioritize calling for help and getting the AED. However, if you find the victim lying unconscious, not breathing, and without a pulse, prioritize CPR.",
      "image": "assets/activate_ems.gif",
    },
    {
      "title": "Open Airway",
      "description":
      "- Tilt the head back with one hand and lift up the chin with the other hand.",
      "image": "assets/open_airway.gif",
    },
    {
      "title": "Perform High-Quality CPR",
      "description":
      "- Correct Compression Site:\n"
          "  - For adult: Place the dominant hand on the center of the chest, followed by the second hand on top.\n"
          "  - For child: Place the dominant hand on the lower half of the sternum (between the nipples). Use the second hand on top if the child is big.\n"
          "  - For infant: Place two fingers on the lower half of the sternum below the nipple line (wrist flexing).\n"
          "- Adequate Compression Rate:\n"
          "  - 100-120 compressions per minute.\n"
          "- Adequate Compression Depth:\n"
          "  - For adult: 2-2.4 inches.\n"
          "  - For child: 2 inches.\n"
          "  - For infant: 1.5 inches.\n"
          "- Observe chest recoil (natural rising of the chest) after each compression.\n"
          "- Minimize interruptions to less than 10 seconds between chest compressions.\n"
          "- Avoid excessive ventilation: Maintain 30 compressions to 2 full breaths, with each breath not longer than 1 second.",
      "image": "assets/high_quality_cpr.gif",
    },
    {
      "title": "Reassess Patient's Condition",
      "description":
      "- Continue compressions if there are no signs of the return of spontaneous circulation (ROSC).\n"
          "- Monitor and observe the patient if there are signs of spontaneous circulation.",
      "image": "assets/reassess_patient.gif",
    },
    {
      "title": "Notes: When to Start CPR",
      "description":
      "- Start CPR under these three conditions:\n"
          "  - The patient is unconscious/unresponsive.\n"
          "  - The patient is not breathing or is only gasping.\n"
          "  - There is no definite pulse.",
      "image": "assets/start_cpr.gif",
    },
    {
      "title": "Notes: When to Stop CPR",
      "description":
      "Remember S.T.O.P.S.S. \n"
          "S: Spontaneous signs of circulation are restored.\n"
          "T: Turned over to medical services or properly trained and authorized personnel.\n"
          "O: Rescuer is exhausted and cannot continue CPR.\n"
          "P: Physician assumes responsibility (declares the time of death, takes over the situation, etc.).\n"
          "S: The scene becomes unsafe.\n"
          "S: Signed waiver to stop CPR.",
      "image": "assets/stop_cpr.gif",
    },
    {
      "title": "Use of AED",
      "description":
      "- During the wait for the arrival of an AED, CPR must not cease.\n"
          "- Remember P.A.A.S:\n"
          "  - Power on the AED and follow voice prompts. Prepare the chest by exposing it. Dry or shave the area if necessary.\n"
          "  - Attach pads to the victim's bare chest:\n"
          "    - For victims under 8 years old: Use child pads if available. If not, use adult pads as long as they don’t touch each other. Use the child shock dose by turning the key or switch.\n"
          "    - For victims 8 years old or older: Use adult pads only, with the shock dose appropriate for this age.\n"
          "  - \"Analyzing heart rhythm, do not touch the patient\": Follow the AED's voice prompts and remind co-rescuers or bystanders not to touch the victim.\n"
          "  - Shock delivery decision:\n"
          "    - If AED prompts \"Shock Advised\":\n"
          "      - Warn others verbally by shouting \"Clear.\"\n"
          "      - Press the shock button on the AED. Continue CPR immediately after the shock.\n"
          "    - If AED prompts \"No Shock Advised\":\n"
          "      - Continue CPR and listen to the AED's next voice prompts.",
      "image": "assets/use_aed.gif",
    },
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic Life Support Guide"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Progress dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(steps.length, (index) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
            // Carousel Slider
            Expanded(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: screenHeight * 0.8,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                items: steps.map((step) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Responsive image container
                        Container(
                          height: screenHeight * 0.4, // 40% of screen height for image
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: AssetImage(step["image"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Scrollable content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05, // 5% of screen width
                              vertical: screenHeight * 0.02, // 2% of screen height
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step["title"],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05, // 5% of screen width
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01), // 1% of screen height
                                Text(
                                  step["description"],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04, // 4% of screen width
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
