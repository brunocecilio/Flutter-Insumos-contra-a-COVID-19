import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:insumos_covid19/util/number_formatter.dart';
import 'package:intl/intl.dart';

import 'package:insumos_covid19/model/data_entry.dart';

class Lista extends StatelessWidget {
  Lista(this.data);

  final dateFormatter = new DateFormat('dd/MM/yyyy');
  final dateFormatterScroll = new DateFormat('MM/yyyy');

  final ScrollController _scrollController = ScrollController();

  final List<DataEntry> data;

  Widget _buildItemsForListView(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
            child: Padding(
          padding: EdgeInsets.all(7),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            data[index].material,
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 16),
                          ),
                          Text(
                            toStringSepareted(data[index].quantidade.toInt()) +
                                ' ' +
                                data[index].unidade +
                                '(s)',
                            textAlign: TextAlign.center,
                          )
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Text(
                            data[index].status,
                            textAlign: TextAlign.center,
                          ),
                          Icon(Icons.arrow_right),
                          Text(
                            dateFormatter.format(data[index].dtSaida),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            data[index].requisitante,
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 16),
                          ),
                        ],
                      ))
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableScrollbar.semicircle(
          controller: _scrollController,
          labelTextBuilder: (double offset) => Text(
                '${dateFormatterScroll.format(data[offset ~/ 95].dtSaida)}',
                style: TextStyle(fontSize: 12),
              ),
          child: ListView.builder(
              itemExtent: 95,
              controller: _scrollController,
              itemCount: data.length,
              itemBuilder: _buildItemsForListView)),
    );
  }
}
