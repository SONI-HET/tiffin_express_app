import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffin_express_app/blocs/basket/basket_bloc.dart';
import 'package:tiffin_express_app/models/menu_item_models.dart';
import 'package:get/get.dart';

import 'package:tiffin_express_app/models/service_provider_model.dart';
import 'package:tiffin_express_app/screens/basket/basket_screen.dart';
import 'package:tiffin_express_app/widgets/tiffin_service_provider_information.dart';

String? serviceProviderId;
class DataController extends GetxController {
  var serviceProviderId = ''.obs;
}
class TiffinServiceProvidersScreen extends StatelessWidget {
  TiffinServiceProvidersScreen({Key? key, required this.serviceProvider}) : super(key: key);

  final ServiceProvider serviceProvider;
final DataController dataController = Get.find<DataController>();

  static const String routeName = '/TiffinServiceProvidersDetails';
  static Route route(ServiceProvider serviceProvider) {
    return MaterialPageRoute(
        builder: (_) => TiffinServiceProvidersScreen(serviceProvider: serviceProvider),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                ),
                onPressed: () {
                    // serviceProviderId = serviceProvider.id.toString();
dataController.serviceProviderId.value = serviceProvider.id.toString();

                  Navigator.pushNamed(context, BasketScreen.routeName,
            );
            // print(serviceProvider.id);
                  // Navigator.pushNamed(context, '/Basket');
                },
                child: Text(
                  'Basket',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 225,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width,
                    38,
                  ),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(serviceProvider.imageUrl),
                ),
              ),
            ),
            tiffinServiceProviderInfo(serviceProvider: serviceProvider),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: serviceProvider.menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItems(serviceProvider.menuItems[index], context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(MenuItem menuItem, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text(
            menuItem.name,
            style: Theme.of(context).textTheme.headline3!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(3, 10, 10, 10),
                  child: Text(
                    menuItem.description,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\u{20B9}${menuItem.price}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    BlocBuilder<BasketBloc, BasketState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Color.fromARGB(255, 13, 50, 172),
                          ),
                          onPressed: () {
                            context.read<BasketBloc>()..add(AddItem(menuItem));
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
