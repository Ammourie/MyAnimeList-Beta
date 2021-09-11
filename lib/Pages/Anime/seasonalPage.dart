import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:malbeta/API/api.dart';
import 'package:malbeta/Widgets/Anime/anime_card.dart';
import 'package:malbeta/models/Anime/AnimeDetailsModel.dart';
import 'package:sizer/sizer.dart';

class SeasonalAnimesPage extends StatefulWidget {
  @override
  _SeasonalAnimesPageState createState() => _SeasonalAnimesPageState();
}

class _SeasonalAnimesPageState extends State<SeasonalAnimesPage> {
  String year;
  List<String> years = [];
  List<String> seasons = ["winter", "spring", "summer", 'fall'];
  String season;
  List<AnimeDetailsModel> animes = [];
  bool fetchingFlag = true;
  void fetch({String year, String season}) async {
    setState(() {
      fetchingFlag = true;
    });
    animes = await API().fetchSeasonalAnimes(year: year, season: season);

    setState(() {
      fetchingFlag = false;
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 1970; i <= 2022; i++) {
      years.add(i.toString());
    }
    year = years[years.length - 1];
    years.add("later");
    season = seasons[0];
    fetch(year: "2022", season: "winter");
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text(
        'Seasonal Animes',
        style:
            TextStyle(fontFamily: "Gibson", fontSize: 22, color: Colors.black),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    var bodyColumn = Expanded(
      child: ListView.builder(
        itemCount: animes.length,
        itemBuilder: (context, index) => AnimeCard(
          anime: animes[index],
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //   child: Text(
                  //     "Choose Season:",
                  //     style: TextStyle(
                  //         fontFamily: "Gibson",
                  //         fontSize: 18.0.sp,
                  //         color: Colors.black),
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Year:",
                              style: TextStyle(
                                  fontFamily: "Gibson",
                                  color: Colors.black,
                                  fontSize: 15.0.sp),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GFDropdown(
                                dropdownColor: Colors.white,
                                dropdownButtonColor: Colors.grey.shade200,
                                iconEnabledColor: Colors.black,
                                iconSize: 20.0.sp,
                                style: TextStyle(
                                    fontFamily: "Gibson",
                                    color: Colors.black,
                                    fontSize: 15.0.sp),
                                value: year.toString(),
                                items: years
                                    .map(
                                      (e) => new DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    year = value;
                                    fetch(season: season, year: year);
                                  });
                                }),
                          ],
                        ),
                        Row(children: [
                          Text(
                            "Season:",
                            style: TextStyle(
                                fontFamily: "Gibson",
                                color: Colors.black,
                                fontSize: 15.0.sp),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GFDropdown(
                            dropdownColor: Colors.white,
                            dropdownButtonColor: Colors.grey.shade200,
                            iconEnabledColor: Colors.black,
                            iconSize: 20.0.sp,
                            style: TextStyle(
                                fontFamily: "Gibson",
                                color: Colors.black,
                                fontSize: 15.0.sp),
                            value: season.toString(),
                            items: seasons
                                .map(
                                  (e) => new DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (value) async {
                              setState(() {
                                season = value;
                                fetch(season: season, year: year);
                              });
                            },
                          )
                        ]),
                      ]),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              fetchingFlag
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : animes.length == 0
                      ? Expanded(
                          child: Center(
                            child: Text(
                              "No Animes Found!!",
                              style: TextStyle(
                                fontFamily: "Gibson",
                                fontSize: 30,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        )
                      : bodyColumn,
            ])));
  }
}
