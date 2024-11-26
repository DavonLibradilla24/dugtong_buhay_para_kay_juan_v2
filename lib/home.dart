import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'hospital.dart';
import 'socials.dart';
import 'help.dart';
import 'bls.dart';
import 'first_aid.dart';
import 'first_aid_kit.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _displayName;
  String? _email;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _handleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        setState(() {
          _displayName = account.displayName;
          _email = account.email;
          _photoUrl = account.photoUrl;
        });

        // Save the user data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('displayName', account.displayName ?? '');
        await prefs.setString('email', account.email);
        await prefs.setString('photoUrl', account.photoUrl ?? '');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _checkSignInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName = prefs.getString('displayName');
      _email = prefs.getString('email');
      _photoUrl = prefs.getString('photoUrl');
    });
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight( screenHeight * .09,),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          child: AppBar(
            backgroundColor: Colors.blueAccent,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Image.asset(
                  'assets/still_logo.png',
                  width: 60,
                  height: 60,
                ),
                IconButton(
                  icon: Icon(Icons.feed),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RssFeedPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: _photoUrl != null
                        ? NetworkImage(_photoUrl!)
                        : AssetImage('assets/profile_placeholder.png') as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _displayName ?? 'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _email ?? 'user@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Sign In with Google'),
              onTap: _handleSignIn,
            ),
          ],
        ),
      ),



      body: ListView(
        children: [
          // Learning Section
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LEARN:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: screenHeight * .12,
                      width: double.infinity, // Ensures the button takes up the full width available
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BlsPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(vertical: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),

                        child: Text(
                          'BASIC LIFE SUPPORT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white, // Set text color
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * .01),
                    SizedBox(
                      height: screenHeight * .12,
                      width: double.infinity, // Ensures the button takes up the full width available
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FirstAidPage()), // Navigate to First Aid Page
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: EdgeInsets.symmetric(vertical: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'FIRST AID',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black, // Set text color
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOOLS:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 12),

                    // Button with Icon for "Nearest Hospital"
                    SizedBox(
                      height: screenHeight * .12,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HospitalPage()), // Navigate to First Aid Page
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_hospital_rounded, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Nearest Hospital',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    SizedBox(
                      height: screenHeight * .12,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FirstAidKitPage()), // Navigate to First Aid Kit Checklist Page
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.checklist, // Checklist icon
                              color: Colors.white,
                              size: 24, // Adjust the size of the icon
                            ),
                            SizedBox(width: 10), // Space between icon and text
                            Text(
                              'First Aid Kit Checklist',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: screenWidth * .3,
        height: screenHeight * .12,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpPage()),
            );
          },
          backgroundColor: Colors.green,
          icon: const Icon(Icons.phone, color: Colors.white),
          label: const Text(
            'Help',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Places FAB at the lower right corner
    );
  }
}






