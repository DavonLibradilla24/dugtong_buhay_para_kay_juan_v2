import 'package:flutter/material.dart';

class FirstAidPage extends StatelessWidget {
  final List<Map<String, String>> injuries = [
    {
      'name': 'Sore Eyes',
      'image': 'assets/sore-eyes.png',
      'care': 'Flush the eyes with clean water. Apply a cold compress.',
    },
    {
      'name': 'Wound',
      'image': 'assets/wounded.png',
      'care': 'Clean the wound with clean water and cover it with a sterile bandage.',
    },
    {
      'name': 'Fever',
      'image': 'assets/fever.png',
      'care': 'Rest, stay hydrated, and take fever-reducing medication.',
    },
    {
      'name': 'Heart Attack',
      'image': 'assets/heart-attack.png',
      'care': 'Call emergency services. Perform CPR if necessary.',
    },
    {
      'name': 'Broken Leg',
      'image': 'assets/broken-bone.png',
      'care': 'Keep the leg immobilized and call for emergency medical help.',
    },
    {
      'name': 'Nose Bleeding',
      'image': 'assets/nose-bleeding.png',
      'care': 'Pinch your nose and lean forward to stop the bleeding.',
    },
    {
      'name': 'Seizures',
      'image': 'assets/epilepsy.png',
      'care': 'Protect the person from injury and call for medical help if the seizure lasts more than 5 minutes.',
    },
    {
      'name': 'Cerebral',
      'image': 'assets/cerebral.png',
      'care': 'Seek immediate medical help. Administer CPR if needed.',
    },
    // Add more injuries with care instructions here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Aid - Select an Injury"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns for the grid
            crossAxisSpacing: 16.0, // Horizontal spacing
            mainAxisSpacing: 16.0, // Vertical spacing
          ),
          itemCount: injuries.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to the detail page for the selected injury
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InjuryDetailPage(injury: injuries[index])),
                );
              },
              child: Card(
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(injuries[index]['image']!, width: 60, height: 60),
                    const SizedBox(height: 8),
                    Text(
                      injuries[index]['name']!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class InjuryDetailPage extends StatelessWidget {
  final Map<String, String> injury;

  const InjuryDetailPage({super.key, required this.injury});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(injury['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display injury image
            Image.asset(injury['image']!, width: 150, height: 150),
            const SizedBox(height: 20),
            Text(
              'How to Care for ${injury['name']}:',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              injury['care']!, // Display care instructions from the injury data
              style: const TextStyle(fontSize: 18),
            ),
            // Add more details here if needed
          ],
        ),
      ),
    );
  }
}
