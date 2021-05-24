import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  // final Map<String , dynamic> items;

  const CheckoutScreen({
    Key? key,
  }) : super(key: key);
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<String> items = [];
  int listItem = 0;

  _fetchItem() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      items = sharedPreferences.getStringList("itemlist")!;
      print(items);

      items = items.toSet().toList();
      listItem = items.length;
      print(items);
    });
  }

  showList() async {
    await _fetchItem();
  }

  @override
  void initState() {
    showList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(0, 80),
        child: AppBar(
          automaticallyImplyLeading: false,
          actions: [],
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Text(
                  "Order Summary",
                  style: TextStyle(color: Colors.black45, fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.green[900],
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                    child: Text(
                  "$listItem Dishes - $listItem items",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                )),
              ),
            ),
          ),
          ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: listItem,
              itemBuilder: (BuildContext context, int index) {
                var item = json.decode(items[index]);

                print(item);
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Wrap(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                if (item['item_type'] == 2)
                                  Icon(
                                    Icons.crop_square_sharp,
                                    color: Colors.green,
                                    size: 25,
                                  ),
                                   if (item['item_type'] == 1)
                                  Icon(
                                    Icons.crop_square_sharp,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                if (item['item_type'] == 2)
                                  Icon(Icons.circle,
                                      color: Colors.green, size: 10),
                                        if (item['item_type'] == 1)
                                  Icon(Icons.circle,
                                      color: Colors.red, size: 10),

                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    item['item_name'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  (" INR " + item['item_price']),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  ("112 " + item['item_calories']),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            
                          
                          ],
                        ),
                       
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                            "0",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                            onPressed: () async {
                             
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();

                              var itemList =
                                  sharedPreferences.getStringList("itemlist");

                              Map<String, dynamic> currentitem = {
                                "item_name": item['dish_name'],
                                "item_price":
                                   item['dish_price'].toString(),
                                "item_calories": (item
                                        ['dish_calories'])
                                    .toString(),
                                "item_type": (item
                                        ['dish_Type'])
                              };

                              String singleItem = json.encode(currentitem);

                              itemList!.add(singleItem);

                              print(itemList);

                              sharedPreferences.setStringList("itemlist", itemList);
                              setState(() {
                                
                              });
                            },
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            iconSize: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),   Text(
                              (" INR " +  item['item_price']),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 5,
                        color: Colors.black,
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
