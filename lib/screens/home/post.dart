import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/models/user.dart';
import 'package:insta/services/database/postdatabase.dart';
import 'package:provider/provider.dart';
import 'package:insta/screens/shared/loading.dart';
import 'package:path/path.dart';
//import 'package:photofilters/photofilters.dart';
//import 'package:image/image.dart' as imageLib;

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool dark;

  File _imageFile;
  bool loading = false;

//  List<Filter> filters = presetFiltersList;

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
    dark = Provider.of<bool>(context);

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
                    color: Color.fromARGB(255, 254, 91, 3),
                    icon: Icon(
                      Icons.photo_camera,
                      size: 50.0,
                    ),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  IconButton(
                    color: Color.fromARGB(255, 254, 91, 3),
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
                      color: dark ? Colors.grey[800] : Colors.grey[200],
                      height: 300.0,
                      child: Image.file(_imageFile))
                  : Container(
                      color: dark ? Colors.grey[800] : Colors.grey[200],
                      height: 150.0,
                      child: Center(
                          child: Text(
                        'Click the above icons to choose image!',
                        style: TextStyle(
                            color: dark ? Colors.white : Colors.black),
                      )),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.delete,
                      color: dark ? Colors.white : Colors.black,
                    ),
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
                  style: TextStyle(color: dark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Write about this!',
                    hintStyle: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                    ),
                    fillColor:
                        dark ? Color.fromARGB(255, 44, 44, 44) : Colors.white,
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
                color: Color.fromARGB(255, 248, 90, 44),
                child: Text(
                  'Post',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_imageFile != null) {
                    setState(() {
                      loading = true;
                    });

                    await _uploadFile(_imageFile, _uploadFileName);
                    await _databaseService.updatePostData(
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
                  }
                },
              ),
            ],
          );
  }
}
