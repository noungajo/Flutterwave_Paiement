import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:paiement/fpaie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

//add the following values to create the UI for Flutterwave Payment
class HomePageState extends State<HomePage> {
  //use the currency you would like the user to Pay In, in this case, I used KES currency
  final String currency = FlutterwaveCurrency.XAF;
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController amount = TextEditingController();
  //Add a method to make the flutter wave payment
  //This Method includes all the values needed to create the Flutterwave Instance
  void _makeFlutterwavePayment(BuildContext context, String fullname,
      String phone, String email, String amount) async {
    try {
      Flutterwave flutterwave = Flutterwave.forUIPayment(
          //the first 10 fields below are required/mandatory
          context: this.context,
          fullName: fullname,
          phoneNumber: phone,
          email: email,
          amount: amount,
          //Use your Public and Encription Keys from your Flutterwave account on the dashboard
          encryptionKey: "FLWSECK_TEST990332d87e3f", //"Your Encription Key",
          publicKey:
              "FLWPUBK_TEST-18f56d16cc98c46123f261389e1fec5d-X", //"Your Public Key",
          currency: currency,
          txRef:
              DateTime.now().toIso8601String(), //on peut mettre ce qu'on veut
          //Setting DebugMode below to true since will be using test mode.
          //You can set it to false when using production environment.
          isDebugMode: true,
          //configure the the type of payments that your business will accept
          acceptCardPayment: true,
          acceptUSSDPayment: true,
          acceptAccountPayment: false,
          acceptFrancophoneMobileMoney:
              true, //pour les pays qui utilise le XAF. Les clients peuvent payer via ce canal
          acceptGhanaPayment: false,
          acceptMpesaPayment: false,
          acceptRwandaMoneyPayment: false,
          acceptUgandaPayment: false,
          acceptZambiaPayment: false);
      //Handle response
      final response = await flutterwave.initializeForUiPayments();
      if (response == null) {
        // l'utilisateur n'a pas terminé la transaction.
        print("Transaction Failed");
      } else {
        if (response.status == "Transaction successful") {
          print("###########################################################");
          print(response.data);
          print("###########################################################");
          print(response.message);
        } else {
          print(response.message);
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(context) {
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: amount,
                          decoration:
                              const InputDecoration(labelText: "Amount"),
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : "Please fill in the Amount you are Paying",
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
                        final amountPaid = amount.text;

                        if (formKey.currentState!.validate()) {
                          _makeFlutterwavePayment(
                              context, name, userPhone, userEmail, amountPaid);
                        }
                      },
                    ),
                  ]),
                ))));
  }
}
