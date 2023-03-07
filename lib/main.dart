import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Login Screen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const FlutterLogo(
              size: 35,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 340,
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    ),
                  ),
                ],
              )
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Log In"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(330, 40),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot password?"),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                primary: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
