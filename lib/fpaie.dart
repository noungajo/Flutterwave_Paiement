import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';

class PaymentWidget extends StatefulWidget {
  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final String txref = "My_unique_transaction_reference_123";
  final String amount = "200";
  final String currency = FlutterwaveCurrency.RWF;
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter + Flutterwave'),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    const Padding(padding: EdgeInsets.all(10.0)),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: fullname,
                        decoration:
                            const InputDecoration(labelText: "Full Name"),
                        validator: (value) => value!.isNotEmpty
                            ? null
                            : "Please fill in Your Name",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: phone,
                          decoration:
                              const InputDecoration(labelText: "Phone Number"),
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : "Please fill in Your Phone number",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: email,
                          decoration: const InputDecoration(labelText: "Email"),
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : "Please fill in Your Email",
                        ),
                      ),
                    ),
                    //make a payment
                    ElevatedButton(
                      child: const Text('Pay with Flutterwave'),
                      onPressed: () {
                        final name = fullname.text;
                        final userPhone = phone.text;
                        final userEmail = email.text;
                        final amountPaid = amount;
                        var response;
                        if (formKey.currentState!.validate()) {
                          response =
                              beginPayment(context, name, userPhone, userEmail);
                        }
                        if (checkPaymentIsSuccessful(response)) {
                          print("everything is ok ");
                        }
                      },
                    ),
                  ]),
                ))));
  }

  beginPayment(
      BuildContext context, String fullname, String phone, String email) async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
        context: context,
        encryptionKey: "FLWSECK_TEST990332d87e3f",
        publicKey: "FLWPUBK_TEST-18f56d16cc98c46123f261389e1fec5d-X",
        currency: currency,
        amount: amount,
        email: "valid@email.com",
        fullName: "Valid Full Name",
        txRef: this.txref,
        isDebugMode: true,
        phoneNumber: "0123456789",
        acceptCardPayment: true,
        acceptUSSDPayment: false,
        acceptAccountPayment: false,
        acceptFrancophoneMobileMoney: false,
        acceptGhanaPayment: false,
        acceptMpesaPayment: false,
        acceptRwandaMoneyPayment: true,
        acceptUgandaPayment: false,
        acceptZambiaPayment: false);

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction.
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          return response;
          // provide value to customer
        } else {
          // check message
          print(response.message);

          // check status
          print(response.status);

          // check processor error
          print(response.data!.processorResponse);
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data!.currency == currency &&
        response.data!.amount == amount &&
        response.data!.txRef == txref;
  }
}
