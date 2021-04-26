import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flare_flutter/cache.dart';
import 'package:flutter/material.dart';
import 'package:schoolar/config/config.dart';
import 'package:schoolar/models/teacher.dart';
import 'package:schoolar/widgets/header.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StudentSearchPage extends StatefulWidget {
  @override
  _StudentSearchPageState createState() => _StudentSearchPageState();
}

class _StudentSearchPageState extends State<StudentSearchPage>
    with AutomaticKeepAliveClientMixin<StudentSearchPage> {
  TextEditingController textEditingController = TextEditingController();
  final userReference = FirebaseFirestore.instance.collection('teacher');
  Future<QuerySnapshot> futureSearchResults;

  bool get wantKeepAlive => true;

  controlSearching(String str) {
    Future<QuerySnapshot> allTeachers =
        userReference.where("name", isGreaterThanOrEqualTo: str).get();
    setState(() {
      futureSearchResults = allTeachers;
    });
  }

  emptyTheTextFormField() {
    textEditingController.clear();
  }

  Container displayNoSearchResultScreen() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            // Icon(
            //   Icons.group,
            //   color: Colors.grey,
            //   size: 200,
            // ),
            // Text(
            //   "search Teachers",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 65),
            // )
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen() {
    return FutureBuilder(
        future: futureSearchResults,
        builder: (context, datasnapshot) {
          if (!datasnapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<TeacherResult> searchTeacherResult = [];
          datasnapshot.data.docs.forEach((document) {
            Teacher eachteacher = Teacher.fromDocument(document);
            TeacherResult teacherResult = TeacherResult(
              eachteacher: eachteacher,
            );
            searchTeacherResult.add(teacherResult);
          });
          return Expanded(
            child: ListView(
              children: searchTeacherResult,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, isAppTitle: false, strTitle: 'SEARCH'),
        body: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: secondaryColor, width: 10)),
                filled: true,
                prefixIcon: Icon(
                  Icons.person_pin,
                  color: Colors.pink,
                  size: 30.0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.person_pin,
                    color: Colors.pink,
                  ),
                  onPressed: emptyTheTextFormField,
                ),
              ),
              controller: textEditingController,
              onFieldSubmitted: controlSearching,
            ),
            futureSearchResults == null
                ? displayNoSearchResultScreen()
                : displayUserFoundScreen(),
          ],
        ));
  }
}

class TeacherResult extends StatelessWidget {
  final Teacher eachteacher;

  const TeacherResult({Key key, this.eachteacher}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => print('tapped'),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: eachteacher.photourl == null
                      ? AssetImage('assets/user.png')
                      : CachedNetworkImageProvider(eachteacher.photourl),
                ),
                title: Text(
                  eachteacher.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
