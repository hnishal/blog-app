import 'package:blog_app/services/crud.dart';
import 'package:blog_app/view/blog.dart';
import 'package:blog_app/view/create.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();
  QuerySnapshot? blogSnapshot;

  Widget BlogList() {
    return Container(
      child: Column(
        children: <Widget>[
          blogSnapshot != null
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: blogSnapshot!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return BlogsTile(
                        imgUrl: blogSnapshot!.docs[index].get('imageUrl'),
                        title: blogSnapshot!.docs[index].get('title'),
                        description: blogSnapshot!.docs[index].get('desc'),
                        authorName:
                            blogSnapshot!.docs[index].get('authorName'));
                  })
              : Container(
                  margin: EdgeInsets.only(bottom: 16),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogSnapshot = result;
      });
      super.initState();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog", style: TextStyle(fontSize: 22)),
      ),
      body: BlogList(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateBlog()));
            },
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl = "", title = "", description = "", authorName = "";
  BlogsTile(
      {required this.imgUrl,
      required this.title,
      required this.description,
      required this.authorName});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogPage(
                    authorName: authorName,
                    description: description,
                    title: title,
                    imgUrl: imgUrl)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 150,
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imgUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )),
            Container(
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.black38.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6))),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    authorName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
