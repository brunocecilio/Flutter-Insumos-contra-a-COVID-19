import 'package:flutter/material.dart';

import 'package:insumos_covid19/controller/fetch_data.dart';
import 'package:insumos_covid19/model/covid_data.dart';
import 'package:insumos_covid19/view/lista.dart';
import 'package:insumos_covid19/view/mapa.dart';
import 'package:insumos_covid19/view/graficos.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedNavBarIndex = 0;

  Future<CovidData> data;

  static const TextStyle navBarStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  Widget _widgetOptions(int index, CovidData entryData) {
    Widget page;
    switch (index) {
      case 0:
        {
          page = Mapa(entryData);
        }
        break;
      case 1:
        {
          page = Graficos(entryData);
        }
        break;
      case 2:
        {
          page = Lista(entryData.inputs);
        }
        break;
    }
    return page;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedNavBarIndex = index;
    });
  }

  Future<void> _updateData() async {
    setState(() {
      data = fetchData();
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    data = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return _widgetOptions(_selectedNavBarIndex, snapshot.data);
              else if (snapshot.hasError)
                return LiquidPullToRefresh(
                    child: ListView(
                      children: [
                        SizedBox(
                            height:
                                (MediaQuery.of(context).size.height / 2 - 100)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.signal_wifi_off,
                              size: 60,
                            ),
                            Text("Falha ao recuperar dados")
                            //Text(snapshot.error.toString())
                          ],
                        ),
                      ],
                    ),
                    onRefresh: _updateData);
              return CircularProgressIndicator();
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.room),
            title: Text(
              'Mapa',
              style: navBarStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text(
              'Gráficos',
              style: navBarStyle,
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text(
                'Histórico',
                style: navBarStyle,
              )),
        ],
        currentIndex: _selectedNavBarIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
