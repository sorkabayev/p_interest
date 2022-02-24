import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/model.dart';
import '../service/servics.dart';

class InPicturePage extends StatefulWidget {
  const InPicturePage({
    Key? key,
    required this.imag,
  }) : super(key: key);

  final Post imag;

  static const String id = "in_picture_page";

  @override
  _InPicturePageState createState() => _InPicturePageState();
}

class _InPicturePageState extends State<InPicturePage> {
  TextEditingController controller = TextEditingController();

  List<Post> unlash = [];
  List<UserLinks> unlash2 = [];

  ///#Get
  void apiUserList() {
    Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {if (response != null) _showResponse(response)});
  }

  ///#Get2
  void apiUserList2() {
    Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {if (response != null) _showResponse2(response)});
  }

  ///#ShowingS
  void _showResponse(String response) {
    List<Post> post = Network.parsePostList(response);
    if (kDebugMode) {
      print(Post);
    }
    setState(() {
      unlash = post;
    });
  }

  ///#Showing
  void _showResponse2(String response) {
    int currentIndex = 2;
    List<UserLinks> post2 = Network.parseUserLinksList(response);
    print(UserLinks);
    setState(() {
      unlash2 = post2;
    });
  }

  ///#Initstate
  @override
  void initState() {
    super.initState();
    apiUserList();
    apiUserList2();
    // apiUserOne();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
            children: [
              Stack(children: [
                Container(
                  padding: const EdgeInsets.only(top: 25),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      image: NetworkImage(widget.imag.urls.small),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 25),
                  width: MediaQuery.of(context).size.width,
                  height: 680,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const SizedBox(
                                      height: 100,
                                      child: Center(child: Text("Jarayonda>>>...",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                                  ));
                            },
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 35,
                            )),
                      ),
                      const SizedBox(
                        height: 550,
                      ),
                      Align(alignment: Alignment.bottomRight,
                          child: IconButton(onPressed: (){
                            showModalBottomSheet( context: context,
                                builder: (context) => SizedBox(
                                  height: 500,
                                  child: Column(
                                    children:  const [
                                      Text("Search",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              isScrollControlled: true
                            );
                          }, icon: Icon(Icons.image_search_outlined,size: 30,color: Colors.white70,),

                          )),
                    ],
                  ),
                )
              ]),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(widget.imag.user.profileImage.medium),
                        ),
                        title: Text(widget.imag.user.name),
                        subtitle: Text("${widget.imag.likes.toString()} Followers"),
                      ),
                      Align( alignment : Alignment.center,
                          child: Text(widget.imag.altDescription.toString())),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                        height: 100,
                                        child: Center(child: Text("Jarayonda>>>...",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                                    ));
                              },
                              icon: const Icon(CupertinoIcons.chat_bubble_fill)),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.white54,
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                      height: 100,
                                      child: Center(child: Text("Jarayonda>>>...",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                                  ));
                            },
                            child: const Text("Go Over"),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.redAccent,
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                      height: 100,
                                      child: Center(child: Text("Qidiruvdan yuklagan maqul format kichik",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                                  ));
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                    height: 100,
                                    child: Center(child: Text("Jarayonda>>>...",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))
                                ));
                          }, icon: const Icon(Icons.share)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                child: Column(
                  children: [
                    Text(
                      "Add Comment",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              widget.imag.user.totalPhotos.toString()),
                        ),
                        Container(
                          width: 200,
                          child: Column(
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                child: Text(widget.imag.user.name),
                              ),
                              MaterialButton(
                                onPressed: () {},
                                child: Text(
                                  "${widget.imag.likes.toString()} likes",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(widget.imag.user.profileImage.medium),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.grey),
                              color: Colors.white30),
                          height: 55,
                          width: 300,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.done,
                            controller: controller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add coment",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
            Container(
              padding: EdgeInsets.only(top: 20,left: 10),
              height: 50,
              width: 50,
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 30,),),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
