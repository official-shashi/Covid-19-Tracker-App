import 'package:covid_tracker/View/WorldState.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
   String image;
   String name;
   String totalCases;
   String totalDeaths;
   String totalRecovered;
   String active;
   String critical;
   String todayRecovered;
   String test;
   DetailsScreen({
     Key? key,
     required this.image,
     required this.name,
     required this.totalCases,
     required this.totalDeaths,
     required this.totalRecovered,
     required this.active,
     required this.critical,
     required this.todayRecovered,
     required this.test}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(widget.name),
      centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * .06),
              child: Card(
                child: Column(
                  children: [
                    SizedBox(height: height * .06,),
                    ReusableRow(
                      title: 'Cases',
                      value: widget.totalCases,
                    ),
                    ReusableRow(
                      title: 'Active',
                      value: widget.active,
                    ),
                    ReusableRow(
                      title: 'Recovered',
                      value: widget.todayRecovered,
                    ),
                    ReusableRow(
                      title: 'Deaths',
                      value: widget.test,
                    ),
                    ReusableRow(
                      title: 'Critical',
                      value: widget.critical,
                    ),
                    ReusableRow(
                      title: 'Tests',
                      value: widget.test,
                    ),
                    ReusableRow(
                      title: 'Total Recovered',
                      value: widget.totalRecovered,
                    ),
                  ],
                ),
              ),
            ),
            CircleAvatar(
              radius: 50,backgroundImage: NetworkImage(widget.image),)
          ],
        )
      ]),
    );
  }
}
