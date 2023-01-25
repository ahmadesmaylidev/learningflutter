import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              title: const Center(
                  child: Text(
            'Ahmad',
            style: TextStyle(fontSize: 30),
          ))),
          body: const DialogTest()),
    );
  }
}

class DialogTest extends StatefulWidget {
  const DialogTest({super.key});

  @override
  State<DialogTest> createState() => _DialogTestState();
}

class _DialogTestState extends State<DialogTest> {
  ValueNotifier<File> photoNotifier = ValueNotifier(File(''));
  File? photo;
  File? photoCamera;

  Future _getPhoto() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage == null) {
      return;
    }

    final myphoto = File(selectedImage.path);
    photo = myphoto;
    visible = true;
    photoNotifier.value = File(selectedImage.path);
  }

  Future _getPhotoCamera() async {
    final takedPhoto =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (takedPhoto == null) {
      return;
    }
    visible = true;
    photo = File(takedPhoto.path);
    photoNotifier.value = File(takedPhoto.path);
  }

  bool visible = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Center(
                  child: ValueListenableBuilder(
                      valueListenable: photoNotifier,
                      builder: (context, value, index) {
                        if (value.path == '') {
                          return const ClipOval(
                            child: Image(
                              image: AssetImage('images/dp.jpg'),
                              fit: BoxFit.cover,
                              height: 150,
                              width: 150,
                            ),
                          );
                        }
                        return ClipOval(
                          child: Image.file(
                            photo!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 25,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text('Loud Image from',
                                        style: TextStyle(fontSize: 20))),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _getPhotoCamera();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Camera'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _getPhoto();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Gallery'),
                                      ),
                                      Visibility(
                                        visible: visible,
                                        child: TextButton(
                                          onPressed: () {
                                            photoNotifier.value = File('');
                                            photo = File('');
                                            visible = false;
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Remove Image',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.camera_enhance,
                    color: Color.fromARGB(255, 82, 81, 81),
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _getPhotoCamera();
            },
            child: const Text('import image from camera'),
          ),
          ElevatedButton(
            onPressed: () {
              _getPhoto();
            },
            child: const Text('import image  from gallery'),
          ),
          ElevatedButton(
            onPressed: () {
              photoNotifier.value = File('');
              photo = File('');
              visible = false;
            },
            child: const Text('Delete Image'),
          ),
          TextButton(
            onPressed: () {},
            // ignore: prefer_const_constructors
            style: ButtonStyle(),
            child: const Text('dialog'),
          ),
        ],
      ),
    );
  }
}
