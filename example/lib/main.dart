import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_contacts_plus/flutter_contacts_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Permisions _permisions = Permisions.unknown;
  List<ContactPlus> _contacts = [];
  final _flutterContactsPlusPlugin = FlutterContactsPlus();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      await checkPermissions();
    } on PlatformException catch (e, _) {
      if (!mounted) return;
      setState(() {
        _permisions = Permisions.unknown;
      });
    }
  }

  checkPermissions() {
    _flutterContactsPlusPlugin.checkPermission().then((permission) {
      setState(() {
        _permisions = permission;
      });
      if (permission == Permisions.granted) {
        setUpListent();
      }
    });
  }

  updateContacts() {
    _flutterContactsPlusPlugin.getContacts().then((value) => setState(() {
          _contacts = value;
        }));
  }

  setUpListent() {
    updateContacts();
    _flutterContactsPlusPlugin.listent().listen((event) async {
      print(event);
      updateContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.plus_one),
        ),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_permisions\n'),
              if (_permisions != Permisions.granted)
                TextButton(
                    onPressed: () {
                      // checkPermissions();
                      _flutterContactsPlusPlugin
                          .requestPermission()
                          .then((value) async {
                        checkPermissions();
                      });
                    },
                    child: const Text("Request permisions")),
              if (_permisions == Permisions.granted)
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      final contact = _contacts[index];
                      return ListTile(
                        title: Text(contact.displayName),
                        subtitle:
                            Text(contact.phones.firstOrNull?.number ?? ""),
                      );
                    },
                    itemCount: _contacts.length,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
