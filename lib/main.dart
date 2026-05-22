import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void onPress() {
    debugPrint('Button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buoi 4',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Homepage', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(onPressed: onPress, icon: const Icon(Icons.search, color: Colors.white)),
            IconButton(onPressed: onPress, icon: const Icon(Icons.more_vert, color: Colors.white)),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.network('https://picsum.photos/200'),
              Image.asset(
                'assets/cr7.jpg',
                width: 200,
              ),
              const SizedBox(height: 20),
              RichText(text: TextSpan(
                  text: "Hello ", style: const TextStyle(color: Colors.black, fontSize: 19), children:
              [
                TextSpan(text:"Flutter ",
                    style: TextStyle(color: Colors.blue, fontSize: 19)),
                TextSpan(text:" World",
                    style: TextStyle(color: Colors.amber, fontSize: 19)),
              ])

              ),
            ],
          ),
        ),
        drawer:  Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('User Name'),
                accountEmail: Text('user@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onPress,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
