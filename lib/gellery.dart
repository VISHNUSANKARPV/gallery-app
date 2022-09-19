import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

ValueNotifier<List<String>> imagelist = ValueNotifier([]);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getimsge() async {
    XFile? img = await ImagePicker().pickImage(source: ImageSource.camera);
    if (img!= null) {
      var dir = await getExternalStorageDirectory();
      if (dir != null && !dir.existsSync()) {
        Directory(dir.path).createSync();
      }
      File image = File(img.path);
      File newimage = await image.copy('${dir!.path}/${DateTime.now()}.jpg');
      imagelist.value.add(newimage.path);
      imagelist.notifyListeners();
    }
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: const Text(
          'ALBUMS',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: const [Icon(Icons.settings), Icon(Icons.add)],
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: imagelist,
        builder: (BuildContext context, List<String> value, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: value.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.file(File(value[index]));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getimsge();
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}

creatList() async {
  final dir = await getExternalStorageDirectory();
  if (dir != null) {
    var listdir = await dir.list().toList();

    for (var i = 0; i < listdir.length; i++) {
      if (listdir[i].path.endsWith('.jpg')) {
        imagelist.value.add(listdir[i].path);
      }
    }
  }
  imagelist.notifyListeners();
}
