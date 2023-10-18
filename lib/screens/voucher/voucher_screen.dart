import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:tiffin_express_app/blocs/basket/basket_bloc.dart';
import 'package:tiffin_express_app/blocs/voucher/voucher_bloc.dart';
import 'package:tiffin_express_app/models/voucher_model.dart';
import 'package:tiffin_express_app/repositories/voucher/voucher_repository.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  static const String routeName = '/vouchers';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const VoucherScreen(),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 20)),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  shape: RoundedRectangleBorder(),
                  primary: Theme.of(context).colorScheme.secondary,
                ),
                child: Text('Apply'),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter a Voucher Code',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 17,
                  color: Color.fromARGB(255, 13, 50, 172),
                  fontWeight: FontWeight.bold),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Voucher Code',
                          contentPadding: const EdgeInsets.all(10)),
                          onChanged: (value) async {
                            print(await VoucherRepository().searchVoucher(value));
                          },
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Your Vouchers',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 17,
                  color: Color.fromARGB(255, 13, 50, 172),
                  fontWeight: FontWeight.bold),
            ),
            BlocBuilder<VoucherBloc, VoucherState>(
              builder: (context, state) {
                if (state is VoucherLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is VoucherLoaded) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.vouchers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1x',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 13, 50, 172))),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Text(
                                state.vouchers[index].code,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    fontSize: 13),
                              )),
                              TextButton(
                                  onPressed: () {
                                    context.read<VoucherBloc>()
                                      ..add(SelectVoucher(
                                          voucher: state.vouchers[index]));
                                    Navigator.pop(context);
                                  },
                                  child: Text('Apply')),
                            ],
                          ),
                        );
                      });
                } else {
                  return Text('Something Went Wrong');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
