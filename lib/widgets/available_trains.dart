import 'dart:ui' as ui;

import 'package:erailpass_mobile/common/datepicker.dart';
import 'package:erailpass_mobile/common/stations_dropdown.dart';
import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/widgets/train_result.dart';
import 'package:flutter/material.dart';

class AvailableTrainsPageOuter extends StatelessWidget {
  const AvailableTrainsPageOuter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Check available trains'),
          backgroundColor: const Color(0xff72b54a),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(child: const AvailableTrains()));
  }
}

class AvailableTrains extends StatefulWidget {
  const AvailableTrains({super.key});

  @override
  State<AvailableTrains> createState() => _AvailableTrainsState();
}

class _AvailableTrainsState extends State<AvailableTrains> {
  Station? _fromStation;
  Station? _toStation;
  DateTime? _date = _getToday();

  bool get _canSubmit => _fromStation != null && _toStation != null && _date != null;

  static DateTime _getToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(1.0), Colors.black.withOpacity(0.0)],
                    stops: const [0.1, 0.4]).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'images/Background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            )),
        const AspectRatio(
          aspectRatio: 5.0,
          child: Image(
              alignment: Alignment.center,
              image: AssetImage(
                'images/logo11.png',
              )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
              color: Colors.white.withOpacity(0.9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          padding: const EdgeInsets.only(right: 18),
                          child: const Text('From'),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: StationDropDown(onChanged: (value) {
                          setState(() {
                            _fromStation = value;
                          });
                        }),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Text('To'),
                        ),
                      ),
                      Flexible(
                          flex: 6,
                          child: StationDropDown(onChanged: (value) {
                            setState(() {
                              _toStation = value;
                            });
                          })),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Text('Date'),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: DatePicker(
                          initialDate: _date,
                          onChange: (DateTime date) {
                            setState(() {
                              _date = date;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff72b54a),
                      ),
                      onPressed: _canSubmit
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TrainResult(from: _fromStation!, to: _toStation!, date: _date)),
                              );
                            }
                          : null,
                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
