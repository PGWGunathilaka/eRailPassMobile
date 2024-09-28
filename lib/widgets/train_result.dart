import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/models/train.dart';
import 'package:erailpass_mobile/services/token_holder.dart';
import 'package:erailpass_mobile/services/train_service.dart';
import 'package:erailpass_mobile/widgets/buy_ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class TrainResult extends StatefulWidget {
  const TrainResult(
      {super.key, required this.from, required this.to, required this.date});

  final Station from;
  final Station to;
  final DateTime? date;

  @override
  State<TrainResult> createState() => _TrainResultState();
}

class _TrainResultState extends State<TrainResult> {
  final TokenHolder _tokenHolder = TokenHolder();

  Future<List<Train>> _searchTrains() async {
    return TrainService.searchTrains(widget.from, widget.to, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.from.name} - ${widget.to.name}"),
        backgroundColor: const Color(0xff72b54a),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.centerRight,
              child: Visibility(
                visible: _tokenHolder.getToken() != null,
                replacement: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(child: Text('Please login to buy to tickets')),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xff209ef3)),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Remove the 'const' keyword here
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Color(0xff209ef3)),
                        ),
                      ),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyTicket(
                            fromStation: widget.from,
                            toStation: widget.to,
                            date: widget.date),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlueAccent),
                  ),
                  child: const Text(
                    "Buy Ticket",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Train>>(
              future: _searchTrains(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Train>> snapshot) {
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  debugPrintStack(stackTrace: snapshot.stackTrace);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: snapshot.data!
                            .map((t) => TrainResultEntry(
                                train: t, from: widget.from, to: widget.to))
                            .toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TrainResultEntry extends StatelessWidget {
  final Train train;
  final Station from;
  final Station to;

  const TrainResultEntry(
      {super.key, required this.train, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    String? fromTime =
        train.stops.firstWhereOrNull((s) => s.station.id == from.id)?.time;
    String? toTime =
        train.stops.firstWhereOrNull((s) => s.station.id == to.id)?.time;
    return Container(
      margin: const EdgeInsets.only(left: 6, right: 6, bottom: 10),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    train.trainNo ?? "",
                    style:
                        const TextStyle(fontSize: 20, color: Colors.blueGrey),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Text(
                    train.name ?? "",
                    style:
                        const TextStyle(fontSize: 20, color: Colors.blueGrey),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(from.name ?? "",
                          style: const TextStyle(color: Colors.blueGrey)),
                      Text(
                        fromTime ?? "10.30",
                        style: const TextStyle(
                            fontSize: 24, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  const Expanded(
                      child: Padding(padding: EdgeInsets.only(top: 10))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(to.name ?? "",
                          style: const TextStyle(color: Colors.blueGrey)),
                      Text(
                        toTime ?? "14.55",
                        style: const TextStyle(
                            fontSize: 24, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
