import 'package:erailpass_mobile/context/ticket_model.dart';
import 'package:erailpass_mobile/context/user_model.dart';
import 'package:erailpass_mobile/models/user.dart';
import 'package:erailpass_mobile/widgets/buy_ticket.dart';
import 'package:erailpass_mobile/widgets/my_ticket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDashHomePage extends StatelessWidget {

  const UserDashHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<TicketModel>(context, listen: false).getAll(force: true);

    return Container(
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 4),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Consumer<UserModel>(builder: (context, userModel, child) {
                User? user = userModel.getUser();
                return Text(
                  'Hello ${user?.firstName} ${user?.lastName} !',
                  style: const TextStyle(fontSize: 20),
                );
              }),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.amberAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size(100, 60),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyTicket(),
                  ),
                );
              },
              child: const Text(
                'View My Ticket',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black12, border: Border.all(color: Colors.black38)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              "Book Ticket",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        color: Colors.grey,
                        width: 0,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BuyTicket()),
                            );
                          },
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Buy Ticket",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                  child: const Text(
                    'Apply for a seasonal pass',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      decorationColor: Colors.blue,
                    ),
                  ),
                  onTap: () => {}),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
