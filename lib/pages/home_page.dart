import 'dart:async';

import 'package:dojo/widget/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  List<String> listNomes = [];

  late Completer<SharedPreferences> prefs = Completer();

  @override
  void initState() {
    super.initState();

    load();
  }

  Future<void> load() async {
    final i = await SharedPreferences.getInstance();

    print(i);
    List<String> list =  i.getStringList('listaDojo') ?? [];
    prefs.complete(i);
    setState(() {
      listNomes.addAll(list);
    });
  }

  createItem({required String name}) async {
    try {
      setState(() {
        listNomes.add(name);
      });

      var repository = await prefs.future;
      repository.setStringList('listaDojo', listNomes);
      controller.clear();
    } catch (e, s) {
      debugPrintStack(stackTrace: s, label: e.toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  deleteItem({required int index}) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item Deletado!: ${listNomes[index]}')));
    setState(() {
      listNomes.removeAt(index);
    });
    var repository = await prefs.future;
    repository.setStringList('listaDojo', listNomes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter dojo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  label: Text('Nome'), border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                createItem(name: controller.text);
              },
              child: const Text('Add')),
          Expanded(
            child: ListView.builder(
              itemCount: listNomes.length,
              itemBuilder: (context, index) {
                return CardWidget(
                  title: listNomes[index],
                  onpress: () {
                    deleteItem(index: index);
                  },
                );
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    child: ListTile(
                      title: Text(listNomes[index]),
                      trailing: IconButton(
                          onPressed: () {
                            deleteItem(index: index);
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
