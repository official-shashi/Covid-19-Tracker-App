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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search TextField
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {}); // Rebuild UI on text change
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  hintText: 'Search With Country Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
            // ListView Builder with Search Filter
            Expanded(
              child: FutureBuilder(
                future: statesServices.countriesListApi(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    // Display shimmer effect while data is loading
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade700,
                      highlightColor: Colors.grey.shade100,
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                              height: height * .18,
                              width: width * .18,
                              color: Colors.white,
                            ),
                            title: Container(
                              height: height * .02,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              height: height * .02,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    // Filter data based on search query
                    var filteredData = snapshot.data!.where((country) {
                      String countryName = country['country'].toString().toLowerCase();
                      String searchQuery = searchController.text.toLowerCase();
                      return countryName.contains(searchQuery);
                    }).toList();

                    // Display filtered list
                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        String name = filteredData[index]['country'];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  image: filteredData[index]["countryInfo"]["flag"],
                                  name: name,
                                  totalCases: filteredData[index]["todayCases"].toString(),
                                  test: filteredData[index]["tests"].toString(),
                                  active: filteredData[index]["active"].toString(),
                                  totalDeaths: filteredData[index]["todayDeaths"].toString(),
                                  critical: filteredData[index]["critical"].toString(),
                                  todayRecovered: filteredData[index]["todayRecovered"].toString(),
                                  totalRecovered: filteredData[index]["recovered"].toString(),
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Image(
                              height: height * .18,
                              width: width * .18,
                              image: NetworkImage(filteredData[index]['countryInfo']['flag']),
                            ),
                            title: Text(name),
                            subtitle: Text(filteredData[index]['cases'].toString()),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
