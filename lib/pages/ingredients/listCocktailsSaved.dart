import 'package:cocktail/data/data.dart';
import 'package:cocktail/pages/cocktails/pageCocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ListIngredientsSavedRoute extends StatefulWidget {
  @override
  _ListIngredientsSavedRouteState createState() =>
      _ListIngredientsSavedRouteState();
}

class _ListIngredientsSavedRouteState extends State<ListIngredientsSavedRoute> {
  Widget cocktailCardStyle(var value) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PageCocktail(
                data: value,
              ))),
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 80.sp,
                height: 80.sp,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.1),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5, color: Colors.black.withOpacity(.4))
                    ],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1,
                      color: Colors.black.withOpacity(.1),
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    value["strDrinkThumb"],
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
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(
                "${value["strDrink"]}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataLocal>(
        builder: (data) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: data.cocktailsSaved.length == 0
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        "You don't have any cocktail saved :(\nYou can do that. Click on the cocktail image and save the cocktail which you like",
                        style: TextStyle(fontSize: 13.sp),
                        textAlign: TextAlign.center,
                      ),
                    ))
                  : ListView(
                      children: [
                        for (var i in data.cocktailsSaved) cocktailCardStyle(i)
                      ],
                    ),
            ));
  }
}
