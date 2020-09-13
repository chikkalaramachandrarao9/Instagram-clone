import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:insta/models/user.dart';
import 'package:insta/services/database/postdatabase.dart';
import 'package:provider/provider.dart';
import 'package:insta/screens/shared/loading.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  File _imageFile;
  bool loading = false;

  String url = "";
  String _uploadFileName = "";

  TextEditingController tagcontroller = TextEditingController();

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    print('success');
  }

//  Future<void> _cropImage() async {
//    print('cropper');
//    File cropped = await ImageCropper.cropImage(
//      sourcePath: _imageFile.path,
//      // ratioX: 1.0,
//      // ratioY: 1.0,
//      // maxWidth: 512,
//      // maxHeight: 512,
//
////        toolbarColor: Colors.purple,
////        toolbarWidgetColor: Colors.white,
////        toolbarTitle: 'Crop It'
//    );
//
//    setState(() {
//      _imageFile = cropped ?? _imageFile;
//    });
//  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
      _uploadFileName = 'images/${DateTime.now()}.png';
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);

    PostDatabaseService _databaseService = PostDatabaseService(uid: user.uid);

    // TODO: implement build
    return loading
        ? spinkit3
        : Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    color: Colors.blueGrey,
                    icon: Icon(
                      Icons.photo_camera,
                      size: 50.0,
                    ),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  IconButton(
                    color: Colors.blueGrey,
                    icon: Icon(
                      Icons.photo_library,
                      size: 50.0,
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              _imageFile != null
                  ? Container(
                      color: Colors.grey[200],
                      height: 300.0,
                      child: Image.file(_imageFile))
                  : Container(
                      color: Colors.grey[200],
                      height: 150.0,
                      child: Center(
                          child:
                              Text('Click the above icons to choose image!')),
                    ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 50.0,
                  ),
                  FlatButton(
                    child: Icon(Icons.crop),
//              onPressed: _cropImage,
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  FlatButton(
                    child: Icon(Icons.clear),
                    onPressed: _clear,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tagcontroller,
                  decoration: InputDecoration(
                    hintText: 'Write about this!',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1.0)),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lime, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                child: Text('Post'),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  await _uploadFile(_imageFile, _uploadFileName);

                  await _databaseService.updateUserData(
                      tagcontroller.text, url);
                  _clear();
                  tagcontroller.text = '';
                  setState(() {
                    loading = false;
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Saved Successfully'),
                    duration: Duration(seconds: 3),
                  ));
                },
              ),
            ],
          );
  }
}
