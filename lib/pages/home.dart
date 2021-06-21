import 'package:cocktail/data/data.dart';
import 'package:cocktail/my_flutter_app_icons.dart';
import 'package:cocktail/pages/ingredients/listIngredients.dart';
import 'package:cocktail/pages/ingredients/listCocktailsSaved.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final data = Get.put(DataLocal());
  int index = 0;
  final page = [ListIngredientsRoute(), ListIngredientsSavedRoute()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "The Cocktail",
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(233, 59, 129, 1),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
                icon: Icon(
                  data.darkMode.value ? MyFlutterApp.moon_1 : MyFlutterApp.moon,
                  size: 18.sp,
                ),
                onPressed: () {
                  data.changeDarkMode({
                    'darkMode': (!data.darkMode.value),
                    'cocktailsSaved': data.cocktailsSaved.value
                  });
                }),
          )
        ],
      ),
      body: page[index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          backgroundColor: Color.fromRGBO(233, 59, 129, 1),
          selectedItemColor: Colors.white,
          iconSize: 17.sp,
          selectedIconTheme: IconThemeData(size: 25.sp),
          unselectedItemColor: Colors.white.withOpacity(.4),
          onTap: (i) {
            setState(() => index = i);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: Container()),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), title: Container())
          ]),
    );
  }
}
