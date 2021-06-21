import 'package:cocktail/API/api.dart';
import 'package:cocktail/data/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:sizer/sizer.dart';

class PageCocktail extends StatefulWidget {
  Map<String, dynamic> data;
  PageCocktail({this.data});

  @override
  _PageCocktailState createState() => _PageCocktailState();
}

class _PageCocktailState extends State<PageCocktail> {
  String url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=";
  String language = "";
  bool cocktailIsSaved = false;
  final data = Get.put(DataLocal());
  Future call;

  //#region Widget
  Widget section(String category, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: RichText(
                  text: TextSpan(style: TextStyle(fontSize: 12.sp), children: [
                TextSpan(
                    text: "$category",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value, style: TextStyle(color: Colors.white)),
              ])),
            ),
          ),
        )
      ],
    );
  }

  Widget divider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.h),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 1,
        color: Colors.grey,
      ),
    );
  }

  List<Widget> getIngredients(BuildContext context, var value) {
    String elements = "";

    for (int i = 1; i <= 15; i++) {
      if (value["strIngredient$i"] != null)
        elements += value["strIngredient$i"] + ", ";
      else
        break;
    }

    return [
      Container(
        width: 80.w,
        child: Text(
          elements,
          style: TextStyle(fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      )
    ];
  }
  //#endregion

  bool searchCocktailInSaved() {
    final output = data.cocktailsSaved
        .where((value) => value["idDrink"] == widget.data["idDrink"]);
    return output.length > 0;
  }

  void addNewCocktail() {
    setState(() => cocktailIsSaved = !cocktailIsSaved);
    final value = {
      'strDrink': widget.data["strDrink"],
      'strDrinkThumb': widget.data["strDrinkThumb"],
      'idDrink': widget.data["idDrink"],
    };

    if (cocktailIsSaved)
      data.cocktailsSaved.add(value);
    else
      data.cocktailsSaved.removeWhere(
          (element) => element["idDrink"] == widget.data["idDrink"]);

    data.localDataWrite({
      'darkMode': data.darkMode.value,
      'cocktailsSaved': data.cocktailsSaved
    });
  }

  List<DropdownMenuItem<String>> getLaunguage(Map<String, dynamic> snap) {
    List<DropdownMenuItem<String>> items = [];
    List launguages = ["", "ES", "DE", "FR", "IT"];

    for (var i in launguages) {
      if (snap["strInstructions" + i] != null)
        items.add(
          DropdownMenuItem(
              value: i,
              child: Text(
                i == "" ? "EN" : i,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              )),
        );
    }

    return items;
  }

  @override
  void initState() {
    super.initState();
    call = API().call(url + widget.data["idDrink"]);
    cocktailIsSaved = searchCocktailInSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data["strDrink"],
          style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(233, 59, 129, 1),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              icon: Icon(
                cocktailIsSaved ? Icons.bookmark : Icons.bookmark_border,
                size: 19.sp,
              ),
              onPressed: () => addNewCocktail())
        ],
      ),
      body: FutureBuilder(
        future: call,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(blurRadius: 2)]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.data["strDrinkThumb"],
                          fit: BoxFit.contain,
                          errorBuilder: (context, object, _) => Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                          loadingBuilder: (_, child, chunk) {
                            if (chunk != null)
                              return Center(child: CircularProgressIndicator());
                            else
                              return child;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                divider(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      section("CATEGORY: ", snapshot.data[0]["strCategory"]),
                      section("Alcoholic: ", snapshot.data[0]["strAlcoholic"]),
                    ],
                  ),
                ),
                divider(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "INGREDIENTS:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.sp),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: getIngredients(context, snapshot.data[0]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "INSTRUCTIONS:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.sp),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Container(
                              width: 80.w,
                              child: Text(
                                snapshot.data[0]["strInstructions" + language],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 4.h,
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                      iconSize: 14.sp,
                                      onChanged: (value) {
                                        setState(() => language = value);
                                      },
                                      underline: Container(),
                                      value: language,
                                      items: getLaunguage(snapshot.data[0])),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}
