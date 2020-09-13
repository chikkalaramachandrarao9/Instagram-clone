import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/user.dart';
import 'package:insta/screens/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AboutMe extends StatefulWidget {
  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  final namecntrl = TextEditingController();
  final aboutmecntrl = TextEditingController();
  bool loading = false;
  var _image;
  String _uploadedFileURL;

  String url = '';
  String name = '';
  String aboutMe = '';

  Future<void> _uploadFile(File file, String filename) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    print('success');
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        _uploadedFileURL = 'images/${DateTime.now()}.png';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);
    UserDatabaseService _database = UserDatabaseService(uid: user.uid);

    return StreamBuilder<UserProfileWithUid>(
      stream: UserDatabaseService(uid: user.uid).userData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          UserProfileWithUid details = snapshot.data;

//          aboutmecntrl.text = details.aboutMe;
//          namecntrl.text = details.name;

          namecntrl.text = details.name;
          aboutmecntrl.text = details.aboutMe;
          url = details.dpurl;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Edit',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.limeAccent,
            ),
            body: loading
                ? spinkit3
                : Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        CircleAvatar(
                          radius: 45.0,
                          backgroundImage: _image == null
                              ? NetworkImage(details.dpurl)
                              : FileImage(_image),
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          child: Text('Choose image'),
                          onPressed: () async {
                            await chooseFile();
                            print('file choosen');
                          },
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: namecntrl,
                            decoration: InputDecoration(
                              hintText: 'Profile Name',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0)),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lime, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: aboutmecntrl,
                            decoration: InputDecoration(
                              hintText: 'About you',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0)),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lime, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                            color: Colors.lime[400],
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () async {
                              print('pressed');
                              setState(() {
                                loading = true;
                              });
                              print('hello');
                              if (_image != null)
                                await _uploadFile(_image, _uploadedFileURL);

                              await _database.updateUserData(
                                  namecntrl.text, aboutmecntrl.text, url);
                              setState(() {
                                loading = false;
                              });
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Updated Successfully'),
                                duration: Duration(seconds: 3),
                              ));
                            }),
                        SizedBox(height: 12.0),
                      ],
                    ),
                  ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
