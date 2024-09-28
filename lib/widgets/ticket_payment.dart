import 'package:erailpass_mobile/common/date_util.dart';
import 'package:erailpass_mobile/common/textbox.dart';
import 'package:erailpass_mobile/common/toast.dart';
import 'package:erailpass_mobile/models/app_response.dart';
import 'package:erailpass_mobile/models/ticket.dart';
import 'package:erailpass_mobile/services/payment_service.dart';
import 'package:erailpass_mobile/widgets/my_ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class TicketPayment extends StatefulWidget {
  final Ticket ticket;

  const TicketPayment({
    super.key,
    required this.ticket,
  });

  @override
  State<TicketPayment> createState() => _TicketPaymentState();
}

class _TicketPaymentState extends State<TicketPayment> {
  late Ticket _ticket;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
    initPaymentSheet();
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final response = await PaymentService.createPaymentSheet(_ticket);
      if (!response.success) {
        debugPrint('Error: No response received initPaymentSheet');
        showToast('Error: No response received initPaymentSheet');
        return;
      }
      final data = response.data!;

      debugPrint(data.toString());
      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['paymentIntent'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
            address: AddressCollectionMode.never,
          ),
          applePay: null,
          googlePay: null,
          // Extra options
          // applePay: const PaymentSheetApplePay(
          //   merchantCountryCode: 'US',
          // ),
          // googlePay: const PaymentSheetGooglePay(
          //   merchantCountryCode: 'US',
          //   testEnv: true,
          // ),
          style: ThemeMode.light,
        ),
      );
      setState(() {
        _ready = true;
      });
    } catch (e) {
      debugPrint('Error: $e');
      showToast('Error: $e');
      rethrow;
    }
  }

  void checkout() {
    debugPrint("Going to Checkout");
    debugPrint(Stripe.instance.toString());
    Stripe.instance.presentPaymentSheet().then((value) {
      showToast('Payment Successful');
      Navigator.of(context)
        ..pop()
        ..pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyTicket()),
      );
    }).catchError((e) {
      debugPrint('Error1: $e');
      showToast('Error1: $e');
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Ticket Payment'),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.3, // 50% of the screen width
                  child: const Text(
                    'From ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(_ticket.startStation.name, style: TextStyle(fontSize: 18)),
              ],
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'To ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(_ticket.endStation.name, style: TextStyle(fontSize: 18)),
              ],
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'Date ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(dateToString(_ticket.date),
                    style: TextStyle(fontSize: 18)),
              ],
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'Class ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(_ticket.getTClass().toString(),
                    style: TextStyle(fontSize: 18)),
              ],
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'No of Passengers ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(_ticket.noOfTickets.toString(),
                    style: TextStyle(fontSize: 18)),
              ],
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5)),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    'Price ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(_ticket.price.toString(), style: TextStyle(fontSize: 18)),
              ],
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              onPressed: () => checkout(),
              child: const Center(
                child: Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
