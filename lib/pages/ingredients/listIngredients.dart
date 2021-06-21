import 'package:cocktail/API/api.dart';
import 'package:cocktail/pages/ingredients/ingredientPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';

class ListIngredientsRoute extends StatefulWidget {
  @override
  _ListIngredientsRouteState createState() => _ListIngredientsRouteState();
}

class _ListIngredientsRouteState extends State<ListIngredientsRoute> {
  Future _calling;
  List ingredientsFinal = [];
  List ingredients = [];

  // Scrolling for see
  TextEditingController textEditingController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();
  bool searchBarShowing = false;

  //#region Functions of app
  Future call() async {
    final data = ingredients = await API()
        .call("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list");
    setState(() {
      ingredients = data;
      ingredientsFinal = data;
    });
    return true;
  }

  void onScroll() {
    if (_scrollController.position.pixels > 200) {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward)
        setState(() => searchBarShowing = true);
      else
        setState(() => searchBarShowing = false);
    } else
      setState(() => searchBarShowing = false);
  }

  void searchCocktail(String value) {
    setState(() {
      List newData = [];
      for (var i in ingredientsFinal) {
        if (i["strIngredient1"].length >= value.length) {
          if (i["strIngredient1"].substring(0, value.length) == value)
            newData.add(i);
        }
      }
      ingredients = newData;
    });
  }
  //#endregion

  Widget partOne() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(10), child: textFormField()),
      ],
    );
  }

  Widget textFormField() {
    return TextFormField(
      onChanged: (v) => searchCocktail(v),
      controller: textEditingController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          fillColor: Theme.of(context).cardColor,
          filled: true,
          hintText: 'Search your favourite ingredient',
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(width: 2, color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(width: 2, color: Colors.lightBlue))),
    );
  }

  @override
  void initState() {
    super.initState();
    _calling = call();
    _scrollController.addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _calling,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done)
            return Stack(
              children: [
                Scrollbar(
                    child: ListView(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        children: [
                      partOne(),
                      for (var i in ingredients)
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PageIngredients(
                                        name: i["strIngredient1"],
                                      ))),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                i["strIngredient1"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp),
                              ),
                            ),
                          ),
                        ),
                    ])),
                // TEXTFORMFIELD ANIMATION
                AnimatedPositioned(
                    top: searchBarShowing ? 0 : -60,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: textFormField()),
                    ),
                    duration: Duration(milliseconds: 500))
              ],
            );
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}
