import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:task/checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task/homePage.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  var items;
  var table_menu_list;
  int table_menu_listLength = 0;
  List<String> cartItems = [];
  int totalCart = 0;

  _addPrefernces() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setStringList("itemlist", cartItems);
    sharedPreferences.setInt("totalcart", totalCart);
  }

  final String uri = "https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad";
  String name = '';
  String email = '';
  String id = '';
  String profile = '';

  _fetchUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString("name")!;
    email = sharedPreferences.getString("email")!;

    id = sharedPreferences.getString("id")!;

    profile = sharedPreferences.getString("photo")!;
  }

  showingPro() async {
    await fetchdata();
    table_menu_list = items[0]['table_menu_list'];
    table_menu_listLength = (table_menu_list.length);
    print(table_menu_list[0]['menu_category']);
  }

  Future<http.Response> fetchdata() async {
    Response resp = await http.get(Uri.parse(uri));
    if (resp.statusCode == 200) {
      // print(resp.body);
      setState(() {
        items = json.decode(resp.body);
      });

      return resp;
    } else {
      print(resp.statusCode);
      return resp;
    }
  }

  @override
  void initState() {
    super.initState();
    showingPro();
    _fetchUserDetails();
    _addPrefernces();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: table_menu_listLength,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Badge(
                    animationType: BadgeAnimationType.scale,
                    badgeContent: Text(
                      totalCart.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CheckoutScreen()));
                      },
                      color: Colors.black54,
                      iconSize: 30,
                    )),
              ),
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.pink,
            indicatorColor: Colors.pink,
            unselectedLabelColor: Colors.black87,
            tabs: [
              Tab(
                child: Text(
                  table_menu_list[0]['menu_category'],
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Tab(
                child: Text(table_menu_list[1]['menu_category'],
                    style: TextStyle(fontSize: 18)),
              ),
              Tab(
                child: Text(table_menu_list[2]['menu_category'],
                    style: TextStyle(fontSize: 18)),
              ),
              Tab(
                child: Text(table_menu_list[3]['menu_category'],
                    style: TextStyle(fontSize: 18)),
              ),
              Tab(
                child: Text(table_menu_list[4]['menu_category'],
                    style: TextStyle(fontSize: 18)),
              ),
              Tab(
                child: Text(table_menu_list[5]['menu_category'],
                    style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Center(
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      gradient: LinearGradient(colors: [
                        Colors.green.shade900,
                        Colors.lightGreen.shade300
                      ])),
                  currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Image.network(profile)),
                  accountEmail: Text(id),
                  accountName: Text(name),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.black45),
                ),
                onTap: () async{
                    await FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
                   Fluttertoast.showToast(
                              msg: "Logged out sucessfully");
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: TabBarView(
            children: [
              SubMenuFetcher(
                listItem: table_menu_list[0]['category_dishes'],
                scrImage: table_menu_list[4]['menu_category_image'].toString(),
              ),
              SubMenuFetcher(
                  listItem: table_menu_list[1]['category_dishes'],
                  scrImage:
                      table_menu_list[4]['menu_category_image'].toString()),
              SubMenuFetcher(
                  listItem: table_menu_list[2]['category_dishes'],
                  scrImage:
                      table_menu_list[4]['menu_category_image'].toString()),
              SubMenuFetcher(
                  listItem: table_menu_list[3]['category_dishes'],
                  scrImage:
                      table_menu_list[4]['menu_category_image'].toString()),
              SubMenuFetcher(
                  listItem: table_menu_list[4]['category_dishes'],
                  scrImage:
                      table_menu_list[4]['menu_category_image'].toString()),
              SubMenuFetcher(
                  listItem: table_menu_list[5]['category_dishes'],
                  scrImage:
                      table_menu_list[4]['menu_category_image'].toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class SubMenuFetcher extends StatefulWidget {
  final List listItem;
  final String scrImage;

  const SubMenuFetcher(
      {Key? key, required this.listItem, required this.scrImage})
      : super(key: key);
  @override
  _SubMenuFetcherState createState() => _SubMenuFetcherState();
}

class _SubMenuFetcherState extends State<SubMenuFetcher> {
  int totalCart = 0;

  fetchitemNum() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      totalCart = sharedPreferences.getInt("totalcart")!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchitemNum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listItem.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            ListTile(
              title: Wrap(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.listItem[index]['dish_Type'] == 2)
                        Icon(
                          Icons.crop_square_sharp,
                          color: Colors.green,
                          size: 25,
                        ),
                      if (widget.listItem[index]['dish_Type'] == 1)
                        Icon(
                          Icons.crop_square_sharp,
                          color: Colors.red,
                          size: 25,
                        ),
                      if (widget.listItem[index]['dish_Type'] == 2)
                        Icon(Icons.circle, color: Colors.green, size: 10),
                      if (widget.listItem[index]['dish_Type'] == 1)
                        Icon(Icons.circle, color: Colors.red, size: 10),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      widget.listItem[index]['dish_name'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (" INR " +
                              widget.listItem[index]['dish_price'].toString()),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ((widget.listItem[index]['dish_calories'])
                                  .toString() +
                              " Calories"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                      child: Text(
                        (widget.listItem[index]['dish_description'].toString()),
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              //  trailing: Image.network(widget.listItem[index]['dish_image']),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 5.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(70),
                    ),
                    color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();

                          var itemList =
                              sharedPreferences.getStringList("itemlist");
                        },
                        icon: Icon(Icons.remove),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                      Text(
                        totalCart.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();

                          var itemList =
                              sharedPreferences.getStringList("itemlist");

                          Map<String, dynamic> item = {
                            "item_name": widget.listItem[index]['dish_name'],
                            "item_price":
                                widget.listItem[index]['dish_price'].toString(),
                            "item_calories": (widget.listItem[index]
                                    ['dish_calories'])
                                .toString(),
                            "item_type": (widget.listItem[index]['dish_Type'])
                          };

                          String singleItem = json.encode(item);

                          itemList!.add(singleItem);

                          print(itemList);

                          sharedPreferences.setStringList("itemlist", itemList);

                          setState(() {
                            totalCart = totalCart + 1;
                            sharedPreferences.setInt("totalCart", totalCart);
                          });

                          Fluttertoast.showToast(
                              msg: "Added to cart sucessfully");
                        },
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 5,
            )
          ],
        );
      },
    );
  }
}
