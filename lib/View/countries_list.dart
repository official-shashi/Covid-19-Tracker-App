import 'package:covid_tracker/Services/states_services.dart';
import 'package:covid_tracker/View/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState() {}
              },
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: 'Search With Country Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0))),
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: statesServices.countriesListApi(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return Shimmer.fromColors(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                              height: height * .18,
                              width: width * .18,
                              color: Colors.white),
                          title: Container(
                              height: height * .02, color: Colors.white),
                          subtitle: Container(
                              height: height * .02, color: Colors.white),
                        );
                      },
                    ),
                    baseColor: Colors.grey.shade700,
                    highlightColor: Colors.grey.shade100);
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    String name = snapshot.data![index]['country'];
                    if (searchController.text.isEmpty) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  image: snapshot.data![index]["countryInfo"]["flag"],
                                  name: snapshot.data![index]["country"],
                                  totalCases: snapshot.data![index]["todayCases"].toString(),
                                  test: snapshot.data![index]["tests"].toString(),
                                  active: snapshot.data![index]["active"].toString(),
                                  totalDeaths: snapshot.data![index]["todayDeaths"].toString(),
                                  critical: snapshot.data![index]["critical"].toString(),
                                  todayRecovered: snapshot.data![index]["todayRecovered"].toString(),
                                  totalRecovered: snapshot.data![index]["recovered"].toString(),
                                ),
                              ));
                        },
                        child: ListTile(
                          leading: Image(
                              height: height * .18,
                              width: width * .18,
                              image: NetworkImage(snapshot.data![index]
                                  ['countryInfo']['flag'])),
                          title: Text(snapshot.data![index]['country']),
                          subtitle:
                              Text(snapshot.data![index]['cases'].toString()),
                        ),
                      );
                    } else if (name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  image: snapshot.data![index]["countryInfo"]["flag"],
                                  name: snapshot.data![index]["country"],
                                  totalCases: snapshot.data![index]["todayCases"].toString(),
                                  test: snapshot.data![index]["tests"].toString(),
                                  active: snapshot.data![index]["active"].toString(),
                                  totalDeaths: snapshot.data![index]["todayDeaths"].toString(),
                                  critical: snapshot.data![index]["critical"].toString(),
                                  todayRecovered: snapshot.data![index]["todayRecovered"].toString(),
                                  totalRecovered: snapshot.data![index]["recovered"].toString(),
                                ),
                              ));
                        },
                        child: ListTile(
                          leading: Image(
                              height: height * .18,
                              width: width * .18,
                              image: NetworkImage(
                                  snapshot.data![index]['countryInfo']['flag'])),
                          title: Text(snapshot.data![index]['country']),
                          subtitle:
                              Text(snapshot.data![index]['cases'].toString()),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              }
            },
          ))
        ],
      )),
    );
  }
}
