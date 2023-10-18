import 'package:flutter/material.dart';
import 'package:tiffin_express_app/models/service_provider_model.dart';
import 'package:tiffin_express_app/screens/admin/admin_screen.dart';
import 'package:tiffin_express_app/screens/basket/basket_screen.dart';
import 'package:tiffin_express_app/screens/checkout/checkout_screen.dart';
import 'package:tiffin_express_app/screens/delivery_time/delivery_time_screen.dart';
import 'package:tiffin_express_app/screens/edit_basket/edit_basket_screen.dart';
import 'package:tiffin_express_app/screens/filter/filter_screen.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';
import 'package:tiffin_express_app/screens/loading/loading_screen.dart';
import 'package:tiffin_express_app/screens/location/location_screen.dart';
import 'package:tiffin_express_app/screens/login/login_screen.dart';
import 'package:tiffin_express_app/screens/my_order/my_order_screen.dart';
import 'package:tiffin_express_app/screens/profile/edit_profile_screen.dart';
import 'package:tiffin_express_app/screens/profile/profile_screen.dart';
import 'package:tiffin_express_app/screens/register/register_screen.dart';
import 'package:tiffin_express_app/screens/register/service_provider_register_screen.dart';
import 'package:tiffin_express_app/screens/service_provider_drawer/other_information.dart';
import 'package:tiffin_express_app/screens/service_provider_drawer/service_provider_manage_order_detail_screen.dart';
import 'package:tiffin_express_app/screens/service_provider_drawer/service_provider_manage_order_screen.dart';
import 'package:tiffin_express_app/screens/service_provider_drawer/service_provider_menu_item_screen.dart';
import 'package:tiffin_express_app/screens/service_provider_drawer/service_provider_profile_screen.dart';
import 'package:tiffin_express_app/screens/service_provider_screen/service_provider_screen.dart';
import 'package:tiffin_express_app/screens/tiffin_service_providers_details/tiffin_service_providers_details_screen.dart';
import 'package:tiffin_express_app/screens/tiffin_service_provider_listing/tiffin_service_provider_listing_screen.dart';
import 'package:tiffin_express_app/screens/voucher/voucher_screen.dart';

import '../screens/my_order/my_order_detail_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is ${settings.name}');

    switch (settings.name) {
      case '/':
        return HomeScreen.route();
      case LocationScreen.routeName:
        return LocationScreen.route();
      case BasketScreen.routeName:
        return BasketScreen.route();
      case CheckoutScreen.routeName:
        return CheckoutScreen.route();
      case DeliveryTimeScreen.routeName:
        return DeliveryTimeScreen.route();
      case BasketScreen.routeName:
        return BasketScreen.route();
      case MyLogin.routeName:
        return MyLogin.route();
      case MyRegister.routeName:
        return MyRegister.route();
      case ProfilePage.routeName:
        return ProfilePage.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case EditProfilePage.routeName:
        return EditProfilePage.route();
      case TiffinOrderScreen.routeName:
        return TiffinOrderScreen.route();
      case LoadingScreen.routeName:
        return LoadingScreen.route();
      case OrderDetailsScreen.routeName:
        return OrderDetailsScreen.route();
      case AdminScreen.routeName:
        return AdminScreen.route();
      case ServiceProviderSignUp.routeName:
        return ServiceProviderSignUp.route();
      case ServiceProviderInfoScreen.routeName:
        return ServiceProviderInfoScreen.route();
      case ServiceProviderScreen.routeName:
        return ServiceProviderScreen.route();
      case ManageOrderScreen.routeName:
        return ManageOrderScreen.route();
      // case ServiceProvideOrderDetailScreen.routeName:
      //   return ServiceProvideOrderDetailScreen.route();
      case ServiceProviderMenuScreen.routeName:
        return ServiceProviderMenuScreen.route();
      case EditBasketScreen.routeName:
        return EditBasketScreen.route();
      case FilterScreen.routeName:
        return FilterScreen.route();
      case FilterScreen.routeName:
        return FilterScreen.route();
      case TiffinServiceProvidersScreen.routeName:
        final serviceProvider = settings.arguments as ServiceProvider;

        return TiffinServiceProvidersScreen.route(serviceProvider);
      case TiffinServiceProviderListingScreen.routeName:
        return TiffinServiceProviderListingScreen.route(
          serviceProvider: settings.arguments as  List<ServiceProvider>
        );
        case VoucherScreen.routeName:
        return VoucherScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
            ),
        settings: const RouteSettings(
          name: '/error',
        ));
  }
}
