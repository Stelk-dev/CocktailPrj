import 'package:cocktail/API/api.dart';
import 'package:cocktail/data/data.dart';
import 'package:cocktail/my_flutter_app_icons.dart';
import 'package:cocktail/pages/cocktails/pageCocktail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PageIngredients extends StatefulWidget {
  String name;
  PageIngredients({this.name});

  @override
  _PageIngredientsState createState() => _PageIngredientsState();
}

class _PageIngredientsState extends State<PageIngredients> {
  String url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=";
  String language = "";
  bool cocktailIsSaved = false;
  final data = Get.put(DataLocal());
  Future call;

  bool searchCocktailInSaved() {
    final output =
        data.cocktailsSaved.where((value) => value[1] == widget.name);
    return output.length > 0;
  }

  void addNewCocktail(Map<String, dynamic> snapshot) {
    setState(() => cocktailIsSaved = !cocktailIsSaved);
    final value = {
      'strDrink': snapshot["strDrink"],
      'strDrinkThumb': widget.name,
      'idDrink': widget.name,
    };

    if (cocktailIsSaved)
      data.cocktailsSaved.add(value);
    else
      data.cocktailsSaved.removeWhere((element) => element == widget.name);

    data.localDataWrite(
        {'darkMode': data.darkMode.value, 'ingredients': data.cocktailsSaved});
  }

  @override
  void initState() {
    super.initState();
    call = API().call(url + widget.name);
    cocktailIsSaved = searchCocktailInSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(233, 59, 129, 1),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: call,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scrollbar(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: EdgeInsets.all(10),
                children: [
                  for (var i in snapshot.data)
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => PageCocktail(
                                    data: i,
                                  ))),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(.4))
                              ],
                              image: DecorationImage(
                                image: NetworkImage(
                                  i["strDrinkThumb"],
                                ),
                                fit: BoxFit.contain,
                              )),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                child: Text(
                                  i["strDrink"],
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )),
                    ),
                ],
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
}
