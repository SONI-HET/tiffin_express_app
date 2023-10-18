import 'package:tiffin_express_app/models/voucher_model.dart';

import '../../models/models.dart';

abstract class BaseVoucherRepository {
  Future<bool> searchVoucher(String code);
  Stream<List<Voucher>> getVouchers();
} 
