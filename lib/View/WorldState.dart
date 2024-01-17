import 'package:covid_tracker/Model/WorldStatesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../Services/states_services.dart';
import 'countries_list.dart';

class WorldState extends StatefulWidget {
  const WorldState({Key? key}) : super(key: key);

  @override
  State<WorldState> createState() => _WorldStateState();
}

class _WorldStateState extends State<WorldState> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: height * .03,
          ),
          FutureBuilder(
            future: statesServices.fetchWorldStatesRecords(),
            builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                  flex: 1,
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                    size: height * .06,
                    controller: _controller,
                  ),
                );
              } else {
                return Column(
                  children: [
                    PieChart(
                      dataMap: {
                        "Total": double.parse(snapshot.data!.cases!.toString()),
                        "Recovered":
                            double.parse(snapshot.data!.recovered!.toString()),
                        "Deaths":
                            double.parse(snapshot.data!.deaths!.toString())
                      },
                      chartValuesOptions:
                          const ChartValuesOptions(showChartValuesInPercentage: true),
                      animationDuration: const Duration(milliseconds: 1200),
                      chartType: ChartType.ring,
                      chartRadius: width * .40,
                      legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left),
                      colorList: colorList,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height * .03,horizontal: width * .01),
                      child: Card(
                        child: Column(
                          children: [
                            ReusableRow(
                                title: 'Total Cases',
                                value: snapshot.data!.cases!.toString()),
                            ReusableRow(
                                title: 'Deaths',
                                value: snapshot.data!.deaths!.toString()),
                            ReusableRow(
                                title: 'Recovered',
                                value: snapshot.data!.recovered!.toString()),
                            ReusableRow(
                                title: 'Active',
                                value: snapshot.data!.active!.toString()),
                            ReusableRow(
                                title: 'Critical',
                                value: snapshot.data!.critical!.toString()),
                            ReusableRow(
                                title: 'Today Deaths',
                                value: snapshot.data!.todayDeaths!.toString()),
                            ReusableRow(
                                title: 'Today Recovered',
                                value:
                                    snapshot.data!.todayRecovered!.toString()),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width * .02),
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color(0xff1aa260),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                          child: Text('Track Countries',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CountriesListScreen(),)),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      )),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;

  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider()
        ],
      ),
    );
  }
}
