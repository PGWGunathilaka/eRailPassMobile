import 'package:erailpass_mobile/common/datepicker.dart';
import 'package:erailpass_mobile/common/stations_dropdown.dart';
import 'package:erailpass_mobile/common/textbox.dart';
import 'package:erailpass_mobile/context/ticket_model.dart';
import 'package:erailpass_mobile/models/station.dart';
import 'package:erailpass_mobile/models/ticket.dart';
import 'package:erailpass_mobile/services/payment_service.dart';
import 'package:erailpass_mobile/widgets/my_ticket.dart';
import 'package:erailpass_mobile/widgets/ticket_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyTicket extends StatefulWidget {
  final Station? fromStation;
  final Station? toStation;
  final DateTime? date;

  const BuyTicket({super.key, this.fromStation, this.toStation, this.date});

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  Station? _fromStation;
  Station? _toStation;
  DateTime? _date;
  int? _tClass;
  int? _noOfTickets;
  int? _ticketPrice;

  @override
  void initState() {
    super.initState();
    _fromStation = widget.fromStation;
    _toStation = widget.toStation;
    _date = widget.date ?? DateTime.now();
    _noOfTickets = 1;
  }

  bool get _canSubmit =>
      _fromStation != null &&
      _toStation != null &&
      _date != null &&
      _tClass != null;

  Ticket createTicket() {
    return Ticket(null, _ticketPrice??0, _fromStation!, _toStation!, _date!, false, _tClass!,
        _noOfTickets!, null);
  }

  void updateTicketPrice() async {
    if (_canSubmit) {
      Ticket ticket = createTicket();
      int ticketPrice = await PaymentService.calculatePayment(ticket);
      setState(() {
        _ticketPrice = ticketPrice * _noOfTickets!;
      });
    }
  }

  void payOnline(BuildContext context) {
    Ticket ticket = createTicket();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TicketPayment(ticket: ticket)),
    );
  }

  void payAtStation(BuildContext context) {
    Ticket ticket = createTicket();
    TicketModel ticketModel = Provider.of<TicketModel>(context, listen: false);
    ticketModel.addTicket(ticket);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyTicket()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Ticket', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.cyan,
        titleTextStyle: const TextStyle(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 10),
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
                    flex: 4,
                    child: StationDropDown(
                      initialValue: _fromStation,
                      onChanged: (value) {
                        setState(() {
                          _fromStation = value;
                        });
                        updateTicketPrice();
                      },
                    ),
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
                    flex: 4,
                    child: StationDropDown(
                      initialValue: _toStation,
                      onChanged: (value) {
                        setState(() {
                          _toStation = value;
                        });
                        updateTicketPrice();
                      },
                    ),
                  ),
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
                    flex: 4,
                    child: DatePicker(
                      color: Color (0xffacfffc),
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
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text('Class'),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: DropdownMenu<int>(
                      onSelected: (value) {
                        setState(() {
                          _tClass = value;
                        });
                        updateTicketPrice();
                      },
                      dropdownMenuEntries: tClasses.entries.map((e) {
                        return DropdownMenuEntry(
                            value: e.key, label: e.value, enabled: e.key != 1);
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
              TextBoxWidget(
                label: 'No of Tickets',
                keyboardType: TextInputType.number,
                onChanged: (String val) {
                  setState(() {
                    _noOfTickets = int.parse(val);
                  });
                  updateTicketPrice();
                },
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 80, child: Text('Total Price ')),
                  Text((_ticketPrice != null) ? "LKR $_ticketPrice" : "",
                    style: const TextStyle(color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                    onPressed: _canSubmit ? () => payOnline(context) : null,
                    child: const Text('Pay Online',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
                    onPressed: _canSubmit ? () => payAtStation(context) : null,
                    child: const Text('Pay at Station',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
