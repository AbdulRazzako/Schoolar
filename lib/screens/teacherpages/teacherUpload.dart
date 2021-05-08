import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:schoolar/api/firebase_api.dart';
// import 'package:schoolar/config/config.dart';
import 'package:schoolar/models/user.dart';
import 'package:schoolar/service/database.dart';
// import 'package:file_picker/file_picker.dart';

import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// final Reference storageReference =
//     FirebaseStorage.instance.ref().child("Post Picture");
// final userData = Provider.of<UserData>(context, listen: false);

class TeacherUploadPage extends StatefulWidget {
  @override
  _TeacherUploadPageState createState() => _TeacherUploadPageState();
}

class _TeacherUploadPageState extends State<TeacherUploadPage>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  File file;
  bool isUploading = false;
  String postId = Uuid().v4();
  // String _description;
  UploadTask task;
  UserDatabaseService db = UserDatabaseService();

  final picker = ImagePicker();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }

  Widget displayUploadScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            color: Colors.grey,
            size: 100,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Upload Image",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              color: Colors.white,
              // onPressed: () => takeImage(context),
              onPressed: pickImageFromGallery,
            ),
          )
        ],
      ),
    );
  }

  takeImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'New Post',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              // SimpleDialogOption(
              //   child: Text(
              //     "Capture Image with Camera",
              //   ),
              //   onPressed: captureImageWithCamera,
              // ),
              SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  // void captureImageWithCamera() async {
  //   Navigator.pop(context);
  //   File imagefile = await ImagePicker.pickImage(
  //       source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
  //   if (mounted) {
  //     setState(() {
  //       this.file = imagefile;
  //     });
  //   }
  // }

  void pickImageFromGallery() async {
    // Navigator.pop(context);

    // File imageFile = await ImagePicker.pickImage(
    //   source: ImageSource.gallery,
    // );
    // File imageFile;
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No Image selected');
      }
    });

    // if (mounted) {
    //   setState(() {
    //     this.file = imageFile;
    //   });
    // }
  }

  displayUploadFormScreen() {
    final userData = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.pink,
          ),
          onPressed: clearPost,
        ),
        title: Text(
          "New Post ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        // actions: [
        //   FlatButton(
        //     onPressed: () => print('tapped'),
        //     child: Text(
        //       "share",
        //       style: TextStyle(
        //         color: Colors.lightGreenAccent,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 16,
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: ListView(
        children: [
          isUploading ? LinearProgressIndicator() : Text(''),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: userData.photourl == null
                  ? AssetImage('assets/user.png')
                  : CachedNetworkImageProvider(userData.photourl),
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                    hintText: "Description", border: InputBorder.none),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed:
                  // isUploading ? null :
                  () => controlUploadAndSave(),
              color: Colors.blue,
              child: Text(
                "Upload",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void clearPost() {
    setState(() {
      file = null;
      descriptionTextEditingController.clear();
    });
  }

  controlUploadAndSave() async {
    setState(() {
      isUploading = true;
    });

    final userData = Provider.of<UserData>(context, listen: false);
    String uid = userData.uid;

    // _description = descriptionTextEditingController.text;
    String filename = file.path.split('/').last;
    // Reference reference =
    //     FirebaseStorage.instance.ref().child("$uid/$filename");
    final destination = 'Posts/$uid/$filename';
    task = FirebaseApi.uploadTask(destination, file);
    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    db.savePostInfoToFireStore(
        uid: userData.uid,
        url: urlDownload,
        description: descriptionTextEditingController.text,
        postid: postId,
        username: userData.name);
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });

    // await firebase_storage.FirebaseStorage.instance
    //     .ref(filename)
    //     .child(uid)
    //     .putFile(file);
  }

  void savePostInfoToFireStore({String url, String description}) {}
}
